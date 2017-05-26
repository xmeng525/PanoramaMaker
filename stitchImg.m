function [ImgFinal] =stitchImg(Img_temp,nImg,row1,column1)
    figureIndex = 1;
    Nbest = 500;
    f = 350;
    size_final_x = 6000;
    size_final_y = 3000;
    base = ceil(nImg/2);
    if nImg > 5
        Img1 = Img_temp(:,:,:,1);
        cyl = cylProj(Img1,f);
        [row, column, dim] = size(cyl);
        Img = zeros(row,column,dim,nImg,'uint8');
        for i = 1: nImg
            Img(:,:,:,i) = cylProj(Img_temp(:,:,:,i),f);
        end        
    else
        row = row1;
        column = column1;
        Img = zeros(row,column,3,nImg,'uint8');
        for i = 1: nImg
            Img(:,:,:,i) = Img_temp(:,:,:,i);
        end
    end
    %% ANMS
    xReduced = zeros(Nbest,nImg);
    yReduced = zeros(Nbest,nImg);
    Coord = zeros(Nbest,2,nImg);
    for i = 1: nImg
        [xReduced(:,i),yReduced(:,i)]=ANMS(Img_temp(:,:,:,i),Nbest);
        Coord(:,:,i)= [xReduced(:,i),yReduced(:,i)];
        figure(figureIndex),imshow(Img_temp(:,:,:,i));
        figureIndex = figureIndex + 1;
        hold on;
        plot(xReduced(:,i),yReduced(:,i),'r.')
        hold off;
    end
    %% Get Features
    blurOutputReshapeStd = zeros(64,Nbest,nImg);
    for i = 1: nImg
        blurOutputReshapeStd(:,:,i)=getFeature(xReduced(:,i),yReduced(:,i),Img_temp(:,:,:,i),Nbest);
    end
    %% Match Feature
    feature = zeros(100,2,nImg);
    matchPoint=zeros(100,4,nImg);
    numFeature = zeros(nImg,1);
    H = zeros(3,3,nImg);
    inlier = zeros(100,nImg);
    for i = 1:nImg
        if (i ~= base)
            Source = i;
            Dest = sign(base - i) + i;
            a = matchFeature(blurOutputReshapeStd(:,:,Dest), blurOutputReshapeStd(:,:,Source), Nbest);
            feature(:,:,i) = a(1:100,:);
            [matchPoint(:,1:2,i),matchPoint(:,3:4,i)] = chooseMatchPoint2(feature(:,:,i),Coord(:,:,Dest),Coord(:,:,Source),row,column,row,column);
            numFeature(i) = sum(matchPoint(:,1,i)> 0);
            [H(:,:,i),inlier(:,i)] = RANSAC_newnew(numFeature(i),matchPoint(:,1:2,i),matchPoint(:,3:4,i));
            figure(figureIndex)
            figureIndex = figureIndex + 1;
            inlierChoose = find(inlier(:,i)==1);
            inlier12 = matchPoint(inlierChoose,1:2,i);
            inlier34 = matchPoint(inlierChoose,3:4,i);
            if (nImg > 5)
                [inlier12(:,1),inlier12(:,2)] = getCylCoord(inlier12(:,1),inlier12(:,2),column/2,row/2,f);
                [inlier34(:,1),inlier34(:,2)] = getCylCoord(inlier34(:,1),inlier34(:,2),column/2,row/2,f);
                H(:,:,i) = est_homography(inlier12(:,1),inlier12(:,2),inlier34(:,1),inlier34(:,2));
            end
            hImage(i) = dispMatchedFeatures(Img(:,:,:,Dest), Img(:,:,:,Source), inlier12,...
                        inlier34, 'montage');
            clear inlierChoose;
        end
    end

    y = 1:row;
    x = 1:column;
    [X,Y] = meshgrid(x,y);
    newX = zeros(row * column, nImg);
    newY = zeros(row * column, nImg);
    Xreshape = reshape(X,[row * column, 1]);
    Yreshape = reshape(Y,[row * column, 1]);
    if nImg == 8
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        index = abs(1 - base);
        newX(:,1) = Xreshape;
        newY(:,1) = Yreshape;
        [newX(:,1),newY(:,1)] = apply_homography(H(:,:,2),newX(:,1),newY(:,1));
        for j = 2:index
            Hindex = sign(base - 1 ) * (j - 1) + 1;
            [newX(:,1),newY(:,1)] = apply_homography(H(:,:,Hindex),newX(:,1),newY(:,1));
        end
        XindexMask = abs(newX(:,1)) < size_final_x;
        YindexMask = abs(newY(:,1)) < size_final_y;
        newX(:,1) = newX(:,1) .* XindexMask + (size_final_x - 1) .*(1 - XindexMask) .* sign(newX(:,1));
        newY(:,1) = newY(:,1) .* YindexMask + (size_final_y - 1) .*(1 - YindexMask) .* sign(newY(:,1));
        for i = 2:nImg
            index = abs(i - base);
            newX(:,i) = Xreshape;
            newY(:,i) = Yreshape;
            for j = 1:index
                Hindex = sign(base - i ) * (j - 1) + i;
                [newX(:,i),newY(:,i)] = apply_homography(H(:,:,Hindex),newX(:,i),newY(:,i));
            end
            XindexMask = abs(newX(:,i)) < size_final_x;
            YindexMask = abs(newY(:,i)) < size_final_y;
            newX(:,i) = newX(:,i) .* XindexMask + (size_final_x - 1) .*(1 - XindexMask) .* sign(newX(:,i));
            newY(:,i) = newY(:,i) .* YindexMask + (size_final_y - 1) .*(1 - YindexMask) .* sign(newY(:,i));
        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else
        for i = 1:nImg
            index = abs(i - base);
            newX(:,i) = Xreshape;
            newY(:,i) = Yreshape;
            for j = 1:index
                Hindex = sign(base - i ) * (j - 1) + i;
                [newX(:,i),newY(:,i)] = apply_homography(H(:,:,Hindex),newX(:,i),newY(:,i));
            end
            XindexMask = abs(newX(:,i)) < size_final_x;
            YindexMask = abs(newY(:,i)) < size_final_y;
            newX(:,i) = newX(:,i) .* XindexMask + (size_final_x - 1) .*(1 - XindexMask) .* sign(newX(:,i));
            newY(:,i) = newY(:,i) .* YindexMask + (size_final_y - 1) .*(1 - YindexMask) .* sign(newY(:,i));
        end
    end
    minX = min(min(newX));
    minY = min(min(newY));

    % offsetX = abs(minX);
    % offsetY = abs(minY);
    tmp_offsetX1 = max(max(newX));
    tmp_offsetX2 = min(min(newX));
    offsetX = ceil(tmp_offsetX1 - tmp_offsetX2) + 1000;
    tmp_offsetY1 = max(max(newY));
    tmp_offsetY2 = min(min(newY));
    offsetY = ceil(tmp_offsetY1 - tmp_offsetX2) + 1000;

    % newImg = zeros(size_final_y * size_final_x ,3,nImg);
    % indexMatrix = zeros(size_final_y,size_final_x);
    % Img_reshape = reshape(Img,[row * column,3,nImg]);
    newImg = zeros(offsetY * offsetX ,3,nImg);
    indexMatrix = zeros(offsetY,offsetX);
    Img_reshape = reshape(Img,[row * column,3,nImg]);
    for i = 1:nImg
    %     yyy = round(newY(:,i) + abs(min(newY(:,i)))) + 1;
    %     xxx = round(newX(:,i) + abs(min(newY(:,i)))) + 1;
        yyy = round(newY(:,i) - ceil(tmp_offsetY2)) + 2;
        xxx = round(newX(:,i) - ceil(tmp_offsetX2)) + 2;
        ind = sub2ind(size(indexMatrix),yyy,xxx);
        newImg(ind,:,i) = Img_reshape(:,:,i);
    end
    newImgMatrix = reshape(newImg,[offsetY,offsetX,3,nImg]);
    newImgFinal = zeros(offsetY,offsetX,3,nImg);
    for i = 1:nImg
        newImgFinal(:,:,:,i) = guasFilter(newImgMatrix(:,:,:,i));
