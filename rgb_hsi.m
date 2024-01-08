function [output] = rgb_hsi(image)

% image = im2double(image);

R = image(:,:,1);
G = image(:,:,2);
B = image(:,:,3);


%Intensity 
I = (R+G+B)./3;

%Saturation
S = 1-(3./(R+G+B)+0.0001).*min(image,[],3);

%Hue
num = 1/2*((R-G)+(R-B));
denom = sqrt(((R-G).^2+((R-B).*(G-B))));

H = acosd(num./(denom+0.0001)); %add small number to make sure denominator doesn't equal 0

H(B>G) = 360-H(B>G); %For B>G 

H = H/360; %to normalize to the range [0 1]

[row, col, ch] = size(image);
HSI=zeros(row,col,ch);
HSI(:,:,1)=H;
HSI(:,:,2)=S;
HSI(:,:,3)=I;

% HSI = im2uint8(HSI);

output = HSI;

