clc;
clear;

image = imread('test.png'); 

%getting the histogram of each colour channel
R = imhist(image(:,:,1));
G = imhist(image(:,:,2));
B = imhist(image(:,:,3));

%%%% HISTOGRAM EQUALIZATION

% 1) Independent histogram equalization based on color channel 
R_eq = hist_equalize(image(:,:,1));
G_eq = hist_equalize(image(:,:,2));
B_eq = hist_equalize(image(:,:,3));
result1 = cat(3, R_eq, G_eq, B_eq);

figure
subplot(1,2,1), imshow(image); title('Original');
subplot(1,2,2), imshow(result1); title('Independent HE based on Colour Channel');

% %getting histogram of each colour channel
% R_eq = imhist(result1(:,:,1));
% G_eq = imhist(result1(:,:,2));
% B_eq = imhist(result1(:,:,3));
% 
% figure,
% subplot(1,2,1),bar(R,'r')
% hold on, bar(G, 'g')
% bar(B, 'b')
% title('original histogram')
% hold off;
% subplot(1,2,2), bar(R_eq,'r')
% hold on, bar(G_eq, 'g')
% bar(B_eq, 'b')
% title('1) Independent HE based on Colour Channel Histogram')
% hold off;

% 2) Histogram equalization only on the intensity channel in HSV
% space

I = im2double(image);
HSI = rgb_hsi(I); %convert rgb image to hsi 
HSI = im2uint8(HSI);
H_eq = hist_equalize(HSI(:,:,3)); %perform HE on intensity channel
HSI_mod = HSI;
HSI_mod(:,:,3) = H_eq;
HSI_mod = im2double(HSI_mod);
result2 = hsi_rgb(HSI_mod); %convert hsi back to rgb

R_eq = imhist(result2(:,:,1));
G_eq = imhist(result2(:,:,2));
B_eq = imhist(result2(:,:,3));

figure
subplot(1,2,1), imshow(image); title('Original');
subplot(1,2,2), imshow(result2); title('HE on Intensity Channel');

% figure,
% subplot(1,2,1),bar(R,'r')
% hold on, bar(G, 'g')
% bar(B, 'b')
% title('original histogram')
% hold off;
% subplot(1,2,2), bar(R_eq,'r')
% hold on, bar(G_eq, 'g')
% bar(B_eq, 'b')
% title('2) HE on Intensity Channel histogram')
% hold off;


% 3) Histogram equalization only on the Y channel in YUV space

I = im2double(image);
YUV = rgb_yuv(I); %convert rgb image to yuv 
YUV = im2uint8(YUV);
H_eq = hist_equalize(YUV(:,:,1)); %perform HE on Y channel
YUV_temp = YUV;
YUV_temp(:,:,1) = H_eq;
YUV_temp = im2double(YUV_temp);
result3 = yuv_rgb(YUV_temp); %convert yuv back to rgb

R_eq = imhist(result3(:,:,1));
G_eq = imhist(result3(:,:,2));
B_eq = imhist(result3(:,:,3));

figure
subplot(1,2,1), imshow(image); title('Original');
subplot(1,2,2), imshow(result3); title('HE on Y Channel');
% 
% figure,
% subplot(1,2,1),bar(R,'r')
% hold on, bar(G, 'g')
% bar(B, 'b')
% title('original histogram')
% hold off;
% subplot(1,2,2), bar(R_eq,'r')
% hold on, bar(G_eq, 'g')
% bar(B_eq, 'b')
% title('3) HE on Y Channel histogram')
% hold off;


%%%% RETINEX ALGORITHM

% 1) MSR in RGB Colour Space
result4 = msr(image);
figure,
subplot(1,2,1), imshow(image); title('Original');
subplot(1,2,2), imshow(result4); title('MSR');


% 2) MSRCR in RGB Colour Space
result5 = msrcr_rgb(image);
figure,
subplot(1,2,1), imshow(image); title('Original');
subplot(1,2,2), imshow(result5); title('MSRCR in RGB Channel');


% 3) MSRCR in HSV Colour Space
result6 = msrcr_hsv(image);
figure,
subplot(1,2,1), imshow(image); title('Original');
subplot(1,2,2), imshow(result6); title('MSRCR in HSV Channel');
