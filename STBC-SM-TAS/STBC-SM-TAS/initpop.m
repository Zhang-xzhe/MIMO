function [pop] = initpop(popsize,chromlength1,chromlength2)
%INITPOP ��ʼ��Ⱥ����
%   �˴���ʾ��ϸ˵��
pop=zeros(popsize,chromlength1+chromlength2);
possible_set=1:chromlength1;
for i=1:popsize
    randindex=randperm(chromlength1);
    pop(i,1:chromlength1)=possible_set(:,randindex);
end
possible_set=1:chromlength2;
for i=1:popsize
    randindex=randperm(chromlength2);
    pop(i,chromlength1+1:chromlength1+chromlength2)=possible_set(:,randindex);
end