%           newImgFinal(:,:,:,i) = ImgFilter(newImgMatrix(:,:,:,i));
    end
    newImgFinal = uint8(newImgFinal);
    ImgFinal = zeros(offsetY,offsetX,3);
    ImgMask = zeros(offsetY,offsetX,nImg);
    ImgMaskTotal = zeros(offsetY,offsetX);

    for i = 1:nImg
        figure(i)
        imshow(newImgFinal(:,:,:,i))
        ImgMask(:,:,i) = newImgFinal(:,:,1,i)>0;
        ImgMaskTotal = ImgMaskTotal + ImgMask(:,:,i);
        ImgFinal = double(newImgFinal(:,:,:,i)) + ImgFinal;
    end
    % figure(8)
    % imshow(uint8(newImgMatrix(:,:,:,7)))
    % ImgFinal2 = newImgFinal(:,:,:,1) + newImgFinal(:,:,:,2) + newImgFinal(:,:,:,3) + ...
    %             newImgFinal(:,:,:,4)+ newImgFinal(:,:,:,5) + newImgFinal(:,:,:,6) + newImgFinal(:,:,:,7);
    % imshow(ImgFinal2)
    % ImgMaskTotal = ImgMask(:,:,1) + ImgMask(:,:,2) + ImgMask(:,:,3);
    ImgFinal = ImgFinal./(ImgMaskTotal);
    sizeRange = ImgFinal(:,:,1) > 0;
    [findRangeY,findRangeX] = find(sizeRange == 1);
    ImgFinal = uint8(ImgFinal(min(findRangeY): max(findRangeY), min(findRangeX): max(findRangeX),:));
    figure(figureIndex)
    figureIndex = figureIndex + 1;
    imshow(ImgFinal)
end