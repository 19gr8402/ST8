clc
clear all
clearvars -except Subject
%% Start
if ~exist('Subject','var')
    load('C:\Users\mathi\Google Drive\ST8\MATLAB\Sorteret_MRI_data_SubjectsOnly.mat')
end

test_img = Subject(4).Session.T2.right(:,:,2);
test_img1 = imadjust(test_img);
ub = max(imhist(test_img));
lb = min(imhist(test_img));
test_img2 = imadjust(test_img,[0.2 0.5]);

subplot(1,2,1)
imshow(test_img1)
subplot(1,2,2)
imshow(test_img2, [])
title('m. imadjust')

%% Preprocessing
%Inspireret fra Kemnitz2017

% Adaptive histogram equalization - to increase contrast
img_eq = adapthisteq(test_img1);


% Filtering by a 2x2 Median filter
img_filt = medfilt2(img_eq,[2 2]);

figure
subplot(3,2,1)
imshow(test_img,[])
title('Original - Adjusted')
subplot(3,2,2)
imhist(test_img)
subplot(3,2,3)
imshow(img_eq,[])
title('Equalized')
subplot(3,2,4)
imhist(img_eq)
subplot(3,2,5)
imshow(img_filt,[])
title('Filtered')
subplot(3,2,6)
imhist(img_filt)
