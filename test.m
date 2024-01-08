clc;
clear;

image = imread('Images/20107_00_30s.jpg'); 
image = im2double(rgb2gray(image));

% figure, imshow(image)

hist = imhist(image);
% figure, bar(hist)


% image2 = imread('Images/10087_00_30s.jpg');
% image2 = im2double(rgb2gray(image2));
% 
% hist2 = imhist(image2);
% figure, bar(hist2)


newImage = image.*image;
hist3 = imhist(newImage);
figure, bar(hist3)
