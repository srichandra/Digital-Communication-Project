function y_n=qam(data,Eb_No)
M = 16;                     % Size of signal constellation
k = log2(M);                % Number of bits per symbol
% data is the huffman encoded bitstream, used for calculating errors in bits
% Eb_No is the SNR per bit value
% y_n is the modulated signal
SNR = Eb_No + 10*log10(k);%Symbol SNR
sym=[]
% making blocks of four bits into symbols
for i= 1: (length(data))/k
    if i==1 sym(i)=bin2dec(num2str(data(1:4)));
    else sym(i)=bin2dec(num2str(data(((i-1)*k+1):((i-1)*k+k))));
    end
end
t = sqrt (M);
%Generating constellations
 real_part = 2 .* floor (sym ./ (t)) - t + 1;
 img_part = -2 .* mod (sym, (t)) + t - 1;
 y = complex(real_part,img_part);
 %y=a+i.*b;
 %Additive white gaussian noise
y_n = awgn(y,SNR,'measured');
end