clearvars -except Subject; close all; clc


%% Load data
%load('D:\Noter\Project\Sorteret_MRI_data_SubjectsOnly.mat')
% load('C:\Users\mathi\Google Drive\ST8\MATLAB\Sorteret_MRI_data_SubjectsOnly.mat')
%load('manSegS_s1_r2_6comp');
load('segmentation31TrainSubjects');

%% ASM segmentation

I=flip(Subject(1).Session(1).T2.left(:,:,2),2);
tic;
ISegmented = ASM_Segmentation_BOLD(I);
time = toc

