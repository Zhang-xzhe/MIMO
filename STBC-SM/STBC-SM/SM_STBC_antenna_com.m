function [antenna_com_index, angle_group]=SM_STBC_antenna_com(nTx)
antenna_bit=floor(log2(nchoosek(nTx,2)));
antenna_com_index=zeros(2^antenna_bit,2);
        
num=1;
count_angle_group_sub=0;
angle_group=[];
% 天线组合为[1 2][3 4][5 6]...
for k1=1:2:nTx-1
    antenna_com_index(num,:)=[k1 k1+1];
    num=num+1;
    count_angle_group_sub=count_angle_group_sub+1;
end
angle_group(1)=count_angle_group_sub;

% 天线组合为[2 3][4 5][6 1]...
count_angle_group_sub=0;
for k1=2:2:nTx
    if k1+1>nTx
        antenna_com_index(num,:)=[k1 1];
        num=num+1;
    else
        antenna_com_index(num,:)=[k1 k1+1];
        num=num+1;
    end
    count_angle_group_sub=count_angle_group_sub+1;
end
angle_group(2)=count_angle_group_sub;
if num-1==2^antenna_bit
   return
end

% 其他情况
    for len_antenna_group=3:nTx %每个天线组合的长度，比如[1 5]长度为5，[1 8]长度为8；
        len_antenna_group_sub=2*len_antenna_group-2; % 每个天线组合子块的长度，比如[1 3;2 4]算一个子块，长度为4，[1 5;2 6;3 7;4 8]算一个子块，长度为8
        %num_antenna_group_sub=floor(nTx/len_antenna_group_sub); % 包含的天线组合子块数
        count_angle_group_sub=0;
        if len_antenna_group_sub<=nTx 
            for k0=0:len_antenna_group_sub:(nTx-len_antenna_group_sub-mod(nTx,len_antenna_group_sub))
                for k1=1:len_antenna_group-1               
                    antenna_com_index(num,:)=[k0+k1 k0+k1+len_antenna_group-1];
                    count_angle_group_sub=count_angle_group_sub+1;
                    if num==2^antenna_bit
                        angle_group(len_antenna_group)=count_angle_group_sub;
                        return
                    end
                    num=num+1;
                end
                antenna_com_index_end=k0+k1+len_antenna_group-1;
            end
            
            for k2=antenna_com_index_end+1:nTx
                if k2+len_antenna_group-1<=nTx
                    antenna_com_index(num,:)=[k2 k2+len_antenna_group-1];
                    count_angle_group_sub=count_angle_group_sub+1;
                    if num==2^antenna_bit
                        angle_group(len_antenna_group)=count_angle_group_sub;
                        return
                    end
                    num=num+1;
                end
            end
            
        else
            for k1=1:nTx/2
                if k1+len_antenna_group-1<=nTx
                    antenna_com_index(num,:)=[k0+k1 k0+k1+len_antenna_group-1];
                    count_angle_group_sub=count_angle_group_sub+1;
                    if num==2^antenna_bit
                        angle_group(len_antenna_group)=count_angle_group_sub;
                        return
                    end
                    num=num+1;
                end
            end
        end
        angle_group(len_antenna_group)=count_angle_group_sub;         
    end