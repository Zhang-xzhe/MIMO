function output_detect_bit=SM_STBC_detector_ml_ver2(rec_data,H,length_bits,STBC_set)
%%%�˼���㷨ֻ�����ʱ��ģ��
% ML receiver
% Restore variables for next receiver
bits = de2bi(0:2^length_bits-1, 'left-msb')';%nTx ��������ȡһ����һ�����߿��ܵ�ȡֵΪM��
 
% ML receiver
for ii = 1:length(bits)                      
    % bits_i=bits(:,ii);
    sig=STBC_set(:,:,ii);
    dist(ii) = sum(sum(abs(rec_data - H*sig).^2));%ÿ�������źź��ŵ��ĳ˻�������źŵ�ŷ�Ͼ���  
end 
% Get the minimum
[~, val] = min(dist);%�ҳ����о������Сֵ
output_detect_bit = bits(:,val)';  % detected bits �õ�������








