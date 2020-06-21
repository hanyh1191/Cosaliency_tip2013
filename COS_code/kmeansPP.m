function [L,C] = kmeansPP(X,k)
	%  output_L--每个样本对应的类别编号
	%  output_C--每个类别的中心点
	%  input_X--样本矩阵
	%  input_k--聚类时的类别个数
%KMEANS Cluster multivariate data using the k-means++ algorithm.
%   [L,C] = kmeans(X,k) produces a 1-by-size(X,2) vector L with one class
%   label per column in X and a size(X,1)-by-k matrix C containing the
%   centers corresponding to each class.

%   Version: 07/08/11
%   Authors: Laurent Sorber (Laurent.Sorber@cs.kuleuven.be)
%
%   References:
%   [1] J. B. MacQueen, "Some Methods for Classification and Analysis of 
%       MultiVariate Observations", in Proc. of the fifth Berkeley
%       Symposium on Mathematical Statistics and Probability, L. M. L. Cam
%       and J. Neyman, eds., vol. 1, UC Press, 1967, pp. 281-297.
%   [2] D. Arthur and S. Vassilvitskii, "k-means++: The Advantages of
%       Careful Seeding", Technical Report 2006-13, Stanford InfoLab, 2006.

L = [];
L1 = 0;
%获取矩阵L的不同元素构成的向量
while length(unique(L)) ~= k 
   
    C = X(:,1+round(rand*(size(X,2)-1)));
    L = ones(1,size(X,2));
    %找到k个聚类中心初始点-C
    for i = 2:k
        D = X-C(:,L);
        D = cumsum(sqrt(dot(D,D)));
        if D(end) == 0, 
        	C(:,i:k) = X(:,ones(1,k-i+1)); 
        	return; 
        end
        %返回前n个非零元素的位置
        C(:,i) = X(:,find(rand < D/D(end),1));
        %x-y
        %记录每列最大值和每列最大值的行号
        [tmp,L] = max(bsxfun(@minus,2*real(C'*X),dot(C,C).'));
    end
    %当所有样本的类别都不在变化时退出
    while any(L ~= L1)
    	%更新类别中心点
        L1 = L;
        for i = 1:k, 
        	l = L==i; 
        	C(:,i) = sum(X(:,l),2)/sum(l); 
        end
        %更新样本所属类别
        [tmp,L] = max(bsxfun(@minus,2*real(C'*X),dot(C,C).'),[],1);
    end
    
end
