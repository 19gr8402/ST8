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
for i=3:5
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

echoPlanarImages = flip(Subject(i).Session(1).BOLD.left(:,:,:),2);

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

% %% ER20
% for i=1:5
%     seD = strel('diamond',20);
%     ISegmentedER20(i).Seg=imerode(ISegmented(i).Seg,seD);
% end
% 
% % Plot
% Segout = mat2gray(I);
% for k=1:5
% Outline = bwperim(ISegmentedER20(k).Seg);
% Segout(Outline) = 1;
% end
% figure; imshow(Segout,[]); title('ASM ER20');
% 
% [BOLDsequenceER20]=Image_registration_and_BOLD(I,echoPlanarImages,ISegmentedER20,showMethod);

%% Plot
figure; subplot(2,3,1); plot(BOLDsequenceGT(1).Seg,'k'); title('Anterior: BOLD');
hold on; plot(BOLDsequence(1).Seg,'g');
hold on; plot(BOLDsequenceER2(1).Seg,'b');
hold on; plot(BOLDsequenceER5(1).Seg,'y');
hold on; plot(BOLDsequenceER10(1).Seg,'r');legend('GT','ASM','ASM ER2','ASM ER5','ASM ER10');
xlim([7 450])

subplot(2,3,2); plot(BOLDsequenceGT(2).Seg,'k'); title('Lateral: BOLD');
hold on; plot(BOLDsequence(2).Seg,'g');
hold on; plot(BOLDsequenceER2(2).Seg,'b');
hold on; plot(BOLDsequenceER5(2).Seg,'y');
hold on; plot(BOLDsequenceER10(2).Seg,'r');legend('GT','ASM','ASM ER2','ASM ER5','ASM ER10');
xlim([7 450])

subplot(2,3,3); plot(BOLDsequenceGT(3).Seg,'k'); title('Deep: BOLD');
hold on; plot(BOLDsequence(3).Seg,'g');
hold on; plot(BOLDsequenceER2(3).Seg,'b');
hold on; plot(BOLDsequenceER5(3).Seg,'y');
hold on; plot(BOLDsequenceER10(3).Seg,'r');legend('GT','ASM','ASM ER2','ASM ER5','ASM ER10');
xlim([7 450])

subplot(2,3,4); plot(BOLDsequenceGT(4).Seg,'k'); title('Soleus: BOLD');
hold on; plot(BOLDsequence(4).Seg,'g');
hold on; plot(BOLDsequenceER2(4).Seg,'b');
hold on; plot(BOLDsequenceER5(4).Seg,'y');
hold on; plot(BOLDsequenceER10(4).Seg,'r');legend('GT','ASM','ASM ER2','ASM ER5','ASM ER10');
xlim([7 450])

subplot(2,3,5); plot(BOLDsequenceGT(5).Seg,'k'); title('Lateral head of Gatrocnemius: BOLD');
hold on; plot(BOLDsequence(5).Seg,'g');
hold on; plot(BOLDsequenceER2(5).Seg,'b');
hold on; plot(BOLDsequenceER5(5).Seg,'y');
hold on; plot(BOLDsequenceER10(5).Seg,'r');legend('GT','ASM','ASM ER2','ASM ER5','ASM ER10');
xlim([7 450])

%% Plot
figure; subplot(2,1,1); plot(BOLDsequenceGT(1).Seg,'k'); title('Anterior: BOLD');
hold on; plot(BOLDsequence(1).Seg,'g');
hold on; plot(BOLDsequenceER2(1).Seg,'b');
hold on; plot(BOLDsequenceER5(1).Seg,'y');
hold on; plot(BOLDsequenceER10(1).Seg,'r'); legend('GT','ASM','ASM ER2','ASM ER5','ASM ER10');
xlim([7 450])

subplot(2,1,2); plot(BOLDsequenceGT(5).Seg,'k'); title('Medial head of Gatrocnemius: BOLD');
hold on; plot(BOLDsequence(5).Seg,'g');
hold on; plot(BOLDsequenceER2(5).Seg,'b');
hold on; plot(BOLDsequenceER5(5).Seg,'y');
hold on; plot(BOLDsequenceER10(5).Seg,'r'); legend('GT','ASM','ASM ER2','ASM ER5','ASM ER10');
xlim([7 450])

time = toc;
end

