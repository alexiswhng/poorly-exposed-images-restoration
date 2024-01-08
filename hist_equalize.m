function [output] = hist_equalize(image)

[h, w] = size(image); %size
numofpixels = h * w; %total

output = uint8(zeros(h,w)); %initialize

%num of bins is 255
histogram = imhist(image); %obtain histogram 
prob = zeros(256,1); %initialize
cumulative = zeros(256,1); %initialize

%count the occurence of each pixel and then calculate pdf and cumulative
%histogram
freq = 0;
for i = 1:size(histogram)
    freq = freq + histogram(i);
    prob(i) = freq/numofpixels; 
    cumulative(i) = round(prob(i) * (256-1));
end

%transformation for each pixel
for i=1:h
    for j=1:w
        output(i,j) = cumulative(image(i,j) + 1);
    end
end


