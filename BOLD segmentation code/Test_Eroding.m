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
for i=1:1
    
    
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

for i=1:5
    seD = strel('diamond',1);
    ISegmentedER1(i).Seg=imerode(ISegmented(i).Seg,seD);
end

% Plot
Segout = mat2gray(I);
for k=1:5
Outline = bwperim(ISegmentedER1(k).Seg);
Segout(Outline) = 1;
end
figure; imshow(Segout,[]); title('ASM ER1');

[BOLDsequenceER1]=Image_registration_and_BOLD(I,echoPlanarImages,ISegmentedER1,showMethod);

figure; subplot(2,3,1); plot(BOLDsequenceGT(1).Seg,'r'); title('Anterior: BOLD');
hold on; plot(BOLDsequence(1).Seg,'g');
hold on; plot(BOLDsequenceER1(1).Seg,'b'); legend('GT','ASM','ASM ER1');

subplot(2,3,2); plot(BOLDsequenceGT(2).Seg,'r'); title('Lateral: BOLD');
hold on; plot(BOLDsequence(2).Seg,'g');
hold on; plot(BOLDsequenceER1(2).Seg,'b'); legend('GT','ASM','ASM ER1');

subplot(2,3,3); plot(BOLDsequenceGT(3).Seg,'r'); title('Deep: BOLD');
hold on; plot(BOLDsequence(3).Seg,'g');
hold on; plot(BOLDsequenceER1(3).Seg,'b'); legend('GT','ASM','ASM ER1');

subplot(2,3,4); plot(BOLDsequenceGT(4).Seg,'r'); title('Soleus: BOLD');
hold on; plot(BOLDsequence(4).Seg,'g'); 
hold on; plot(BOLDsequence(4).Seg,'b'); legend('GT','ASM','ASM ER1');

subplot(2,3,5); plot(BOLDsequenceGT(5).Seg,'r'); title('Lateral head of Gatrocnemius: BOLD');
hold on; plot(BOLDsequence(5).Seg,'g');
hold on;  plot(BOLDsequenceER1(5).Seg,'b'); legend('GT','ASM','ASM ER1');

time = toc;
end

