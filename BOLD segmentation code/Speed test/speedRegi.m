%% Speed test for registretion and bold curve
clearvars -except Subject; close all; clc;
load('manSegS_s1_r2_6comp_Ground_Truth');
i=1;
I=flip(Subject(i).Session(1).T2.left(:,:,2),2);
segGroundTruth = manSegGroundTruth(i).Subject;
echoPlanarImages = flip(Subject(i).Session(1).BOLD.left(:,:,:),2);
tic
[BOLDsequenceGT(i).Subject]=Image_registration_and_BOLD(I,echoPlanarImages,segGroundTruth,0);
toc