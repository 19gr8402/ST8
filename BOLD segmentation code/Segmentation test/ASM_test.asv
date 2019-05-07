clearvars -except Subject; clc; close all;

%% Load data
%load('D:\Noter\Project\Sorteret_MRI_data_SubjectsOnly.mat')
% load('C:\Users\mathi\Google Drive\ST8\MATLAB\Sorteret_MRI_data_SubjectsOnly.mat')
load('manSegS_s1_r2_6comp_Ground_Truth');

%% Test the ASM model %%

testCompartments = 5;
for i=23:23 % Number of subject test images
I=flip(Subject(i).Session(1).T2.left(:,:,2),2);
number = num2str(i);

ISegmented = ASM_Segmentation_BOLD(I);

% Plot ASM segmentation
Segout = mat2gray(I);
for k=1:5
Outline = bwperim(ISegmented(k).Seg);
Segout(Outline) = 1;
end
figure; imshow(Segout,[]); title(['ASM: Subject ', number,]);

%Plot ground truth segmentation
ISegmentedGT = manSegGroundTruth(i).Subject(1:5);
Segout = mat2gray(I);
for k=1:5
Outline = bwperim(ISegmentedGT(k).Seg);
Segout(Outline) = 1;
end
figure; imshow(Segout,[]); title(['GT: Subject ', number,]);

%% Calculate dice
for k=1:testCompartments
diceErr(i,k) = dice(manSegGroundTruth(i).Subject(k).Seg,ISegmented(k).Seg);
end
%% Calculate mean dice
diceErr(i,testCompartments+1) = mean(diceErr(i,1:testCompartments-1)); %-1 da vi ikke vil have gastrocL med

end


%% Plot

figure('units','normalized','outerposition',[0 0 1 1]);
for k=1:testCompartments+1
subplot(2,3,k);
x_plot = 1:(i);
y_plot = diceErr(x_plot,k);
e = std(y_plot)*ones(size(x_plot));
if k>testCompartments; e = std(diceErr(:,1:testCompartments-1)'); end
errorbar(x_plot,y_plot,e)
title(['Compartment:',num2str(k),' Mean dice error: ',num2str(mean(diceErr(:,k)))]) %,'. With std: ',num2str(mean(e)),
if k>testCompartments; title(['Overall: Mean dice error: ',num2str(mean(diceErr(:,k)))]); end
xlim([0 i+1])
ylim([0.4 1])
end

figure('units','normalized','outerposition',[0 0 1 1]);
title(['Overall: Mean dice error: ',num2str(mean(diceErr(:,6)))]);
x_plot = 1:(31);
y_plot = diceErr(x_plot,6);
e = std(diceErr(:,1:testCompartments-1)');
errorbar(x_plot,y_plot,e,'LineStyle','none','Marker','x')
legend('Subject mean with standard deviation')
xlim([0 31+1])
ylim([0.4 1])