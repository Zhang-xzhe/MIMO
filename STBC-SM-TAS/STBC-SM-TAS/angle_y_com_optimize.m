function [theta,antenna_com_index]=angle_y_com_optimize(tx_bit,nTx,M)
%% 天线组合
[antenna_com_index, angle_group]=SM_STBC_antenna_com(nTx);
%{
switch nTx
    case 3
        antenna_com_index=[1 2;  2 3];
        angle_group=[1 1];%每个角度对应的天线组合数
    case 4
        antenna_com_index=[1 2;3 4;  2 3;4 1];
        angle_group=[2 2];
    case 5
        antenna_com_index=[1 2;3 4;  2 3;4 5;  1 3;2 4;  1 4;2 5];
        angle_group=[2 2 2 2];
    case 6
        antenna_com_index=[1 2;3 4;5 6;   2 3;4 5;6 1;   1 3;2 4];
        angle_group=[3 3 2];
    case 7
        antenna_com_index=[1 2;3 4;5 6;  2 3;4 5;6 7;   1 3;2 4;5 7;   1 4;2 5;3 6;  1 5;2 6;3 7;   1 6];
        angle_group=[3 3 3 3 3 1];
    case 8
        antenna_com_index=[1 2;3 4;5 6;7 8;  2 3;4 5;6 7;8 1;  1 3;2 4;5 7;6 8;  1 5;2 6;3 7;4 8];
        angle_group=[4 4 4 4];
    case 30
        % 共256钟天线组合
        antenna_bit=floor(nchoosek(30,2));
        antenna_com_index=zeros(2^antenna_bit,2);
        antenna_com_index=[
            1 2;3 4;5 6;7 8;9 10;11 12;13 14;15 16;17 18;19 20;21 22;23 24;25 26;27 28;29 30; % 15组
            2 3;4 5;6 7;8 9;10 11;12 13;14 15;16 17;18 19;20 21;22 23;24 25;26 27;28 29;30 1; % 15组
            1 3;2 4;5 7;6 8;9 11;10 12;13 15;14 16;17 19;18 20;21 23;22 24;25 27;26 28;  % 14组
            1 4;2 5;3 6;7 10;8 11;9 12;13 16;14 17;15 18;19 22;20 23;21 24;25 28;26 29;27 30; % 15组
            1 5;2 6;3 7;4 8;
            2 3;4 5;6 7;8 1;  1 3;2 4;5 7;6 8;  1 5;2 6;3 7;4 8];
end
%}
%% 旋转角度
angle_num=length(angle_group);
optimtmal_theta=zeros(1,angle_num);
theta=zeros(1,2^tx_bit);
if nTx<=4
    switch M
        case 2
            optimtmal_theta=[0 1.57];
        case 4
            optimtmal_theta=[0 0.61];
        case 16
            optimtmal_theta=[0 0.75];
        case 64
            optimtmal_theta=[0 0.54];
    end
else
    switch M
        case 2
            for k=1:angle_num
                optimtmal_theta(1,k)=(k-1)*pi/angle_num;
            end
        case 4
            for k=1:angle_num
                optimtmal_theta(1,k)=(k-1)*pi/(2*angle_num);
            end
        case 16
            for k=1:angle_num
                optimtmal_theta(1,k)=(k-1)*pi/(2*angle_num);
            end
    end
end
num=0;
%把角度对应到每一个天线组合上
for n=1:angle_num
    theta(1,num+1:num+angle_group(:,n))=optimtmal_theta(1,n);
    num=num+angle_group(:,n);
end
%%




























