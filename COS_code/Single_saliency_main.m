function [ Saliency_Map_single ] = Single_saliency_main( data, img_num, Scale, Bin_num_single)
    %  output_Saliency_Map_single--输出的显著性图像
    %  input_data--要处理的图像
    %  input_img_num--要处理的图像的个数，这里由于是单图像显著性检测，故为1
    %  input_Scale--尺度归一化因子
    %  input_Bin_num_single--单图像内聚类类别个数
%SINGLE_SALIENCY_MAIN Summary of this function goes here
%   Detailed explanation goes here

Saliency_Map_single = zeros([Scale,Scale*img_num]);

for i=1:img_num
    img = data.image{i};
    [imvector, ~, DisVector]=GetImVector(img, Scale, Scale,0);
    [idx,ctrs] = kmeansPP(imvector',Bin_num_single);
    idx=idx'; ctrs=ctrs';
    % idx--列向量，每个坐标点对应的聚类类别
    % ctrs--类别中心点对应的向量，6行即6个类别，3列即3个维度
    Cluster_Map = reshape(idx, Scale, Scale);
    %对比度线索
    Sal_weight=GetSalWeight( ctrs,idx  );
    %中心偏移度线索
    Dis_weight  = GetPositionW( idx, DisVector, Scale, Bin_num_single );
    %Sal_weight/Dis_weight分别是对比度线索和中心偏移度线索列向量
    %向量的长度为聚类类别的个数
    %权重高斯归一化
    Sal_weight= Gauss_normal(Sal_weight);
    Dis_weight= Gauss_normal(Dis_weight);
    SaliencyWeight_all=(Sal_weight .* Dis_weight);
    
    Saliency_sig_final = Cluster2img( Cluster_Map, SaliencyWeight_all, Bin_num_single);
    
    Saliency_Map_single(:,1+(i-1)*Scale:Scale+(i-1)*Scale)=Saliency_sig_final;
end

end

