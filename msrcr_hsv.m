function [output] = msrcr_hsv(image)

image_double = double(image);

% Convert to HSI
HSI = rgb_hsi(image_double);

% H = HSI(:,:,1);
% S = HSI(:,:,2);
I = HSI(:,:,3);

%Constants in the implementation of Multiscale Retinex (MSR)

sigma1 = 15;
sigma2 = 80;
sigma3 = 250;
alpha = 125;
beta = 46;
G = 192;
b = -30; 

[row,col] = size(I);

%Gaussian function - built in function also normalizes
Gauss_1 = fspecial('gaussian', [row, col], sigma1);
Gauss_2 = fspecial('gaussian', [row, col], sigma2);
Gauss_3 = fspecial('gaussian', [row, col], sigma3); 

fgauss1 = fft2(Gauss_1,row,col); %Take fourier transform of function
fgauss1 = fftshift(fgauss1); %FFT shift to center 
fgauss2 = fft2(Gauss_2,row,col);
fgauss2 = fftshift(fgauss2);
fgauss3 = fft2(Gauss_3,row,col);
fgauss3 = fftshift(fgauss3);


%%%%%%% Perform MSRCR only on intensity channel %%%%%%%%

I_log = log(I+1); %take log of I 
I_fft = fft2(I);  %fourier transform of I (convert to frequency domain)

%for sigma 1
Ir = ifft2(fgauss1.*I_fft);  %After convoluting, transform back into the spatial domain
Ir_log = log(Ir + 1); %Add 1 incase of zero case
Rr1 = I_log - Ir_log;  %apply Rmsr equation

%repeat for sigma 2
Ir = ifft2(fgauss2.*I_fft);  
Ir_log = log(Ir + 1); 
Rr2 = I_log - Ir_log;  

%repeat for sigma 3
Ir = ifft2(fgauss3.*I_fft);  
Ir_log = log(Ir + 1); 
Rr3 = I_log - Ir_log;  

Rr = 1/3*Rr1 + 1/3*Rr2 + 1/3*Rr3;   %recommended weighted sum 

%Calculate CR 
CRr = beta*(log(alpha*I+1)); 

%MSRCR 
Rr = G*(CRr.*Rr + b); 
min1 = min(min(Rr)); 
max1 = max(max(Rr)); 
Rr_final = im2uint8((Rr-min1)/(max1-min1)); 

HSI_mod = HSI;
HSI_mod(:,:,3) = Rr_final;
output = uint8(hsi_rgb(HSI_mod));

end