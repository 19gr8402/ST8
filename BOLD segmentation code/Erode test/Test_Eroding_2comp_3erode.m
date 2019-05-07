% Test for erodeinger

% Example of implementation

clearvars -except Subject; close all; clc;

%% Load data
%load('D:\Noter\Project\Sorteret_MRI_data_SubjectsOnly.mat')
% load('C:\Users\mathi\Google Drive\ST8\MATLAB\Sorteret_MRI_data_SubjectsOnly.mat')
load('manSegS_s1_r2_6comp');
load('manSegS_s1_r2_6comp_Ground_Truth');
tic;
showMethod = true;

%% ASM segmentation
for i=2:2
    
    
I=flip(Subject(i).Session(1).T2.left(:,:,2),2);
ISegmented = ASM_Segmentation_BOLD(I);
% Plot
Segout = mat2gray(I);
for k=1:5
Outline = bwperim(ISegmented(k).Seg);
Segout(Outline) = 1;
end
figure; imshow(Segout,[]); title('ASM');

%% Our ground truth

ISegmentedGT = manSegGroundTruth(i).Subject(1:5);
Segout = mat2gray(I);
for k=1:5
Outline = bwperim(ISegmentedGT(k).Seg);
Segout(Outline) = 1;
end
figure; imshow(Segout,[]); title('GT');

%% Image registration

echoPlanarImages = double(mat2gray(Subject(i).Session(1).BOLD.right(:,:,:)));

[BOLDsequenceGT]=Image_registration_and_BOLD(I,echoPlanarImages,ISegmentedGT,showMethod);

[BOLDsequence]=Image_registration_and_BOLD(I,echoPlanarImages,ISegmented,showMethod);

%% ER2
for i=1:5
    seD = strel('diamond',2);
    ISegmentedER2(i).Seg=imerode(ISegmented(i).Seg,seD);
end

% Plot
Segout = mat2gray(I);
for k=1:5
Outline = bwperim(ISegmentedER2(k).Seg);
Segout(Outline) = 1;
end
figure; imshow(Segout,[]); title('ASM ER2');

[BOLDsequenceER2]=Image_registration_and_BOLD(I,echoPlanarImages,ISegmentedER2,showMethod);

%% ER5
for i=1:5
    seD = strel('diamond',5);
    ISegmentedER5(i).Seg=imerode(ISegmented(i).Seg,seD);
end

% Plot
Segout = mat2gray(I);
for k=1:5
Outline = bwperim(ISegmentedER5(k).Seg);
Segout(Outline) = 1;
end
figure; imshow(Segout,[]); title('ASM ER5');

[BOLDsequenceER5]=Image_registration_and_BOLD(I,echoPlanarImages,ISegmentedER5,showMethod);

%% ER10
for i=1:5
    seD = strel('diamond',10);
    ISegmentedER10(i).Seg=imerode(ISegmented(i).Seg,seD);
end

% Plot
Segout = mat2gray(I);
for k=1:5
Outline = bwperim(ISegmentedER10(k).Seg);
Segout(Outline) = 1;
end
figure; imshow(Segout,[]); title('ASM ER10');

[BOLDsequenceER10]=Image_registration_and_BOLD(I,echoPlanarImages,ISegmentedER10,showMethod);

%% Plot
figure; subplot(2,1,1); plot(BOLDsequenceGT(1).Seg,'k'); title('Anterior: BOLD');
hold on; plot(BOLDsequence(1).Seg,'g');
hold on; plot(BOLDsequenceER2(1).Seg,'b');
hold on; plot(BOLDsequenceER5(1).Seg,'y');
hold on; plot(BOLDsequenceER10(1).Seg,'r'); legend('GT','ASM','ASM ER2','ASM ER5','ASM ER10');

subplot(2,1,2); plot(BOLDsequenceGT(5).Seg,'k'); title('Medial head of Gatrocnemius: BOLD');
hold on; plot(BOLDsequence(5).Seg,'g');
hold on; plot(BOLDsequenceER2(5).Seg,'b');
hold on; plot(BOLDsequenceER5(5).Seg,'y');
hold on; plot(BOLDsequenceER10(5).Seg,'r'); legend('GT','ASM','ASM ER2','ASM ER5','ASM ER10');

time = toc;
end

