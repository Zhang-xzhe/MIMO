%SM��·
clear
clc
close all;
nT=12;%��������
nTx=4; %transmit antenna numbers ����������=3,4,5,6,7,8
nTx_AS=2;                     %  ����������
nR=2;%������������
nRx=1;%receiver antenna numbers ����������
M=4;
% M:  QAM constellation diagram size �������Ʒ�ʽ		2---bpsk; 4---qpsk; 8---8qam; 16---16qam; 32---32qam; 64---64qam
% nTx=2,3ʱ��M=2��4,16,64
% nTx=4,5��6,7,8ʱ��M=2��4,16

% tx_com: the number of Transmit antenna combinations using SM
tx_bit=floor(log2(nchoosek(nTx,nTx_AS)));%the length of bits, which to be coded to select the transmit antenna combination
mod_bit=log2(M);%the length of bits to map
length_bits=tx_bit+nTx_AS*mod_bit;%the length of bits to code
SNR_dB=0:4:24; % SNR[0:3:24]  �����

L_SNR = length(SNR_dB);
BER_m=zeros(1,L_SNR);%������

nErr1=zeros(1,length(SNR_dB));l_errsig1=zeros(1,length(SNR_dB));
nErr2=zeros(1,length(SNR_dB));l_errsig2=zeros(1,length(SNR_dB));
nErr3=zeros(1,length(SNR_dB));l_errsig3=zeros(1,length(SNR_dB));
nErr4=zeros(1,length(SNR_dB));l_errsig4=zeros(1,length(SNR_dB));
nErr5=zeros(1,length(SNR_dB));l_errsig5=zeros(1,length(SNR_dB));
%PPGA��Ԥ��
popsize=4;
G=5;
%% STBCԤ���ֵ
        bits = de2bi(0:2^length_bits-1, 'left-msb')';%nTx ��������ȡһ����һ�����߿��ܵ�ȡֵΪM��
        STBC_set=zeros(nTx,2,size(bits,2));
        for nn = 1:2^length_bits                      
            bits_i=bits(:,nn);    
            STBC_set(:,:,nn)=SM_STBC_n_modulation(bits_i.', tx_bit,nTx,M);
        end
% %%
% hMod = modem.qammod('M', 2^modOrd, 'SymbolOrder', 'gray', 'InputType', 'bit');
% Constellation = modulate(hMod, bits);
%%
iternum=100000; % ��������
tic;
for iter=1:iternum
    tic;
    
    disp(iter);%����������ʾ
    N1 = length_bits; % number of bits or symbols n 
    input_frame = rand(1,N1)>0.5; % generating 0,1 with equal probability %�������������������ɷ����ź�
    output_QAM = SM_STBC_n_modulation(input_frame,tx_bit,nTx,M);
    H = (1/sqrt(2))*(randn(nR,nT) + 1i*randn(nR,nT));%Rayleigh channel  �����ŵ�

    %antenna selection
%     [locR1,locT1]=CGDJAS(nR,nRx,nT,nTx,nTx_AS,H,STBC_set);
    [locR2,locT2]=PPGA_JAS(popsize,nT,nR,G,nT,nTx,nTx_AS,nRx,H);
    locR3=linspace(1,nRx,nRx);locT3=linspace(1,nTx,nTx);
    [locR4,locT4]=norm_AS(nR,nRx,nT,nTx,nTx_AS,H); 
%     [locR5,locT5]=PPGA_JAS_CGD(popsize,nT,nR,G,nT,nTx,nTx_AS,nRx,STBC_set,H);
%     H1=H(locR1,locT1);
    H2=H(locR2,locT2);
    H3=H(locR3,locT3);
    H4=H(locR4,locT4);
%     H5=H(locR5,locT5);
    %�����ź�
%     y1=H1*output_QAM;
    y2=H2*output_QAM;
    y3=H3*output_QAM;
    y4=H4*output_QAM;
%     y5=H5*output_QAM;
    for jj = 1:L_SNR
%         l_errsig1(jj)= ErrSigCalc(y1,SNR_dB(jj),H1,input_frame,length_bits,STBC_set,nRx,nTx_AS);
        l_errsig2(jj)= ErrSigCalc(y2,SNR_dB(jj),H2,input_frame,length_bits,STBC_set,nRx,nTx_AS);
        l_errsig3(jj)= ErrSigCalc(y3,SNR_dB(jj),H3,input_frame,length_bits,STBC_set,nRx,nTx_AS);
        l_errsig4(jj)= ErrSigCalc(y4,SNR_dB(jj),H4,input_frame,length_bits,STBC_set,nRx,nTx_AS);
%         l_errsig5(jj)= ErrSigCalc(y5,SNR_dB(jj),H5,input_frame,length_bits,STBC_set,nRx,nTx_AS);
%         nErr1(jj) = l_errsig1(jj)+nErr1(jj);
        nErr2(jj) = l_errsig2(jj)+nErr2(jj);
        nErr3(jj) = l_errsig3(jj)+nErr3(jj);
        nErr4(jj) = l_errsig4(jj)+nErr4(jj);
%         nErr5(jj) = l_errsig5(jj)+nErr5(jj);
    end
    toc;
end
toc;
%%
% BER1= nErr1/(N1*iter);
BER2= nErr2/(N1*iter);
BER3= nErr3/(N1*iter);
BER4= nErr4/(N1*iter);
% BER5= nErr5/(N1*iter);
% plot(SNR_dB,BER1,'b+-','LineWidth',1,'DisplayName','Optimal CGDAS');
% hold on
%CGDAS
plot(SNR_dB,BER2,'k+-','LineWidth',1,'DisplayName','PGA');
hold on
%��ɫ���Ŵ�(��Ӧ�Ⱥ���Ϊ������
plot(SNR_dB,BER3,'k^-','LineWidth',1,'DisplayName','no selection');
hold on
%��ɫ����ѡ��
plot(SNR_dB,BER4,'ko-','LineWidth',1,'DisplayName','Norm_AS');
hold on
%��ɫ��ֱ�ӷ���ѡ��
% plot(SNR_dB,BER5,'bx-','LineWidth',1,'DisplayName','PPGA_AS(CGD)');
% hold on
%��ɫ���Ŵ��㷨��CGD��
xlabel('SNR gain (dB)');
ylabel('BER');
legend('PGA','No Selection','CNAS');
axis([SNR_dB(1) SNR_dB(end) 10^-5 1])
set(gca,'Yscale','log')
% grid on
save;

