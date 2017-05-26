function [ImgFinal] = Wrapper(a1,a2,a3,a4,a5,a6,a7,a8,a9)
    if(nargin == 0)
        error('There is no image!');
    elseif(nargin == 1)
        error('DO you want to stitch yourself?')
    elseif(nargin == 2)
        nImg = 2;
        testImg = imread(a1);
        [row,column,~] = size(testImg);
        Img = zeros(row,column,3,2,'uint8');
        Img(:,:,:,1) = testImg;
        Img(:,:,:,2) = imread(a2);
        [ImgFinal] =stitchImg(Img,nImg,row,column);
    elseif(nargin == 3)
        nImg = 3;
        testImg = imread(a1);
        [row,column,~] = size(testImg);
        Img = zeros(row,column,3,3,'uint8');
        Img(:,:,:,1) = testImg;
        Img(:,:,:,2) = imread(a2);
        Img(:,:,:,3) = imread(a3);
        [ImgFinal] =stitchImg(Img,nImg,row,column);
    elseif(nargin == 4)
        nImg = 4;
        testImg = imread(a1);
        [row,column,~] = size(testImg);
        Img = zeros(row,column,3,4,'uint8');
        Img(:,:,:,1) = testImg;
        Img(:,:,:,2) = imread(a2);
        Img(:,:,:,3) = imread(a3);
        Img(:,:,:,4) = imread(a4);
        [ImgFinal] =stitchImg(Img,nImg,row,column);
    elseif(nargin == 5)
        
        nImg = 5;
        testImg = imread(a1);
        [row,column,~] = size(testImg);
        Nbest = 500;
        Img = zeros(row,column,3,5,'uint8');
        Img(:,:,:,1) = testImg;
        Img(:,:,:,2) = imread(a2);
        Img(:,:,:,3) = imread(a3);
        Img(:,:,:,4) = imread(a4);
        Img(:,:,:,5) = imread(a5);
        [inlierNum,ImgSeq] = calcInlierNum(Img,nImg,Nbest);
        [ImgFinal] =stitchImg(Img,nImg,row,column);
    elseif(nargin == 6)
        nImg = 6;
        testImg = imread(a1);
        [row,column,~] = size(testImg);
        Img = zeros(row,column,3,6,'uint8');
        Img(:,:,:,1) = testImg;
        Img(:,:,:,2) = imread(a2);
        Img(:,:,:,3) = imread(a3);
        Img(:,:,:,4) = imread(a4);
        Img(:,:,:,5) = imread(a5);
        Img(:,:,:,6) = imread(a6);
        [ImgFinal] =stitchImg(Img,nImg,row,column);
    elseif(nargin == 7)
        nImg = 7;
        testImg = imread(a1);
        [row,column,~] = size(testImg);
        Img = zeros(row,column,3,7,'uint8');
        Img(:,:,:,1) = testImg;
        Img(:,:,:,2) = imread(a2);
        Img(:,:,:,3) = imread(a3);
        Img(:,:,:,4) = imread(a4);
        Img(:,:,:,5) = imread(a5);
        Img(:,:,:,6) = imread(a6);
        Img(:,:,:,7) = imread(a7);
        [ImgFinal] =stitchImg(Img,nImg,row,column);
    elseif(nargin == 8)
        nImg = 8;
        testImg = imread(a1);
        [row,column,~] = size(testImg);
        Img = zeros(row,column,3,8,'uint8');
        Img(:,:,:,1) = testImg;
        Img(:,:,:,2) = imread(a2);
        Img(:,:,:,3) = imread(a3);
        Img(:,:,:,4) = imread(a4);
        Img(:,:,:,5) = imread(a5);
        Img(:,:,:,6) = imread(a6);
        Img(:,:,:,7) = imread(a7);
        Img(:,:,:,8) = imread(a8);
        [ImgFinal] =stitchImg(Img,nImg,row,column);
    elseif(nargin == 9)
        nImg = 9;
        testImg = imread(a1);
        [row,column,~] = size(testImg);
        Img = zeros(row,column,3,9,'uint8');
        Img(:,:,:,1) = testImg;
        Img(:,:,:,2) = imread(a2);
        Img(:,:,:,3) = imread(a3);
        Img(:,:,:,4) = imread(a7);
        Img(:,:,:,5) = imread(a8);
        Img(:,:,:,6) = imread(a4);
        Img(:,:,:,7) = imread(a5);
        Img(:,:,:,8) = imread(a6);
        Img(:,:,:,9) = imread(a9);
        [ImgFinal] =stitchImg(Img,nImg,row,column);
    else
        error('Tooo many images!');
end