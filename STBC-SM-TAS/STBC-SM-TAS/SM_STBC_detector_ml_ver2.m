function output_detect_bit=SM_STBC_detector_ml_ver2(rec_data,H,length_bits,STBC_set)
%%%此检测算法只针对慢时变模型
% ML receiver
% Restore variables for next receiver
bits = de2bi(0:2^length_bits-1, 'left-msb')';%nTx 根天线中取一根，一根天线可能的取值为M个
 
% ML receiver
for ii = 1:length(bits)                      
    % bits_i=bits(:,ii);
    sig=STBC_set(:,:,ii);
    dist(ii) = sum(sum(abs(rec_data - H*sig).^2));%每个发射信号和信道的乘积与接收信号的欧氏距离  
end 
% Get the minimum
[~, val] = min(dist);%找出其中距离的最小值
output_detect_bit = bits(:,val)';  % detected bits 得到检测比特








