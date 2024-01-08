function [output] = hsi_rgb(image)

% image = im2double(image);

H = image(:,:,1);  
S = image(:,:,2);  
I = image(:,:,3);  

H = H*360;  %multipy 360 to be in the range of 0-360                                             
[row,col,ch] = size(H);

R = zeros(row,col);  
G = zeros(row,col);  
B = zeros(row,col);  
RGB = zeros([row,col,ch]);  

%For 0<=H<120
B(H<120) = I(H<120).*(1-S(H<120));  
R(H<120) = I(H<120).*(1+((S(H<120).*cosd(H(H<120)))./cosd(60-H(H<120))));  
G(H<120) = 3.*I(H<120)-(R(H<120)+B(H<120));  

%For 120<=H<240
H2 = H-120;  
R(H>=120&H<240) = I(H>=120&H<240).*(1-S(H>=120&H<240));  
G(H>=120&H<240) = I(H>=120&H<240).*(1+((S(H>=120&H<240).*cosd(H2(H>=120&H<240)))./cosd(60-H2(H>=120&H<240))));  
B(H>=120&H<240) = 3.*I(H>=120&H<240)-(R(H>=120&H<240)+G(H>=120&H<240));  

%For 240<=H<360
H2 = H-240;  
G(H>=240&H<=360) = I(H>=240&H<=360).*(1-S(H>=240&H<=360));  
B(H>=240&H<=360) = I(H>=240&H<=360).*(1+((S(H>=240&H<=360).*cosd(H2(H>=240&H<=360)))./cosd(60-H2(H>=240&H<=360))));  
R(H>=240&H<=360) = 3.*I(H>=240&H<=360)-(G(H>=240&H<=360)+B(H>=240&H<=360));  

%Construct Image  
RGB(:,:,1) = R;  
RGB(:,:,2) = G;  
RGB(:,:,3) = B;  

% RGB = im2uint8(RGB);

output = RGB;


end


