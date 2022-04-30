function [newpop,newvalue]=selection_reduce(pop,fitvalue,T) 
[value,loc] = sort(fitvalue,'descend');
for x=1:T
    newpop(x,:)=pop(loc(x),:);
    newvalue(x)=fitvalue(loc(x));
end