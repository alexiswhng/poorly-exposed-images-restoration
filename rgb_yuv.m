function [output] = rgb_yuv(image)

I = im2double(image);

R = I(:,:,1); 
G = I(:,:,2); 
B = I(:,:,3); 

Y = 0.299 * R + 0.587 * G + 0.114 * B;
U = -0.14713 * R - 0.28886 * G + 0.436 * B;
V = 0.615 * R - 0.51499 * G - 0.10001 * B;

output = cat(3,Y,U,V);





