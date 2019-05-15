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

%% ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤        Chan-Vese segmentation     ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
m = zeros(size(I,1),size(I,2));          %-- create initial mask
for i=1:10
    m((i*10)+100:(i*10)+105,15:500) = 1;
    m((i*10)+200:(i*10)+205,15:500) = 1;
    m((i*10)+300:(i*10)+305,15:500) = 1;
end

IBinarySeg = region_seg(I, m, 800,0.1,showMethod); %-- Run segmentation

%% ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤    After processing     ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

%% Remove small objects.
IBinary = bwareaopen(IBinarySeg, 400); 

%% Cut
I = IOrg;
I(IBinary==1)=0;

%% Binary 
IBinary2temp = imbinarize(I);

%% Fill
IBinary2 = imfill(IBinary2temp, 'holes');

%% Remove small

% Erode
seD = strel('diamond',1);
IBinary2 = imerode(IBinary2,seD);

IBinary2 = bwareaopen(IBinary2, 3000); %30 at half image size

IBinary2 = imdilate(IBinary2,seD);

%% Cut
Iexport = IOrg;
Iexport(IBinary2==0)=0;
IFatAndBoneBinary = IBinary2;

%% ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤         Remove fibula         ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

%% Binary with no background
IBinary2temp(IBinary2==0)=1;

%% Add bone segment (unfortunately + potential noise -> only keep largest)
IBoneSeg = IBinarySeg - bwareaopen(IBinarySeg, 400);
IBinary2temp(IBoneSeg==1)=0;

%% Invers
Iinverse = imcomplement(IBinary2temp);

%% Erode
seD = strel('diamond',2);
Iinverse = imerode(Iinverse,seD);

%% Keep largest
%IBinary3 = bwareafilt(Iinverse,1); %¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
IBinary3 = bwareaopen(Iinverse,300);

%% Dilate
IBinary3 = imdilate(IBinary3,seD);

%% Fill
IBinary3 = imfill(IBinary3, 'holes');

%% ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤    Final cut    ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
INoMuscle = IOrg;
Iexport = IOrg;
IFatAndBoneBinary(IBinary3==1)=0;
Iexport(IFatAndBoneBinary==0)=0;
INoMuscle(IFatAndBoneBinary==1)=0;

end