function [locR,locT] = norm_AS(nR,nRx,nT,nTx,nTx_AS,H)

all_com1=nchoosek(1:nT,nTx);
all_com2=nchoosek(1:nR,nRx);
[length_t,~]=size(all_com1);
[length_r,~]=size(all_com2);
Fn=zeros(length_t,length_r);
for i=1:length_t
    w1=all_com1(i,:);
    for jj=1:length_r
        w2=all_com2(jj,:);
        H1=H(w2,w1);
        Fn(i,jj)=sum(sum(abs(H1).^2));
    end
end
maxi=max(max(Fn));
[a,b]=find(Fn==maxi);
locT=all_com1(a(1),:);
locR=all_com2(b(1),:);
end

