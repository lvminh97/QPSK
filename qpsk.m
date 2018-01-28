% Simulation of QPSK Modulation and Demodulation
% John McTavish
% Jan 28, 2018

len = input('Enter the length of bit stream: ');
bitStream = randi([0 1], 1, len);
SNR_dB = input('Enter SNR(dB): ');
% QPSK Modulation
qpskMod = [];
for i=1:2:len
    if bitStream(i) == 0
        if bitStream(i + 1) == 0
            qpskMod = [qpskMod exp(j * pi / 4)];        % 00
        else
            qpskMod = [qpskMod exp(j * 3 * pi / 4)];    % 01
        end
    else
        if bitStream(i + 1) == 0
            qpskMod = [qpskMod exp(j * 7 * pi / 4)];    % 10
        else 
            qpskMod = [qpskMod exp(j * 5 * pi / 4)];    % 11
        end
    end
end
g1 = figure('Name','Constellation');
plot(qpskMod, 'b*');
hold on;
plot(exp(j*[0:0.01:2*pi]),'r--');
axis equal; 
grid on;
title('QPSK Modulation');
% QPSK Demodulation
SNR = 10 ^ (SNR_dB / 10);
qpskDemod = awgn(qpskMod, SNR);
bitStreamDemod = [];
for i=1:length(qpskDemod)
    if real(qpskDemod(i)) >= 0
        if imag(qpskDemod(i)) >= 0
            bitStreamDemod = [bitStreamDemod 0 0];
        else
            bitStreamDemod = [bitStreamDemod 1 0];
        end
    else
        if imag(qpskDemod(i)) >= 0
            bitStreamDemod = [bitStreamDemod 0 1];
        else
            bitStreamDemod = [bitStreamDemod 1 1];
        end
    end
end
g2 = figure('Name','Constellation');
plot(qpskDemod, 'b.');
hold on;
plot(exp(j*[0:0.01:2*pi]),'r--');
plot(exp(j*[pi/4:pi/2:2*pi]),'r*');
axis equal;
title('QPSK Demolation');
% Compute the bit rate error (BER)
diff = 0;
for i=1:length(bitStream)
    if bitStream(i) ~= bitStreamDemod(i)
        diff = diff + 1;
    end
end
disp(sprintf('BER = %.4f',diff / length(bitStream)));