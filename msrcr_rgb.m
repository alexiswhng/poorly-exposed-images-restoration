function [output] = msrcr_rgb(image)

I = double(image);

R1 = I(:,:,1); 
G1 = I(:,:,2); 
B1 = I(:,:,3); 

%%%%%%%%%%Set the Gaussian parameter%%%%%% 
%(Recommended parameters by Jobson)
sigma1 = 15;
sigma2 = 80;
sigma3 = 250;
alpha = 125;
beta = 46;
G = 192;
b = -30; 

[row,col] = size(R1);

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


%%%%%%% R Component %%%%%%%%

R_log = log(R1+1);  %take log of R
R_fft = fft2(R1);  %fourier transform of R (convert to frequency domain)

%sigma1
Rr = ifft2(fgauss1.*R_fft);  %After convoluting, transform back into the spatial domain
min1 = min(min(Rr));  %Add 1 incase of zero case
Rr_log = log(Rr - min1 + 1); %apply Rmsr equation
Rr1 = R_log - Rr_log;  

%repeat for sigma2
Rr = ifft2(fgauss2.*R_fft);  
Rr_log = log(Rr+1);  
Rr2 = R_log - Rr_log; 

%repeat for sigma3
Rr = ifft2(fgauss3.*R_fft); 
Rr_log= log(Rr+1); 
Rr3 = R_log - Rr_log; 

Rr = 1/3*Rr1 + 1/3*Rr2 + 1/3*Rr3;   %recommended weighted sum 

%Calculate CR 
CRr = beta*(log(alpha*R1+1)-log(R1+G1+B1+1)); 

%MSRCR 
Rr = G*(CRr.*Rr+b); 
min1 = min(min(Rr)); 
max1 = max(max(Rr)); 
red = im2uint8((Rr-min1)/(max1-min1)); 

%%%%%%%%%% G Component%%%%%%% 
 
G_log = log(G1+1);   
G_fft = fft2(G1);  

Rg = ifft2(fgauss1.*G_fft);  
Rg_log = log(Rg+1); 
Rg1 = G_log - Rg_log;  

Rg = ifft2(fgauss2.*G_fft); 
Rg_log= log(Rg+1); 
Rg2 = G_log - Rg_log; 

Rg= ifft2(fgauss3.*G_fft); 
Rg_log = log(Rg+1); 
Rg3 = G_log - Rg_log;  

Rg = 1/3*Rg1 + 1/3*Rg2 + 1/3*Rg3; 

%Calculate CR 
CRg = beta*(log(alpha*G1+1)-log(R1+G1+B1+1)); 

%MSRCR 
Rg = G*(CRg.*Rg+b); 
min1 = min(min(Rg)); 
max1 = max(max(Rg)); 
green = im2uint8((Rg-min1)/(max1-min1)); 

%%%%%%%%%% B Component %%%%%%% 

B_log = log(B1+1); 
B_fft = fft2(B1); 

Rb = ifft2(fgauss1.*B_fft); 
Rb_log= log(Rb+1); 
Rb1 = B_log - Rb_log; 

Rb = ifft2(fgauss2.*B_fft); 
Rb_log = log(Rb+1); 
Rb2 = B_log - Rb_log; 

Rb = ifft2(fgauss3.*B_fft); 
Rb_log = log(Rb+1); 
Rb3 = B_log - Rb_log; 

Rb = 1/3*Rb1 + 1/3*Rb2 + 1/3 *Rb3; 

%Calculate CR 
CRb = beta*(log(alpha*B1+1)-log(R1+G1+B1+1)); 

%MSRCR 
Rb = G*(CRb.*Rb+b); 
min1 = min(min(Rb)); 
max1 = max(max(Rb)); 
blue = im2uint8((Rb-min1)/(max1-min1)); 

output = im2uint8(cat(3,red,green,blue));

end