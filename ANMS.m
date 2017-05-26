function [xReduced,yReduced] = ANMS(Img,Nbest)
    grayImg=rgb2gray(Img); 
    Cimg = cornermetric(grayImg,'harris');
%     imagesc(Cimg);
    [row,column] = size(grayImg);
    corner_peaks = imregionalmax(Cimg);
    Nstrong = sum(sum(corner_peaks));
    [y,x,~]=find(corner_peaks == true);
    r = 1000000000 * ones(Nstrong,1);

    for i = 1: Nstrong
        for j = 1: Nstrong
            if(Cimg(y(j),x(j))) > (Cimg(y(i),x(i)))
                ED = (x(j) - x(i)) ^ 2 + (y(j) - y(i))^2;
                if ED < r(i)
                    r(i) = ED;
                end
            end
        end
    end
    [rSort_temp, rSortIndex_temp] = sort(r);
    
    rSort = zeros(Nstrong,1);
    rSortIndex = zeros(Nstrong,1);
    x_corner = zeros(Nstrong,1);
    y_corner = zeros(Nstrong,1);
    k = 1;
    for a = 1: Nstrong
        if (rSort_temp(Nstrong + 1 - a) < 1000000)
            rSort(k) = rSort_temp(Nstrong + 1 - a);
            rSortIndex(k) = rSortIndex_temp(Nstrong + 1 - a);
            x_corner(k) = x(rSortIndex(k));
            y_corner(k) = y(rSortIndex(k));
            k = k + 1;
        end
    end

    rSortReduced = rSort(1:Nbest);
    xReduced = x_corner(1:Nbest);
    yReduced = y_corner(1:Nbest);
end

