function [huffstream, huffcodes,letters]= source_encoder(filename)
%Example filename='The_Hound_of_the_Baskervilles.txt
%Example filename='lena.bmp';
% calculating probability
%for text 
fileID = fopen(filename,'r');
A = fscanf(fileID,'%c');
A=A(4:length(A));
fclose(fileID);
letters=[];
j=1;
for i=1:length(A)
    if(~(ismember(A(i),letters)))
        letters(j)= char(A(i));
        j=j+1;
    else 
    end
end
letters = char(letters);
count=[]
for k=1:length(letters)
    count(k)=sum(A==letters(k));
end 
xtickstr = [letters]
bar(count./sum(count))
set(gca, 'XTickLabel',xtickstr,'XTick',1:numel(xtickstr))
ylabel('Probability Distribution')
%%
%for image
% img=imread(filename);
% [m,n]=size(img);
% A=[]
% k=1;
% for i = 1: m
%     for j = 1:n
%         A(k)=img(i,j);
%         k = k + 1;
%     end
% end
% letters=[];
% j=1;
% for i=1:length(A)
%     if(~(ismember(A(i),letters)))
%         letters(j)= A(i);
%         j=j+1;
%     else 
%     end
% end
% count=[]
% for k=1:length(letters)
%     count(k)=sum(A==letters(k));
% end 
% xtickstr = [letters];
% bar(count./sum(count))
% set(gca, 'XTickLabel',xtickstr,'XTick',1:numel(xtickstr))
% ylabel('Probability Distribution')
%%
%huffman
s=letters;
p=count;
i=1;
% for m=1:length(p)
%    for n=1:length(p)
%        if(p(m)>p(n))
%          a=p(n);  a1=s(n);
%          p(n)=p(m);s(n)=s(m);  
%          p(m)=a;   s(m)=a1;
%        end
%    end
% end
orig_p = p;
%sort in descending order and storing indices
  L = length(p);
  index = [1:L];
  for m = 1:L
    for n = m:L
      if (p(m) < p(n))
        t = p(m);%temporary
        p(m) = p(n);
        p(n) = t;
        t = index(m);
        index(m) = index(n);
        index(n) = t;
      end
    end
  end

s_list = {};
%final code list for symbols
cw    = cell (1, L);
%structure with probability  and symbols
s_curr = {};
s_curr.p = p;
s_curr.s = {};
S = length (p);
for i = 1:L;
    s_curr.s{i} = [i];
end
  I = 1;
  while (I < S)
    L = length (s_curr.p);
    nprob = s_curr.p(L-1) + s_curr.p(L);
    nsym = [s_curr.s{L-1}(1:end), s_curr.s{L}(1:end)];

%      storing old list.
    s_list{I} = s_curr;

%      insert the new probability into the list
    for i = 1:(L-2)
      if ( s_curr.p(i) < nprob)
        break;
      end
    end
    s_curr.p = [s_curr.p(1:i-1) nprob s_curr.p(i:L-2)];
    s_curr.s = {s_curr.s{1:i-1}, nsym, s_curr.s{i:L-2}};
    I = I + 1;% looping
  end
%highest probable symbol will have one as code
%one_cw = 0;
%zero_cw = 1;
one_cw = 1;
zero_cw = 0;


I = I - 1;
  while (I > 0)
    s_curr = s_list{I};
    L = length (s_curr.s);
    clist = s_curr.s{L};
    for k = 1:length (clist)
      cw{1,clist(k)} = [cw{1,clist(k)} one_cw];
    end
    clist = s_curr.s{L-1};
    for k = 1:length (clist)
      cw{1,clist(k)} = [cw{1,clist(k)}, zero_cw];
    end
     I = I - 1;
    end

nw = cell (1, L);% this contains codes for symbols in descending order of probability
% ordering codes according to symbols order
  L = length (p);
  for i = 1:(L)
    t = cw{index(i)};
    nw{index(i)} = cw{i};
  end
  cw = nw;
  %%
  %for text
fileID = fopen(filename,'r');
seq = fscanf(fileID,'%c');
seq=seq(4:length(seq));
fclose(fileID);
%encoding
[a,b]=ismember(seq,s);
for i=1:length(seq)
    if (b(i)~=0)
        h{i}=cw{b(i)};
    else
        h{i}=3;
    end
end
hdash=horzcat(h{:});%final bitsream
huffstream=hdash;
huffcodes=cw;
%%
% for image
% img=imread(filename);
% [m,n]=size(img);
% A=[]
% k=1;
% for i = 1: m
%     for j = 1:n
%         A(k)=img(i,j);
%         k = k + 1;
%     end
% end
% h={}
% seq=A;
% [a,b]=ismember(seq,s);
% 
% for i=1:length(seq)
%     if (b(i)~=0)
%         h{i}=cw{b(i)};
%     else
%         h{i}=3;
%     end
% end
% hdash=horzcat(h{:});%final bitsream
% huffstream=hdash;
% huffcodes=cw;
end