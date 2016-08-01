function [dmodbitstream,actualBER,theoryBER] = qamdemod(y_n,data,Eb_No)
% y_n is the received signal
% data is the huffman encoded bitstream, used for calculating errors in bits
% Eb_No is the SNR per bit value
M=16;% QAM-16
k = log2(M);%no of bits
%generating reference constellation
ref = [0:M-1];
t = sqrt (M);
real_part = 2 .* floor (ref ./ (t)) - t + 1;
img_part = -2 .* mod (ref, (t)) + t - 1;
%x = a + i.*b;
ref=complex(real_part,img_part);
ref = reshape (ref, 1, M);
dmod = zeros (size (y_n));
for k = 1:numel (y_n)
    [n dmod(k)] = min (abs (y_n(k) - ref));
end
dmod = dmod - 1;
dmodbit=dec2bin(dmod);
[row col]=size(dmodbit)
tot=row*col;
dmodbitstream=[]
dmodbitstream=reshape(dmodbit',1,tot);
%  Calculate Bit Errors
diff = abs( data - dmodbitstream) ;
T_errors=0;
for i= 1: length(data)
    if diff(i) ~= 48
        T_errors =+ 1;
    end
end
T_bits =length(dmodbitstream);      
%  Calculate actual Bit Error Rate 
actualBER= T_errors / T_bits;
%  Calculate Theoretical Bit Error Rate 
theoryBER = (1/4)*3/2*erfc(sqrt(4*0.1*(10.^(Eb_No/10))));
end
