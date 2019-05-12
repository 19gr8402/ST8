% Example of implementation

clearvars -except Subject; close all; clc;

%% Load data
% load('D:\Noter\Project\Sorteret_MRI_data_SubjectsOnly.mat')
% load('C:\Users\mathi\Google Drive\ST8\MATLAB\Sorteret_MRI_data_SubjectsOnly.mat')
load('manSegS_s1_r2_6comp');
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
figure; imshow(Segout,[]);

%% Image registration

echoPlanarImages = flip(Subject(i).Session(1).BOLD.left(:,:,:),2);

[BOLDsequence]=Image_registration_and_BOLD(I,echoPlanarImages,ISegmented,showMethod);

%Filtrering m. lavpas, cutoff= 0.05
[BOLDsequence]= BOLD_filter(BOLDsequence, 1) %[BOLDsequence]=BOLD_filter(BOLDsequence,showPlots)

figure; subplot(2,3,1); plot(BOLDsequence(1).Seg); title('Anterior: BOLD');
subplot(2,3,2); plot(BOLDsequence(2).Seg); title('Lateral: BOLD');
subplot(2,3,3); plot(BOLDsequence(3).Seg); title('Deep: BOLD');
subplot(2,3,4); plot(BOLDsequence(4).Seg); title('Soleus: BOLD');
subplot(2,3,5); plot(BOLDsequence(5).Seg); title('Lateral head of Gatrocnemius: BOLD');
time = toc;
end

