%% Watershed segmentation

clear all
close all
clc
load('mri_knee.mat')
load('mri_knee_seg.mat')
img = double(mri_knee(:,:,5));
figure;imshow(img, []);

lap = [1 1 1; 1 -8 1; 1 1 1]; % filter kernel
resp = imfilter(img, lap, 'conv'); %// Change

%// Change - Normalize the response image
minR = min(resp(:));
maxR = max(resp(:));
resp = (resp - minR) / (maxR - minR);

%// Change - Adding to original image now
sharpened = img + resp;

%// Change - Normalize the sharpened result
minA = min(sharpened(:));
maxA = max(sharpened(:));
sharpened = (sharpened - minA) / (maxA - minA);
figure; imshow(sharpened,[]);

imageUS2 = bfilter2(sharpened./255);
figure;imshow(imageUS2, []);

BW2 = imclearborder(img,4);
figure;imshow(BW2);

% internal marker selection
D1 = bwdist(~BW2);
figure;imshow(D1, []);            
D2 = mat2gray(D1>0.6.*max(D1(:)));
figure;imshow(D2, []);
im=D2;

% external marker selection
min_im = imextendedmin(D1,5);
figure;imshow(min_im, []);
Lim = watershed(bwdist(~min_im));
figure;imagesc(Lim);colormap gray
em = Lim ==0;
figure;imagesc(Lim ==0);colormap gray
[Gmag,Gdir] = imgradient(imageUS2); %Use better gradient
figure;imagesc(Gmag);colormap hot
% Super imposing the external and internal markers back to the gradient
% image
g2 = imimposemin(Gmag,im|em);
figure;imagesc(g2);colormap gray
% watershed segmentation using the new gradient image.
L2 = watershed(g2);
bw=L2==0;
% Overlaying the segmented border with the original MRI image. 
img = 255.*(img./max(max(img)));
rgb = imoverlay(uint8(img), bw, [0 1 0]);
figure;imshow(rgb,[])

b=imbinarize(double(bw));
figure; imshow(b,[]);
imwrite(b,'C:\Users\Sumana\Documents\HW & Assignments\Signal and Image processing\Hw 6\Segementations\prob 3\New Folder\ws5.jpg');
