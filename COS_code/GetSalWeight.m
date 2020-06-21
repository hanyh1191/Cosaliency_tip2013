function [ Sal_weight ] = GetSalWeight( ctrs ,idx)
%GETSALWEIGHT Summary of this function goes here

bin_num=size(ctrs,1);
bin_weight=zeros(bin_num,1);
for i=1:bin_num
    bin_weight(i)=size(find(idx==i),1);
end
bin_weight=bin_weight/size(idx,1);
%repmat重复矩阵块
%pdis行向量间的距离计算函数
%squareform转换成对角方阵
Y = squareform(pdist(ctrs)).*repmat(bin_weight, [1, bin_num]);
%列向量
Sal_weight=sum(Y)';
end

