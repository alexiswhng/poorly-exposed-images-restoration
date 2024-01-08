function [output] = yuv_rgb(image)

Y = image(:,:,1);
U = image(:,:,2);
V = image(:,:,3);

R = Y + 1.139834576 * V;
G = Y -.3946460533 * U -.58060 * V;
B = Y + 2.032111938 * U;

output = im2uint8(cat(3,R,G,B));