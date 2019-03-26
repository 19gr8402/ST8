clc
clear all
clearvars -except Subject initialcontour
%% Start
if ~exist('Subject','var')
    load('C:\Users\mathi\Google Drive\ST8\MATLAB\Sorteret_MRI_data_SubjectsOnly.mat')
end

test_img = Subject(4).Session.T2.right(:,:,2);
test_img1 = imadjust(test_img);  %Hvad gør den?


subplot(1,2,1)
imshow(test_img)
title('m. imadjust')
subplot(1,2,2)
imshow(test_img1, [])
title('m. imadjust')

%% Preprocessing
%Inspireret fra Kemnitz2017

% Adaptive histogram equalization - to increase contrast
img_eq0 = adapthisteq(test_img1);
img_eq1 = adapthisteq(test_img1, 'clipLimit',0.02,'Distribution','rayleigh');
img_eq2 = adapthisteq(test_img1, 'NumTiles', [16 16], 'clipLimit',0.02,'Distribution','rayleigh');
img_eq3 = adapthisteq(test_img1, 'NumTiles', [8 8], 'clipLimit',0.009,'Distribution','exponential');

img_eq = img_eq3;

figure
subplot(2,2,1)
imshow(img_eq0)
title('img_eq0')
subplot(2,2,2)
imshow(img_eq1)
title('img_eq1')
subplot(2,2,3)
imshow(img_eq2)
title('img_eq2')
subplot(2,2,4)
imshow(img_eq3)
title('img_eq3')

%%
% Filtering by a 2x2 Median filter
img_filt = medfilt2(img_eq,[2 2]);

% figure
% subplot(3,2,1)
% imshow(test_img,[])
% title('Original - Adjusted')
% subplot(3,2,2)
% imhist(test_img)
% subplot(3,2,3)
% imshow(img_eq,[])
% title('Equalized')
% subplot(3,2,4)
% imhist(img_eq)
% subplot(3,2,5)
% imshow(img_filt,[])
% title('Filtered')
% subplot(3,2,6)
% imhist(img_filt)

%% Simpel Watershed 
level = graythresh(img_eq);
img_eq_gray = im2bw(img_eq,level);

gmag = imgradient(img_eq_gray);

D = bwdist(~img_eq_gray); 
D(~img_eq_gray) = -Inf;

L = watershed(D);

img_water = img_eq;
img_water(L ~= 0) = 0;
imshow(img_water);

subplot(1,2,1)
imshow(img_eq)
title('Original w. Adaptive Histogram Equalization')
subplot(1,2,2)
imshow(img_water);
title('Segmented Ultrasound')

%% Marker Based Segmentation

level = graythresh(img_eq);
img_eq_gray = im2bw(img_eq,level);

gmag = imgradient(img_eq_gray);


se = strel('disk',10); %Structuring element
Io = imopen(img_eq,se); %Opening
Ioc = imclose(Io,se); %Subsequent closing

%Opening-by-Reconstruction
Ie = imerode(img_eq,se); %Erode
Iobr = imreconstruct(Ie,img_eq);
Iobr = im2double(Iobr);

subplot(2,2,1)
imshow(img_eq)
title('Original')
subplot(2,2,2)
imshow(Io)
title('Opening')
subplot(2,2,3)
imshow(Iobr)
title('Opening-by-Reconstruction')
subplot(2,2,4)
imhist(Iobr)
title('Histogram')

% 
% %Thresholding w. 2 thresholds
% T_manual1 = 0.5;
% T_manual2 = 0.2;
% IobrT = Iobr>=T_manual2 & Iobr <=T_manual1;
% 
% CC = bwconncomp(IobrT);
% numPixels = cellfun(@numel,CC.PixelIdxList);
% [biggest,idx] = max(numPixels);
% for i=1:length(CC.PixelIdxList)
% if i == idx
%     
% else
%  IobrT(CC.PixelIdxList{i}) = 0;
% end
% end
% 
% se = strel('disk',2);
% IobrTc = imopen(IobrT, se);
% 
% IobrN = Iobr;
% IobrN(IobrTc==0)=0;
% 
% 
% figure
% subplot(1,2,1)
% imshow(IobrTc)
% title('Manual Thresholds')
% subplot(1,2,2)
% imshow(IobrN)
%% Load markers

if ~exist('initialcontour','var')
   load initialcontour.mat;
end

markers = initialcontour;

%%
%Calculate the regional maxima of Iobrcbr to obtain good foreground markers
%markers = imregionalmax(Iobr,8);
I2 = labeloverlay(img_eq,markers);

figure;
subplot(1,2,1)
imshow(markers)
title('Regional Maxima of Opening-Closing by Reconstruction')
subplot(1,2,2)
imshow(I2)
title('Regional Maxima Superimposed on Original Image')

%%
% % Clean edges and shrink markers
% se2 = strel(ones(5,5));
% fgm2 = imclose(markers,se2);
% fgm3 = imerode(fgm2,se2);
% 
% % Remove stray pixels
% fgm4 = bwareaopen(fgm3,10);

%Connected components to remove the bright objects in the corners
% CC = bwconncomp(markerr);
% numPixels = cellfun(@numel,CC.PixelIdxList);
% [biggest,idx] = max(numPixels);
% for i=1:length(CC.PixelIdxList)
% if i == idx
%     
% else
%  markers(CC.PixelIdxList{i}) = 0;
% end
% end

%I3 = labeloverlay(ultrasound ,fgm4);

% figure;
% subplot(1,2,1)
% imshow(marker)
% title('Regional Maxima of Opening-Closing by Reconstruction')
% subplot(1,2,2)
% imshow(I2)
% title('Regional Maxima Superimposed on Original Image')
% subplot(2,2,3)
% imshow(fgm4)
% title('Modified Opening-Closing by Reconstruction')
% subplot(2,2,4)
% imshow(I3)
% title('Modified Regional Maxima Superimposed on Original Image')

%Compute background markers
com = imcomplement(Iobr);
bw = imbinarize(com,0.55);

figure
imshow(bw)
title('Thresholded Opening-Closing by Reconstruction')

D = bwdist(bw);
%D(bw) = -Inf;
DL = watershed(D);
bgm = DL == 0;
imshow(bgm)
title('Watershed Ridge Lines)')


%Compute Watershed Transform and Segmentation
gmag2 = imimposemin(gmag, bgm | markers);
% se = strel('disk',2);
% gmag2= imopen(gmag2, se);

L = watershed(gmag2);

%Visualize
labels = imdilate(L==0,ones(4,4)) + 2*bgm + 3*markers;
I4 = labeloverlay(img_eq,labels);
imshow(I4)
title('Markers and Object Boundaries Superimposed on Original Image')


Lrgb = label2rgb(L,'jet','w','shuffle');

figure
imshow(img_eq)
hold on
himage = imshow(Lrgb);
himage.AlphaData = 0.3;
title('Colored Labels Superimposed Transparently on Original Image')


%%
subplot(3,3,1)
imshow(manSegS_s1_r2{1,1})
subplot(3,3,2)
imshow(manSegS_s1_r2{2,1})
subplot(3,3,3)
imshow(manSegS_s1_r2{3,1})
subplot(3,3,4)
imshow(manSegS_s1_r2{4,1})
subplot(3,3,5)
imshow(manSegS_s1_r2{5,1})
subplot(3,3,6)
imshow(manSegS_s1_r2{6,1})
subplot(3,3,7)
imshow(manSegS_s1_r2{7,1})
subplot(3,3,8)
imshow(manSegS_s1_r2{8,1})
subplot(3,3,9)
imshow(manSegS_s1_r2{9,1})