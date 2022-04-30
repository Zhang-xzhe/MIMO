function [l_errsig1] = ErrSigCalc(y1,SNR,H_AS,input_frame,length_bits,STBC_set,nRx,nTx_AS)
%2020/7/10 zrt
rou=10^(SNR/10);
omega_noise=1/sqrt(2)*(randn(nRx,2) + 1i*randn(nRx,2));% AWGN   高斯噪声
Receive_data=sqrt(rou/nTx_AS)*y1+omega_noise; %加高斯噪声
Decoder_input_data=Receive_data*sqrt(nTx_AS/rou);%%AWGN 
est_signal1=SM_STBC_detector_ml_ver2(Decoder_input_data, H_AS ,length_bits,STBC_set);

err_sig1=find(input_frame-est_signal1);%找不为零的位置
l_errsig1 = length(err_sig1);%统计错误码字总数