function [ co_weight] = GetCoWeight( idx, ScaleH, ScaleW )
% Get the co-weight between images
% 图像之间的权重--一致性
%每个聚类类别的权重等于各个图像占用类别的归一化百分比的标准差率的倒数
%（标准差率：标准差与平均数的比值（相对值））

    Image_num = size(idx,1)/( ScaleH* ScaleW);
    Bin_num = max(idx);
    Img_Idx = reshape(idx, ScaleH,  ScaleW*Image_num);

    Bin_Idx=zeros(Bin_num, Image_num);
    for i=1:Bin_num
        for j=1:Image_num
            %第j张图像中编号为聚类类别i的像素点所占总编号为聚类类别i的像素点的百分比
            %  Bin_Idx           图像1  图像2  图像3  图像4 图像5 ......     
            %               类别1[                                     ]
            %               类别2[                                     ]
            %               类别3[                                     ]
            %               类别4[                                     ]
            %               ...
            Bin_Idx(i,j)=size(Img_Idx(Img_Idx(:, ScaleW*(j-1)+1:ScaleW*j)==i),1)/size(Img_Idx(Img_Idx==i),1);
        end
    end

    co_weight=zeros(Bin_num,1);
    for j=1:Bin_num
        %归一化
        Bin_Idx(j,:)=Bin_Idx(j,:)/sum(Bin_Idx(j,:));
        %mean均值、std标准差
         co_weight(j)=mean((Bin_Idx(j,:)))/(std(Bin_Idx(j,:))+1);
    end

end

