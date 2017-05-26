function [matchPoint_Dest,matchPoint_Source] = chooseMatchPoint2(feature,coord_1col,coord_2col,row1,column1,row2,column2)
    thre = 10;
    k = 1;
    numFeature = sum(feature(:,1)>0);
    for i = 1:numFeature
        temp1X = coord_1col(feature(i, 1),1);
        temp1Y = coord_1col(feature(i, 1),2);
        temp2X = coord_2col(feature(i, 2),1);
        temp2Y = coord_2col(feature(i, 2),2);
        if ((temp1X > thre) && (temp1X < column1 - thre) && (temp1Y > thre) && (temp1Y < row1 - thre)...
                && (temp2X > thre) && (temp2X < column2 - thre) && (temp2Y > thre) && (temp2Y < row2 - thre))
            matchPoint_1col(k,:) = [temp1X,temp1Y];
            matchPoint_2col(k,:) = [temp2X,temp2Y];
            k = k + 1;
        end
    end
    matchPoint_Dest = zeros(100,2);
    matchPoint_Source = zeros(100,2);
    matchPoint_Dest(1:k-1,:) = matchPoint_1col(1:k-1,:);
    matchPoint_Source(1:k-1,:) = matchPoint_2col(1:k-1,:);
end