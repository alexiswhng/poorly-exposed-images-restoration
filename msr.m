function [output] = msr(image)

I = double(image);

R = I(:,:,1); 
G = I(:,:,2); 
B = I(:,:,3); 

%%%%%%%%%%Set the Gaussian parameter%%%%%% 

sigma1 = 15;   
sigma2 = 80; 
sigma3 = 200; 
[row,col] = size(R);

%Gaussian function - built in function also normalizes
Gauss_1 = fspecial('gaussian', [row, col], sigma1);
Gauss_2 = fspecial('gaussian', [row, col], sigma2);
Gauss_3 = fspecial('gaussian', [row, col], sigma3); 

% [x, y]=meshgrid((-col-1)/2):(col/2),(-row-1)/2):(size(row/2));   
% gauss = exp(-(x.^2+y.^2)/(2*sigma*sigma));  %Gaussian function
% Gauss = gauss/sum(gauss(:)); %normalization

fgauss1 = fft2(Gauss_1,row,col); %Take fourier transform of function
fgauss1 = fftshift(fgauss1); %FFT shift to center 
fgauss2 = fft2(Gauss_2,row,col);
fgauss2 = fftshift(fgauss2);
fgauss3 = fft2(Gauss_3,row,col);
fgauss3 = fftshift(fgauss3);


%%%%%%% R Component %%%%%%%%

R_log = log(R+1);  %take log of R
R_fft = fft2(R);  %fourier transform of R (convert to frequency domain)

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
Rr3=R_log-Rr_log; 

Rr = 1/3*Rr1 + 1/3*Rr2 + 1/3*Rr3;   %recommended weighted sum 

MSR1 = Rr;

%makes sure value are within display domain [0 255] - each colour channel
%is adjust by the absolute min and max of three colour bands
min1 = min(min(MSR1)); 
max1 = max(max(MSR1)); 
MSR1 = uint8(255*(MSR1-min1)/(max1-min1)); 

%%%%%%%%%% G Component%%%%%%% 
 
G_log = log(G+1);   
G_fft = fft2(G);  

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

MSR2 = Rg;

min2 = min(min(MSR2)); 
max2 = max(max(MSR2)); 
MSR2 = uint8(255*(MSR2-min2)/(max2-min2)); 

%%%%%%%%%% B Component %%%%%%% 

B_log = log(B+1); 
B_fft = fft2(B); 

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

MSR3 = Rb;
min3 = min(min(MSR3)); 
max3 = max(max(MSR3)); 
MSR3 = uint8(255*(MSR3-min3)/(max3-min3));

output = im2uint8(cat(3,MSR1,MSR2,MSR3));
end



