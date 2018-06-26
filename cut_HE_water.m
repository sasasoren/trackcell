function [Original_img, L_img]=cut_HE_water(I,n,m,x,y,c)
%I is an image n and m is the coordinator that we want to cut our image, x and y is the length of cropping the image,
%after that in this function we use Histogram Equalization and and water-%shed on image.

%First we are finding cdf of image and changing the image to uint8
[pixelCount,~] = imhist(I);
cdf = cumsum(pixelCount)/sum(pixelCount);
seg_resh = im2uint8(I);
G = cdf(seg_resh);

% quantitative measures
mean_1 = mean(mean(G));
std_1 = std(std(G));
%imhist(G); %saveas(gcf,'hist_1','png'); 
l2_1 = norm(G);

% watershed transform for G
%G_region = G;
G_region = G(n:n+x,m:m+y);
Original_img = G_region;
G_new = imhmin(G_region,c);
L_new = watershed(G_new);
L_img = L_new;
L_img(L_img ~= 0) = 1;
end
