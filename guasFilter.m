function ImgResult = guasFilter(Img)
    [row,column,~] = size(Img);
    ImgResult = zeros(row,column,3);
    sigma = 2.0;
    gausFilter = fspecial('gaussian',[5 5],sigma);
    Result = imfilter(Img,gausFilter,'replicate');
    mask = Img(:,:,1) > 0;
    for i = 1:3
        ImgResult(:,:,i) = Img(:,:,i) .* mask + Result(:,:,i) .* (1-mask);
    end
end