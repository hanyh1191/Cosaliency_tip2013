function [ Saliency_Map_single ] = Cluster2img( Cluster_Map, SaliencyWeight_all, Bin_num)
	%  output_Saliency_Map_single--生成的图内显著图
	%  input_Cluster_Map--输入的聚类后的图像，每个坐标点代表所属的聚类类别
	%  input_SaliencyWeight_all--整体显著性线索权值
	%  input_Bin_num--聚类类别的个数
%CLUSTER2IMG Summary of this function goes here
%   Detailed explanation goes here

    Saliency_sig_temp=Cluster_Map;
    for j=1:Bin_num
        Saliency_sig_temp(Saliency_sig_temp==j)=SaliencyWeight_all(j);
    end
    %imfilter对任意类型数组或多维图像进行滤波 
    %fspecial用于创建预定义的滤波算子
    %平滑每个像素点的显著性测度
    Saliency_Map_single = imfilter(Saliency_sig_temp, fspecial('gaussian', [3, 3], 3));

end

