function [ch_f_norm] = calobjvalue(pop,nT,nTx,nTx_AS,nRx,H)
%CALOBJVALUE ����Ŀ�꺯�����������Ӽ�����СCGD
%   �˴���ʾ��ϸ˵��
[px,py]=size(pop);
tx_bit=floor(log2(nchoosek(nTx,nTx_AS)));
c=2^tx_bit;
ch_f_norm=zeros(1,px);
for x=1:px
    gene1=pop(x,1:nT);
    gene2=pop(x,nT+1:py);
    [y1,b]= sort(gene1,'descend');
    y(x,:)=y1;%�������еĻ���ֵ
    B(x,:)=b;%Ȩ�ض�Ӧ��λ��
    [~,b]=sort(gene2,'descend');
    locT=B(x,1:nTx);
    locR=b(1:nRx);
    H1=H(locR,locT);
    ch_f_norm(x)=sum(sum(abs(H1).^2));
end
end

