% this function writes the output file and error file
function [err_count]=sourcedecoder(r_stream,huffcodes,letters,filename)
% r_stream is demodulated bitstream
% huffcodes is dictionary huff
%letters is the unique characters in text file/ pixel values in image, this
%is output of the source_encoder. this is for recovering text/image
%filename is the acutal transimmite file, this is used for calculating errors 
%Example filename='The_Hound_of_the_Baskervilles.txt'
%Example filename='lena.bmp';
%err_count is the no.of errors in the decoded file
% binary tree
bt= zeros(1,4);
for i = 1:length(huffcodes)
    nd = 1;
    %Except last bit for rest bits
    for j = 1:(length(huffcodes{i})-1)
        if huffcodes{i}(j) == 0
            % If no node is created
            if bt(nd,1) == 0
                %creating node
                bt(nd,1) = size(bt,1)+1;
                bt(size(bt,1)+1,:) = zeros(1,4);  
            end
            nd = bt(nd,1);
            %if bit is 1
        else
            % If no node is created
            if bt(nd,2) == 0
                % creating node and also a branch
                bt(nd,2) = size(bt,1)+1;
                bt(size(bt,1)+1,:) = zeros(1,4);  
            end
            % going to corresponding node
            nd = bt(nd,2);
        end
    end
    % Final bit=0
	if huffcodes{i}(length(huffcodes{i})) == 0
        bt(nd,1) = 1;
        bt(nd,3) = i;
    % Final bit=1
    else
        bt(nd,2) = 1;
        bt(nd,4) = i;
	end
end

%This stores the decoded data's corresponding indices of the huffman dictionary
rec_indices = [];
nd = 1;
% For each bit...
for j = 1:length(r_stream)
    % bit is 0
    if r_stream(j) == '0'
        % check node
        if bt(nd,3) ~= 0
            rec_indices = [rec_indices, bt(nd,3)];
        end
        % Next node
        nd = bt(nd,1);
    else
        if bt(nd,4) ~= 0
            rec_indices = [rec_indices, bt(nd,4)];
        end
        %Next node
        nd = bt(nd,2);
    end
end
%%
% for text
rec=[]
for i=1:length(rec_indices)
    rec(i)=letters(rec_indices(i));
end
rec=char(rec);
fileID = fopen('out_15.txt','w');
fprintf(fileID,'%c',rec);
fclose(fileID);
fileID = fopen(filename,'r');
A = fscanf(fileID,'%c');
fclose(fileID);
A=A(4:length(A));
err_count=0;
err=[]
for i=1:min(length(rec),length(A))
    if (rec(i)-A(i)==0)
        err(i)= ' ';
    else
        err(i) = '*';
        err_count=err_count+1;
    end
end
fileID = fopen('err_15.txt','w');
fprintf(fileID,'%c',err);
fclose(fileID);
        

%%
%for image
% img=imread(filename);
% [m,n]=size(img)
% rec=[]
% for i=1:length(rec_indices)
%     rec(i)=letters(rec_indices(i));
% end
% k=1;
% for i=1:m
%     for j=1:n
%         f(i,j)=rec(k);
%         k=k+1;
%     end
% end
% figure
% imshow(mat2gray(f))
% imwrite(mat2gray(f),'img_out_15.jpg')
% err=zeros(512,512);
% err_count=0;
% for i=1:m
% for j=1:n
% if(img(i,j)==f(i,j))
%     blank(i,j)=255;
% else 
% err_count= err_count +1;
% end
% end
% end
% figure
% imshow(mat2gray(err))
% imwrite(mat2gray(blank),'err_15.jpg')



%%
end


