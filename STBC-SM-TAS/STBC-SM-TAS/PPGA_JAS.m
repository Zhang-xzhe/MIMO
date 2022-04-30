function [locR,locT] = PPGA_JAS(popsize,chromlength1,chromlength2,G,nT,nTx,nTx_AS,nRx,H)
%PPGA_JAS 单亲遗传算法联合选择发射和接收天线
pop_init=initpop(popsize,chromlength1,chromlength2);
[objvalue_popinit]=calobjvalue(pop_init,nT,nTx,nTx_AS,nRx,H);
for i=1:G
    [newpop]=swap(pop_init,chromlength1,chromlength2);
    [objvalue_new]=calobjvalue(newpop,nT,nTx,nTx_AS,nRx,H);
    objvalue=[objvalue_popinit,objvalue_new];
    newpop1=[pop_init;newpop];
    [newpop2,newvalue2]=selection_reduce(newpop1,objvalue,popsize);
    [bestindividual,bestfit]=best(newpop2,newvalue2);
    pop_init=newpop2;
    objvalue_popinit=newvalue2;
    bestfit_value(i)=bestfit;
end
gene1=bestindividual(1:nT);
gene2=bestindividual(nT+1:nT+chromlength2);
[~,TA_index]=sort(gene1,'descend');
[~,RA_index]=sort(gene2,'descend');
locR=sort(RA_index(1:nRx),'ascend');
locT=sort(TA_index(1:nTx),'ascend');
end

