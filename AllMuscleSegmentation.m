function [Iexport, INoMuscle, IFatAndBoneBinary] = AllMuscleSegmentation(IOrg,showResult)

% Example of implementation
%load('Sorteret_MRI_data_SubjectsOnly.mat')
%IOrg = mat2gray(Subject(1).Session(1).T2(1).right(:,:,2));
%showResult = true;
%[IMuscle, INoMuscle, IFatAndBoneBinary] = AllMuscleSegmentation(IOrg,showResult);

% Requires region_seg.m from Region Based Active Contour Segmentation
% (Chan - Vese) and ExternalForceImage2D from SNAKE implementation by 
% D.Kroon University of Twente (July 2010)

showMethod = false; %Can be set to true for analysis

% Energy options
Options=struct;
Options.Wedge=-0.1;
Options.Wline=0.01;
Options.Wterm=0.8;
Options.Sigma1=0.8;

%% ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤     External energy image    ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

I = ExternalForceImage2D(IOrg,Options.Wline, Options.Wedge, Options.Wterm,Options.Sigma1);
if showMethod == true
figure; imshow(I,[]); title('External Force Image');
end

%% ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤        Chan-Vese segmentation     ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
m = zeros(size(I,1),size(I,2));          %-- create initial mask
for i=1:10
    m((i*10)+100:(i*10)+105,15:500) = 1;
    m((i*10)+200:(i*10)+205,15:500) = 1;
    m((i*10)+300:(i*10)+305,15:500) = 1;
end

if showMethod == true
figure;
subplot(2,2,1); imshow(I,[]); title('Input Image');
subplot(2,2,2); imshow(m); title('Initialization');
subplot(2,2,3); title('Segmentation');
end

IBinarySeg = region_seg(I, m, 800,0.1,showMethod); %-- Run segmentation
if showMethod == true
subplot(2,2,4); imshow(IBinarySeg,[]); title('Global Region-Based Segmentation');
end

%% ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤    After processing     ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

%% Remove small objects.
IBinary = bwareaopen(IBinarySeg, 400); 
if showMethod == true
    figure; imshow(IBinary,[]), title('cleared off small objects');
end

%% Cut
I = IOrg;
IFatAndBone = IOrg;
I(IBinary==1)=0;
if showMethod == true
    figure; imshow(I,[]), title('Cut image');
end

%% Binary 
IBinary2temp = imbinarize(I);
if showMethod == true
    figure; imshow(IBinary2temp,[]), title('Binary');
end

%% Fill
IBinary2 = imfill(IBinary2temp, 'holes');

%% Remove small

% Erode
seD = strel('diamond',1);
IBinary2 = imerode(IBinary2,seD);
if showMethod == true
figure; imshow(IBinary2,[]), title('Erode');
end

IBinary2 = bwareaopen(IBinary2, 3000); %30 at half image size
if showMethod == true
figure; imshow(IBinary2,[]), title('Remove small');
end

IBinary2 = imdilate(IBinary2,seD);
if showMethod == true
figure; imshow(IBinary2,[]), title('Dilate');
end

%% Cut
Iexport = IOrg;
Iexport(IBinary2==0)=0;
IFatAndBoneBinary = IBinary2;
if showMethod == true
    figure; imshow(Iexport,[]), title('Cut image');
end

%% ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤         Remove fibula         ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

%% Binary with no background
IBinary2temp(IBinary2==0)=1;
if showMethod == true
    figure; imshow(IBinary2temp,[]), title('Binary with no background image');
end

%% Add bone segment (unfortunately + potential noise -> only keep largest)
IBoneSeg = IBinarySeg - bwareaopen(IBinarySeg, 400);
if showMethod == true
    figure; imshow(IBoneSeg,[]), title('Binary with no background image');
end
IBinary2temp(IBoneSeg==1)=0;

%% Invers
Iinverse = imcomplement(IBinary2temp);
if showMethod == true
figure; imshow(Iinverse,[]); title('Inverse image');
end

%% Erode
seD = strel('diamond',2);
Iinverse = imerode(Iinverse,seD);
if showMethod == true
figure; imshow(Iinverse,[]), title('Erode');
end

%% Keep largest
%IBinary3 = bwareafilt(Iinverse,1); %¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
IBinary3 = bwareaopen(Iinverse,300);
if showMethod == true
figure; imshow(IBinary3,[]), title('Keep over 400 pixel');
end

%% Dilate
IBinary3 = imdilate(IBinary3,seD);
if showMethod == true
figure; imshow(IBinary3,[]), title('Dilate');
end

%% Fill
IBinary3 = imfill(IBinary3, 'holes');
if showMethod == true
figure; imshow(IBinary3,[]), title('Fill');
end

%% ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤    Final cut    ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
INoMuscle = IOrg;
Iexport = IOrg;
IFatAndBoneBinary(IBinary3==1)=0;
Iexport(IFatAndBoneBinary==0)=0;
INoMuscle(IFatAndBoneBinary==1)=0;

%% Plot Result
if showMethod == true || showResult == true
Outline2 = bwperim(IBinary2);
Outline3 = bwperim(IBinary3);
Segout = IOrg; 
Segout(Outline2) = 1;
Segout(Outline3) = 1;
figure, subplot(2,2,1); imshow(Segout,[]), title('Outlined original image');
% Show cut
subplot(2,2,2); imshow(Iexport,[]), title('Cut original muscle image');
subplot(2,2,3); imshow(INoMuscle,[]), title('Cut original no muscle image');
subplot(2,2,4); imshow(IFatAndBoneBinary,[]), title('Binary image');
end

end