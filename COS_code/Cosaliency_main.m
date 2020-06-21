function [ Saliency_Map_co, All_img] = Cosaliency_main( data, img_num, Scale, Bin_num)
	%  output_Saliency_Map_co--图间显著图
	%  output_All_img--尺寸归一化后的原始图像矩阵
%% COSALIENCY_DCS Summary of this function goes here
%   Detailed explanation goes here

%% ------ Obtain the co-saliency for multiple images-------------
%----- obtaining the features -----
All_vector = [];
All_DisVector = [];
All_img = [];
for i=1:img_num
    img = data.image{i};
    [imvector, temp_img, DisVector]=GetImVector(img, Scale, Scale,0);
    %图像表示向量堆叠，按行堆叠
    %图像坐标点距离向量，按行堆叠
    %   【1】
    %   【2】
    %   【3】
    %   【4】
    All_vector=[All_vector; imvector];
    All_DisVector=[All_DisVector; DisVector];
    All_img=[All_img temp_img];
end

% ---- clustering via Kmeans++ -------
[idx,ctrs] = kmeansPP(All_vector',Bin_num);
idx=idx';
ctrs=ctrs';

%----- clustering idx map ---------
Cluster_Map = reshape(idx, Scale, Scale*img_num);

%----- computing the Contrast cue -------
Sal_weight_co= Gauss_normal(GetSalWeight( ctrs,idx ));
%----- computing the Spatial cue -------
Dis_weight_co= Gauss_normal(GetPositionW( idx, All_DisVector, Scale, Bin_num ));
%----- computing the Corresponding cue -------
%对称性线索
co_weight_co= Gauss_normal(GetCoWeight( idx, Scale, Scale ));
 
%----- combining the Co-Saliency cues -----
SaliencyWeight=(Sal_weight_co .* Dis_weight_co .* co_weight_co);

%----- generating the co-saliency map -----
Saliency_Map_co = Cluster2img( Cluster_Map, SaliencyWeight, Bin_num);

end

