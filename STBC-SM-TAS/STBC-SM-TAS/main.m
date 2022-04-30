%SM链路
clear
clc
close all;
nT=12;%总天线数
nTx=4; %transmit antenna numbers 发射天线数=3,4,5,6,7,8
nTx_AS=2;                     %  激活天线数
nR=2;%接收天线总数
nRx=1;%receiver antenna numbers 接收天线数
M=4;
% M:  QAM constellation diagram size 星座调制方式		2---bpsk; 4---qpsk; 8---8qam; 16---16qam; 32---32qam; 64---64qam
% nTx=2,3时，M=2，4,16,64
% nTx=4,5，6,7,8时，M=2，4,16

% tx_com: the number of Transmit antenna combinations using SM
tx_bit=floor(log2(nchoosek(nTx,nTx_AS)));%the length of bits, which to be coded to select the transmit antenna combination
mod_bit=log2(M);%the length of bits to map
length_bits=tx_bit+nTx_AS*mod_bit;%the length of bits to code
SNR_dB=0:4:24; % SNR[0:3:24]  信噪比

L_SNR = length(SNR_dB);
BER_m=zeros(1,L_SNR);%误码率

nErr1=zeros(1,length(SNR_dB));l_errsig1=zeros(1,length(SNR_dB));
nErr2=zeros(1,length(SNR_dB));l_errsig2=zeros(1,length(SNR_dB));
nErr3=zeros(1,length(SNR_dB));l_errsig3=zeros(1,length(SNR_dB));
nErr4=zeros(1,length(SNR_dB));l_errsig4=zeros(1,length(SNR_dB));
nErr5=zeros(1,length(SNR_dB));l_errsig5=zeros(1,length(SNR_dB));
%PPGA的预设
popsize=4;
G=5;
%% STBC预设的值
        bits = de2bi(0:2^length_bits-1, 'left-msb')';%nTx 根天线中取一根，一根天线可能的取值为M个
        STBC_set=zeros(nTx,2,size(bits,2));
        for nn = 1:2^length_bits                      
            bits_i=bits(:,nn);    
            STBC_set(:,:,nn)=SM_STBC_n_modulation(bits_i.', tx_bit,nTx,M);
        end
% %%
% hMod = modem.qammod('M', 2^modOrd, 'SymbolOrder', 'gray', 'InputType', 'bit');
% Constellation = modulate(hMod, bits);
%%
iternum=100000; % 迭代次数
tic;
for iter=1:iternum
    tic;
    
    disp(iter);%迭代次数显示
    N1 = length_bits; % number of bits or symbols n 
    input_frame = rand(1,N1)>0.5; % generating 0,1 with equal probability %产生比特流，用于生成发射信号
    output_QAM = SM_STBC_n_modulation(input_frame,tx_bit,nTx,M);
    H = (1/sqrt(2))*(randn(nR,nT) + 1i*randn(nR,nT));%Rayleigh channel  瑞利信道

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
    %接收信号
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
%红色，遗传(适应度函数为范数）
plot(SNR_dB,BER3,'k^-','LineWidth',1,'DisplayName','no selection');
hold on
%黑色，不选择
plot(SNR_dB,BER4,'ko-','LineWidth',1,'DisplayName','Norm_AS');
hold on
%绿色，直接范数选择
% plot(SNR_dB,BER5,'bx-','LineWidth',1,'DisplayName','PPGA_AS(CGD)');
% hold on
%蓝色，遗传算法（CGD）
xlabel('SNR gain (dB)');
ylabel('BER');
legend('PGA','No Selection','CNAS');
axis([SNR_dB(1) SNR_dB(end) 10^-5 1])
set(gca,'Yscale','log')
% grid on
save;

