function [cylX,cylY] = getCylCoord(X,Y,x_center,y_center,f)
    [vecLength,~] = size(X);
    cylX = zeros(vecLength,1);
    cylY = zeros(vecLength,1);
    for i = 1: vecLength
        cylX(i) = round(f * atan((X(i) - x_center)/f) + x_center);
        cylY(i) = round(((Y(i) - y_center)*cos((cylX(i) - x_center)/f)) + y_center);
    end
end