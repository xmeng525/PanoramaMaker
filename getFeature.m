function [blurOutputReshapeStd]=getFeature(xReduced,yReduced,Img,Nbest)
    grayImg=rgb2gray(Img); 
    [row,column] = size(grayImg);
    patchSize = 40;
    blurOutputSize = 8;
    blurResult = zeros(patchSize,patchSize,Nbest);
    blurOutput = zeros(blurOutputSize,blurOutputSize,Nbest);
    sigma = 2.8;
    gausFilter = fspecial('gaussian',[10 10],sigma);

    extendCorner = zeros(patchSize/2,patchSize/2);
    extendLR = zeros(row,patchSize/2);
    extendUD = zeros(patchSize/2,column);
    grayImgExtend = [extendCorner,extendUD,extendCorner;...
                     extendLR,    grayImg, extendLR;...
                     extendCorner,extendUD,extendCorner];

    for k = 1:Nbest
        center_x = xReduced(k);
        center_y = yReduced(k);
        blurRegion = grayImgExtend(center_y: center_y + patchSize - 1,center_x : center_x + patchSize - 1);
        blurResult(:,:,k) = imfilter(blurRegion,gausFilter,'replicate');
        for i = 1: blurOutputSize
            for j = 1: blurOutputSize
                blurOutput(i,j,k) = blurResult(3 + patchSize/blurOutputSize * (i-1), 3 + patchSize/blurOutputSize * (j-1),k);
            end
        end
    end
    for k = 1:Nbest
        blurOutputReshape = reshape(blurOutput,[blurOutputSize * blurOutputSize Nbest]);
        vectorMean = mean(blurOutputReshape(:,k));
        blurOutputReshapeStd(:,k) = (blurOutputReshape(:,k) - vectorMean)/std(blurOutputReshape(:,k));
    end
end