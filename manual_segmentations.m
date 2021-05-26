%% Manual segmentations

clear all
close all
clc
load('mri_knee.mat')
imageUS = double(mri_knee(:,:,2));
figure;imshow(imageUS, []);

clear imageUS_seg_manual_final 
imageUS_seg_manual_final = zeros(size(imageUS)); 
 reg= 2 % hoe many regions do you want to segment 
for s=1:reg 
    e=imshow(uint8(imageUS)); 
    b=imageUS; 
    figure; 
    imshow(uint8(imageUS)); 
    c=imfreehand(gca); 
    d=createMask(c,e); 
     imageUS_seg_manual_final = imageUS_seg_manual_final+d; 
     s=s+1;
     imshow(imageUS_seg_manual_final,[]);
end 
I=imageUS_seg_manual_final;
% imwrite(I,'C:\Users\Sumana\Documents\HW & Assignments\Signal and Image processing\Hw 6\Segementations\slice2.jpg');
