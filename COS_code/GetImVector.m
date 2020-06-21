function [ All_vector All_img Dis_Vector] = GetImVector( img_data, ScaleH, ScaleW ,need_texture)
    %  output_All_vector--输出的图像所有像素点组成的向量
    %  output_All_img--输出的尺寸归一化后的图像
    %  output_Dis_Vector--输出的和图像中心点的欧氏距离向量
    %  input_img_data--需要处理的图像矩阵
    %  input_ScaleH\ScaleW--尺寸归一化因子
    %  input_need_texture--是否需要对图像进行Gabor变换
% Get the vector of image
% Input:
%   img_data: the RGB image.
%   ScaleH, ScaleW: image resize scale.
%   need_texture: 0-without Gabor, 1-with Gabor.
%
% Output:
%   All_vector: The image feature vector (color, texture);
%   All_img: The resized image;
%   Dis_Vector: The image cetner distance;

if need_texture % Gabor parameters
    N=8;
    lambda  = 8;
    theta   = 0;
    psi     = [0 pi/2];
    gamma   = 0.5;
    bw      = 1;
end
%默认最近邻插值来改变图像尺寸
All_img = imresize(img_data, [ScaleH, ScaleW]);

if need_texture
    img_in = im2double(rgb2gray(All_img));
    Gabor_img = zeros(ScaleH, ScaleW, N);
    for n=1:N
        gb = gabor_fn(bw,gamma,psi(1),lambda,theta)...
            + 1i * gabor_fn(bw,gamma,psi(2),lambda,theta);
        % gb is the n-th gabor filter
        %原始图像与Gabor滤波器做卷积--边缘检测
        Gabor_img(:,:,n) = imfilter(img_in, gb, 'symmetric');
        % filter output to the n-th channel
        theta = theta + 2*pi/N;
        % next orientation
    end
    %sum(X,dim)压缩dim维度
    Gabor_img = sum(abs(Gabor_img).^2, 3).^0.5;
end
%转换颜色空间--Lab一种基于生理特征的颜色系统
img2 = colorspace('Lab<-RGB',All_img);
All_vector=zeros( ScaleH*ScaleW,3);

if need_texture
    All_vector=zeros( ScaleH*ScaleW,4);
end

Dis_Vector=zeros( ScaleH*ScaleW,1);
for j=1:ScaleH
    for i=1:ScaleW
        All_vector(j +(i-1)*ScaleH,1)=round(img2(j, i, 1));
        All_vector(j +(i-1)*ScaleH,2)=round(img2(j, i, 2));
        All_vector(j +(i-1)*ScaleH,3)=round(img2(j, i, 3));
        if need_texture
            All_vector(j +(i-1)*ScaleH,4)=Gabor_img(j, i);
        end
        Dis_Vector(j +(i-1)*ScaleH)=round(sqrt((i-ScaleW/2)^2+(j-ScaleH/2)^2));
    end
end


end

