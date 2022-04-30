%SM链路
clear
clc
nTx=8; %transmit antenna numbers 发射天线数=3,4,5,6,7,8
nTx_AS=2;                     %  激活天线数
nRx=2 ;%receiver antenna numbers 接收天线数
M=4;
% M:  QAM constellation diagram size 星座调制方式		2---bpsk; 4---qpsk; 8---8qam; 16---16qam; 32---32qam; 64---64qam
% nTx=2,3时，M=2，4,16,64
% nTx=4,5，6,7,8时，M=2，4,16

% tx_com: the number of Transmit antenna combinations using SM
tx_bit=floor(log2(nchoosek(nTx,nTx_AS)));%the length of bits, which to be coded to select the transmit antenna combination
mod_bit=log2(M);%the length of bits to map
length_bits=tx_bit+nTx_AS*mod_bit;%the length of bits to code
SNR_dB=0:4:24; % SNR[0:3:24]  信噪比
loop_length=[1000 1000 1000 1000 1000 1000 1000 10000]*0.1               ; %循环次数
%loop_length=ones(1,length(SNR_dB))*100;%[100 1000 1000 1000 10000 100000 100000 1000000]*100;循环次数
BER_m=zeros(1,length(SNR_dB));%误码率

%% STBC预设的值
bits = de2bi(0:2^length_bits-1, 'left-msb')';%nTx 根天线中取一根，一根天线可能的取值为M个
STBC_set=zeros(nTx,2,size(bits,2));
for nn = 1:2^length_bits
    bits_i=bits(:,nn);
    STBC_set(:,:,nn)=SM_STBC_n_modulation(bits_i.', tx_bit,nTx,M);
end
%%
for ii = 1:length(SNR_dB)
    tic
    SNR=SNR_dB(ii)
    rou=10^(SNR/10);%the average signal to noise ratio (SNR) at each receive antenna
    N0=nTx_AS/10^(SNR/10);%噪声功率
    num_err_ml=0;%统计错误比特的计量
    num_err_lc=0;
   
    for iter=1:loop_length(ii)       
        N1 = length_bits; % number of bits or symbols
        input_frame = rand(1,N1)>0.5; % generating 0,1 with equal probability %产生比特流，用于生成发射信号
        output_QAM = SM_STBC_n_modulation(input_frame,tx_bit,nTx,M);
        H = (1/sqrt(2))*(randn(nRx,nTx) + 1i*randn(nRx,nTx));%Rayleigh channel  瑞利信道
        receive_data=H*output_QAM;   %
        omega_noise=1/sqrt(2)*(randn(nRx,2) + 1i*randn(nRx,2));% AWGN   高斯噪声
        Receive_data=sqrt(rou/nTx_AS)*receive_data+omega_noise; %加高斯噪声
        Decoder_input_data=Receive_data*sqrt(nTx_AS/rou);%%AWGN 
        
        %detect_bit_m=STBC_detector_xlxn(Decoder_input_data,H,length_bits,M,M2,tx_bit,tx_com);%ML检测
        %detect_bit_lc=SM_STBC_detector_lc2(Decoder_input_data,H,M,M2,N0,length_bits);
        %detect_bit_m=SM_STBC_detector_ml(Decoder_input_data,H,length_bits,tx_bit,nTx,M);%ML检测
        detect_bit_m=SM_STBC_detector_ml_ver2(Decoder_input_data,H,length_bits,STBC_set);%ML检测
        %detect_bit_m=SM_STBC_detector_simplified_ml(Decoder_input_data,H,length_bits,tx_bit,nTx,M);
        
        l_ml=length(find( detect_bit_m~=input_frame));%统计单次循环的错误比特数
        %l_lc=length(find( detect_bit_lc~=input_frame));
        num_err_ml=num_err_ml+l_ml;
        %num_err_lc=num_err_lc+l_lc;
     end
     toc
     BER_m(ii)=num_err_ml/N1/iter;
     %BER_c(ii)=num_err_lc/N1/iter;
end
 semilogy(SNR_dB,BER_m,'g-o');%y轴对数形式作图
 hold on
