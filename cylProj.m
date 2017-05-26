function [outImg] = cylProj(Img,f)
    [row,column,~] = size(Img);
    x_center = ceil(column/2);
    y_center = ceil(row/2);
    x_cyl = zeros(1,column);
    y_cyl = zeros(row,column);
    for i = 1:column
        x_cyl(1,i) = round(f * atan((i - x_center)/f) + x_center);
%         if x_cyl(1,i) < 0
%             x_cyl(1,i) = 1;
%         end
        for j = 1:row
            y_cyl(j,i) = round(((j - y_center)*cos((x_cyl(1,i) - x_center)/f)) + y_center);
%             if y_cyl(j,i) < 0
%                 y_cyl(j,i) = 1;
%             end
%             cyl_Img(y_cyl(j,i),x_cyl(1,i),:) = Img(j,i,:);
        end
    end
    indexMatrix = zeros(row,column);
    yyy = y_cyl - min(min(y_cyl)) + 1;
    xxx = ones(row,1) * x_cyl;
    yyy = reshape(yyy,[row*column,1]);
    xxx = reshape(xxx,[row*column,1]);
    ind = sub2ind(size(indexMatrix),yyy,xxx);
    
    ImgReshape = reshape(Img,[row* column,3]);
    cyl_Img = zeros(row* column,3);
    cyl_Img(ind,:) = ImgReshape(:,:);
    outImg = reshape(cyl_Img,[row,column,3]);
end
