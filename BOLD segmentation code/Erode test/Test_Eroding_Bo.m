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
for i=3:3
    
    
I=flip(Subject(i).Session(1).T2.left(:,:,2),2);
% ISegmented = ASM_Segmentation_BOLD(I);
% % Plot
% Segout = mat2gray(I);
% for k=1:5
% Outline = bwperim(ISegmented(k).Seg);
% Segout(Outline) = 1;
% end
% figure; imshow(Segout,[]); title('ASM');

%% Our ground truth

ISegmentedGT = manSegGroundTruth(i).Subject(1:5);
Segout = mat2gray(I);
for k=1:5
Outline = bwperim(ISegmentedGT(k).Seg);
Segout(Outline) = 1;
end
figure; imshow(Segout,[]); title('GT');

%% Image registration

echoPlanarImages = flip(double(Subject(i).Session(1).BOLD.left(:,:,:)),2);

[BOLDsequenceGT]=Image_registration_and_BOLD(I,echoPlanarImages,ISegmentedGT,showMethod);



% [BOLDsequence]=Image_registration_and_BOLD(I,echoPlanarImages,ISegmented,showMethod);
% 
% %% ER2
% for i=1:5
%     seD = strel('diamond',2);
%     ISegmentedER2(i).Seg=imerode(ISegmented(i).Seg,seD);
% end
% 
% % Plot
% Segout = mat2gray(I);
% for k=1:5
% Outline = bwperim(ISegmentedER2(k).Seg);
% Segout(Outline) = 1;
% end
% figure; imshow(Segout,[]); title('ASM ER2');
% 
% [BOLDsequenceER2]=Image_registration_and_BOLD(I,echoPlanarImages,ISegmentedER2,showMethod);
% 
% %% ER4
% for i=1:5
%     seD = strel('diamond',4);
%     ISegmentedER4(i).Seg=imerode(ISegmented(i).Seg,seD);
% end
% 
% % Plot
% Segout = mat2gray(I);
% for k=1:5
% Outline = bwperim(ISegmentedER4(k).Seg);
% Segout(Outline) = 1;
% end
% figure; imshow(Segout,[]); title('ASM ER4');
% 
% [BOLDsequenceER4]=Image_registration_and_BOLD(I,echoPlanarImages,ISegmentedER4,showMethod);
% 
% %% ER6
% for i=1:5
%     seD = strel('diamond',6);
%     ISegmentedER6(i).Seg=imerode(ISegmented(i).Seg,seD);
% end
% 
% % Plot
% Segout = mat2gray(I);
% for k=1:5
% Outline = bwperim(ISegmentedER6(k).Seg);
% Segout(Outline) = 1;
% end
% figure; imshow(Segout,[]); title('ASM ER6');
% 
% [BOLDsequenceER6]=Image_registration_and_BOLD(I,echoPlanarImages,ISegmentedER6,showMethod);
% 
% %% ER8
% for i=1:5
%     seD = strel('diamond',8);
%     ISegmentedER8(i).Seg=imerode(ISegmented(i).Seg,seD);
% end
% 
% % Plot
% Segout = mat2gray(I);
% for k=1:5
% Outline = bwperim(ISegmentedER8(k).Seg);
% Segout(Outline) = 1;
% end
% figure; imshow(Segout,[]); title('ASM ER8');
% 
% [BOLDsequenceER8]=Image_registration_and_BOLD(I,echoPlanarImages,ISegmentedER8,showMethod);
% 
% %% ER10
% for i=1:5
%     seD = strel('diamond',10);
%     ISegmentedER10(i).Seg=imerode(ISegmented(i).Seg,seD);
% end
% 
% % Plot
% Segout = mat2gray(I);
% for k=1:5
% Outline = bwperim(ISegmentedER10(k).Seg);
% Segout(Outline) = 1;
% end
% figure; imshow(Segout,[]); title('ASM ER10');
% 
% [BOLDsequenceER10]=Image_registration_and_BOLD(I,echoPlanarImages,ISegmentedER10,showMethod);
% 
% %% Plot
% figure; subplot(2,3,1); plot(BOLDsequenceGT(1).Seg,'k'); title('Anterior: BOLD');
% hold on; plot(BOLDsequence(1).Seg,'g');
% hold on; plot(BOLDsequenceER2(1).Seg,'b');
% hold on; plot(BOLDsequenceER4(1).Seg,'y');
% hold on; plot(BOLDsequenceER6(1).Seg,'c');
% hold on; plot(BOLDsequenceER8(1).Seg,'m');
% hold on; plot(BOLDsequenceER10(1).Seg,'r'); legend('GT','ASM','ASM ER2','ASM ER4','ASM ER6','ASM ER8','ASM ER10');
% 
% subplot(2,3,2); plot(BOLDsequenceGT(2).Seg,'k'); title('Lateral: BOLD');
% hold on; plot(BOLDsequence(2).Seg,'g');
% hold on; plot(BOLDsequenceER2(2).Seg,'b');
% hold on; plot(BOLDsequenceER4(2).Seg,'y');
% hold on; plot(BOLDsequenceER6(2).Seg,'c');
% hold on; plot(BOLDsequenceER8(2).Seg,'m');
% hold on; plot(BOLDsequenceER10(2).Seg,'r'); legend('GT','ASM','ASM ER2','ASM ER4','ASM ER6','ASM ER8','ASM ER10');
% 
% subplot(2,3,3); plot(BOLDsequenceGT(3).Seg,'k'); title('Deep: BOLD');
% hold on; plot(BOLDsequence(3).Seg,'g');
% hold on; plot(BOLDsequenceER2(3).Seg,'b');
% hold on; plot(BOLDsequenceER4(3).Seg,'y');
% hold on; plot(BOLDsequenceER6(3).Seg,'c');
% hold on; plot(BOLDsequenceER8(3).Seg,'m');
% hold on; plot(BOLDsequenceER10(3).Seg,'r'); legend('GT','ASM','ASM ER2','ASM ER4','ASM ER6','ASM ER8','ASM ER10');
% 
% subplot(2,3,4); plot(BOLDsequenceGT(4).Seg,'k'); title('Soleus: BOLD');
% hold on; plot(BOLDsequence(4).Seg,'g');
% hold on; plot(BOLDsequenceER2(4).Seg,'b');
% hold on; plot(BOLDsequenceER4(4).Seg,'y');
% hold on; plot(BOLDsequenceER6(4).Seg,'c');
% hold on; plot(BOLDsequenceER8(4).Seg,'m');
% hold on; plot(BOLDsequenceER10(4).Seg,'r'); legend('GT','ASM','ASM ER2','ASM ER4','ASM ER6','ASM ER8','ASM ER10');
% 
% subplot(2,3,5); plot(BOLDsequenceGT(5).Seg,'k'); title('Lateral head of Gatrocnemius: BOLD');
% hold on; plot(BOLDsequence(5).Seg,'g');
% hold on; plot(BOLDsequenceER2(5).Seg,'b');
% hold on; plot(BOLDsequenceER4(5).Seg,'y');
% hold on; plot(BOLDsequenceER6(5).Seg,'c');
% hold on; plot(BOLDsequenceER8(5).Seg,'m');
% hold on; plot(BOLDsequenceER10(5).Seg,'r'); legend('GT','ASM','ASM ER2','ASM ER4','ASM ER6','ASM ER8','ASM ER10');

time = toc;
end

