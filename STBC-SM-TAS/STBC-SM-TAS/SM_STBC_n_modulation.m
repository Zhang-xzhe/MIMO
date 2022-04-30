function output_QAM = SM_STBC_n_modulation(input_frame,tx_bit,nTx, M)
s_bit_1=input_frame(1:log2(M));
s_bit_2=input_frame(log2(M)+1:2*log2(M));
    
S_1= modulation(s_bit_1,log2(M));
S_2= modulation(s_bit_2,log2(M));
SM_1=[S_1;-conj(S_2)];
SM_2=[S_2;conj(S_1)];
        
antenna_bit=input_frame(2*log2(M)+1:end);
num=1;
s=0;
for k_2=length(antenna_bit):-1:1
    s=s+1;
    num=num+2^(s-1)*antenna_bit(k_2);
end

[theta,antenna_com_index]=angle_y_com_optimize(tx_bit,nTx,M);      

output_QAM=zeros(nTx,2);
output_QAM(antenna_com_index(num,:),:)=exp(1j*theta(1,num))*[SM_1 SM_2];










