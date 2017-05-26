# PanoramaMaker
For a description of this probject, please go to:
http://xiaoxumeng1993.wixsite.com/xiaoxumeng/my-auto-panorama

Next, introduct the functions in this project.

ANMS.m
The aim of this step is to detect corners spread all across the image to avoid weird artifacts in warping.

Firstly, detect corner features in the image using cornermetric with the appropriate parameters. The output is a matrix of corner scores. The higher the value, the higher the score/probability of that pixel being a corner.

Then use ANMS to fnd corners which are local maxima. The ANMS algorithm is described next:
Input : Corner score Image (Cimg obtained using cornermetric), Nbest (Number of best corners needed)
Output: (xi; yi) for i = 1 : Nbest
1. Find all local maxima using imregionalmax on Cimg;
2. Find (x; y) co-ordinates of all local maxima; ((x; y) for a local maxima are inverted row and column indices i.e., If we have local maxima at [i; j] then x = j and y = i for that local maxima);
3. Initialize ri = 1 for i = [1 : Nstrong]
for i = [1 : Nstrong] do
  for j = [1 : Nstrong] do
    if (Cimg(yj ; xj) > Cimg(yi; xi)) then
      ED = (xj 􀀀 xi)2 + (yj 􀀀 yi)2
      if ED < ri then
        ri = ED
      end
    end
  end
end
4. Sort ri in descending order and pick top Nbest points.

apply_homography.m
Use homogrphay matrix H to compute position (x,y) in the source image to the position (X,Y) in the destination image.

chooseMatchPoint2.m
Use this program to filter the features which are on teh corners or edges of the image.

cylProj.m
Make cylindrical projection for the iamges.

DispMatchedFeatures.m
Displays images I1 and I2 using the visualization style specified by method.

est_homography.m
Compute the homography matrix from source(x,y) to destination(X,Y)

getCylCoord.m
Get the coordinates for image after cylindrical projection.

getFeature.m
Extract features of images.

guasFilter.m
Use Gaussian method to fill the black regions in the panorama.

matchFeature.m
Use RANSAC to match the features.

RANSAC_newnew.m
Use RANSAC to find the tranformation matrix between two images.

stitchImg.m
The main pipeline to make panorama.

testWrapper.m
Testfile. the inputs are the path of images, the output is panorama.

Wrapper.m
Deal with the different situations of testWrapper.m and call stitchImg.m to make panorama
