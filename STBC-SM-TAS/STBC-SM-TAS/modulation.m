function output_modu = modulation(input_frame, index)
% Input_modu: input bit stream (0,1)
% index:  modulation index
%		1---bpsk
%		2---qpsk
%		4---16qam
%		6---64qam
% 	else is error
f_length = length(input_frame)/index;
QAM_input_I = zeros(1,f_length);
QAM_input_Q = zeros(1,f_length);
% note: Matlab index starts from 1
switch index
case 1,
    BPSK_I = [-1 1];    % refer to Table82 on page21 of IEEE802.11a
    QAM_input_I = BPSK_I(input_frame+1);
    output_modu = QAM_input_I + 1j * QAM_input_Q;
case 2,
    QPSK_IQ = [-1 1];   % refer to Table83 on page21 of IEEE802.11a
    QAM_input_I = QPSK_IQ(input_frame(1:2:end)+1)/sqrt(2);
    QAM_input_Q = QPSK_IQ(input_frame(2:2:end)+1)/sqrt(2);
    output_modu = QAM_input_I + 1j * QAM_input_Q;
case 3, 
    mapping=[3+1i 1+1i -3+1i -1+1i -3-1i -1-1i 3-1i 1-1i ]; 
    output_modu=mapping(input_frame(1:3:end)*4+input_frame(2:3:end)*2+input_frame(3:3:end)+1)/sqrt(6);     
case 4,
    QAM_16_IQ = [-3 -1 3 1];    % refer to Table84 on page21 of IEEE802.11a
    QAM_input_I = QAM_16_IQ(input_frame(1:4:end)*2+input_frame(2:4:end)+1)/sqrt(10);
    QAM_input_Q = QAM_16_IQ(input_frame(3:4:end)*2+input_frame(4:4:end)+1)/sqrt(10);
    output_modu = QAM_input_I + 1j * QAM_input_Q;
case 5, 
    mapping=[5+1i 3+1i 1+1i 5+3i 3+3i 1+3i 3+5i 1+5i -5+1i -3+1i -1+1i -5+3i -3+3i -1+3i -3+5i -1+5i -5-1i -3-1i -1-1i -5-3i -3-3i -1-3i -3-5i -1-5i 5-1i 3-1i 1-1i 5-3i 3-3i 1-3i 3-5i 1-5i]; 
    output_modu=mapping(input_frame(1:5:end)*16+input_frame(2:5:end)*8+input_frame(3:5:end)*4+input_frame(4:5:end)*2+input_frame(5:5:end)+1)/sqrt(20);     
case 6,
    QAM_64_IQ = [-7 -5 -1 -3 7 5 1 3];  % refer to Table85 on page21 of IEEE802.11a
    QAM_input_I = QAM_64_IQ(input_frame(1:6:end)*4+input_frame(2:6:end)*2+input_frame(3:6:end)+1)/sqrt(42);
    QAM_input_Q = QAM_64_IQ(input_frame(4:6:end)*4+input_frame(5:6:end)*2+input_frame(6:6:end)+1)/sqrt(42);
    output_modu = QAM_input_I + 1j * QAM_input_Q;
end
