function [newpop]=swap(pop,chromlength1,chromlength2)
[row,col]=size(pop);
pop_copy=pop;
for x=1:row
    exchange_loc=randperm(chromlength1,2);
    gene1=pop_copy(x,exchange_loc(1));
    gene2=pop_copy(x,exchange_loc(2));
    
    pop_copy(x,exchange_loc(2))=gene1;
    pop_copy(x,exchange_loc(1))=gene2;
end
for x=1:row
    exchange_loc=chromlength1+randperm(chromlength2,2);
    gene1=pop_copy(x,exchange_loc(1));
    gene2=pop_copy(x,exchange_loc(2));
    
    pop_copy(x,exchange_loc(2))=gene1;
    pop_copy(x,exchange_loc(1))=gene2;
end
newpop=pop_copy;

