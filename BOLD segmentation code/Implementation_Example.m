% Example of implementation

clearvars -except Subject; close all; clc;

%% Load data
% load('D:\Noter\Project\Sorteret_MRI_data_SubjectsOnly.mat')
% load('C:\Users\mathi\Google Drive\ST8\MATLAB\Sorteret_MRI_data_SubjectsOnly.mat')
load('manSegS_s1_r2_6comp');
tic;
showMethod = true;

%% ASM segmentation
for i=3:3
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
%% PLOT of BOLD response with reference bar.

% figure; 
% M(:,1) = 1:1:450;
% 
% % get bounds
% xmaxa = max(M(:,1));    
% xmaxb = max(M(:,1));
% xmaxc = max(M(:,1));
% 
% % axis for second axis. B bruges til ticklabels
% b=axes('Position',[.1 .1 .8 1e-12]);
% set(b,'Units','normalized');
% set(b,'Color','none');
% set(b,'fontsize',12);
% set(b,'TickLength',[0 0])
% %c aksen bruges til at vise ticks
% c=axes('Position',[.1 .1 .8 1e-12]);
% set(c,'Units','normalized');
% set(c,'Color','none');
% set(c,'fontsize',15);
% 
% % axis with plot
% a=axes('Position',[.1 .2 .8 .7]);
% set(a,'Units','normalized');
% plot(BOLDsequence(1).Seg, 'LineWidth',1.5)
% hold on 
% plot(BOLDsequence(1).filt, 'LineWidth',1.5)
% legend('Unfiltered', 'Filtered')
% 
% % set limits and labels
% set(a,'xlim',[0 xmaxa]);
% set(b,'xlim',[0 xmaxb]);
% set(c,'xlim',[0 xmaxb]);
% title('BOLD Response: Anterior compartment, Subject 3, left leg')
% xlabel(a,'Frames')
% ylabel('Normalized SI [%]');
% ylim([0.9 1.1]);
% set(gca,'fontsize', 15);
% xticks(b,[0 10 30 180 330 400 450]);
% xticks(c,[0 30 330 450]);
% xticklabels(b,{'','Baseline','30','Ischemia','330','Reactive Hyperaemia',''})
% xticklabels(c,{'','','',''})

%% PLOT of all (filtered) BOLD response curves
%t= (1:450)/60;

figure;
subplot(3,2,1)
plot(t,BOLDsequence(1).filt, 'LineWidth',1.5)
xlabel('Time [s]')
ylabel('Normalised SI [%]')
xlim([1 7.5]);
xticks([0 2 4 6 7.5]);
ylim([0.9 1.2]);
set(gca,'fontsize', 13);
title('Anterior','FontSize', 16);


subplot(3,2,2)
plot(t,BOLDsequence(2).filt, 'LineWidth',1.5)
xlabel('Time [s]')
ylabel('Normalised SI [%]')
xlim([1 7.5]);
xticks([0 2 4 6 7.5]);
ylim([0.9 1.2]);
set(gca,'fontsize', 13);
title('Lateral','FontSize', 16);


subplot(3,2,3)
plot(t,BOLDsequence(3).filt, 'LineWidth',1.5)
xlabel('Time [s]')
ylabel('Normalised SI [%]')
xlim([1 7.5]);
xticks([0 2 4 6 7.5]);
ylim([0.9 1.2]);
set(gca,'fontsize', 13);
title('Deep Posterior','FontSize', 16);


subplot(3,2,4)
plot(t,BOLDsequence(4).filt, 'LineWidth',1.5)
xlabel('Sec')
xlabel('Time [s]')
ylabel('Normalised SI [%]')
xlim([1 7.5]);
xticks([0 2 4 6 7.5]);
ylim([0.9 1.2]);
set(gca,'fontsize', 13);
title('Soleus','FontSize', 16);


subplot(3,2,5)
plot(t,BOLDsequence(5).filt, 'LineWidth',1.5)
xlabel('Time [s]')
ylabel('Normalised SI [%]')
xlim([1 7.5]);
xticks([0 2 4 6 7.5]);
ylim([0.9 1.2]);
set(gca,'fontsize', 13);
title('Medial Gastrocnemius','FontSize', 16);
