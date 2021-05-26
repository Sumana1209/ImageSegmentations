%% Random walker segmentation

clear all
close all
clc
%Read image 
load mri_knee.mat 
imageUS=double((mri_knee(:,:,10))); 
lap = [1 1 1; 1 -8 1; 1 1 1]; % filter kernel 
resp = imfilter(imageUS, lap, 'conv'); %// Change 
 
%// Change - Normalize the response image 
minR = min(resp(:)); 
maxR = max(resp(:)); 
resp = (resp - minR) / (maxR - minR); 
 
%// Change - Adding to original image now 
sharpened = imageUS + resp; 
 
%// Change - Normalize the sharpened result 
minA = min(sharpened(:)); 
maxA = max(sharpened(:)); 
sharpened = (sharpened - minA) / (maxA - minA); 
figure; imshow(sharpened,[]); 
 
imageUS2 = bfilter2(sharpened./255); 
figure;imshow(imageUS2, []); 
imageUS2 = 255.*(imageUS2./max(max(imageUS2))); 
 
 
%img is the image you are trying to segment 
img=imageUS2; 
[X Y]=size(img); 
figure;imshow(img,[]); 
 
number_seeds=20; % half of this number will be foreground half will be background 
[x,y] = ginput(number_seeds); 
 
x=floor(x); 
y=floor(y); 
 
for r=1:number_seeds 
seeds(r) = sub2ind([X Y],y(r),x(r)); 
end 
 
[mask,probabilities] = random_walker(img,seeds,[ones(1,number_seeds/2),(ones(1,number_seeds/2)+1)]); 
seg=probabilities(:,:,1); 
figure; imshow(seg,[]);colormap % for final results please threshold the probability map 
seg1=imbinarize(seg); 
figure; imshow(seg1); 
 
% imwrite(seg1,'C:\Users\Sumana\Documents\HW & Assignments\Signal and Image processing\Hw 6\Segementations\prob 2\New Folder\slice10.jpg');

