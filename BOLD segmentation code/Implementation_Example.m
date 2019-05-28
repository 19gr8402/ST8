% Example of implementation

clearvars -except Subject; close all; clc;
set(0,'defaultAxesFontSize',16);

%% Load data
% load('D:\Noter\Project\Sorteret_MRI_data_SubjectsOnly.mat')
% load('C:\Users\mathi\Google Drive\ST8\MATLAB\Sorteret_MRI_data_SubjectsOnly.mat')
%load('manSegS_s1_r2_6comp');
load('SegmentationACM');
load('segmentation31TrainSubjects');
load('manSegS_s1_r2_6comp_Ground_Truth');
showMethod = true;

%% ASM segmentation
% for i=1:31
% I=flip(Subject(i).Session(1).T2.left(:,:,2),2);
% 
% % ISegmented = ASM_Segmentation_BOLD(I);
% % 
% % % Plot
% % Segout = mat2gray(I);
% % for k=1:5
% % Outline = bwperim(ISegmented(k).Seg);
% % Segout(Outline) = 1;
% % end
% % figure; imshow(Segout,[]);
% 
% %% Fiks segmenteringer
% 
% segGroundTruth = manSegGroundTruth(i).Subject;
% segACM = SegmentationACM(i).Subject;
% segASM = Segmentation(i).Subject;
% 
% %% Image registration
% 
% echoPlanarImages = flip(Subject(i).Session(1).BOLD.left(:,:,:),2);
% 
% [BOLDsequenceGT(i).Subject]=Image_registration_and_BOLD(I,echoPlanarImages,segGroundTruth,showMethod);
% [BOLDsequenceACM(i).Subject]=Image_registration_and_BOLD(I,echoPlanarImages,segACM,showMethod);
% [BOLDsequenceASM(i).Subject]=Image_registration_and_BOLD(I,echoPlanarImages,segASM,showMethod);
% 
% %Filtrering m. lavpas, cutoff= 0.05
% [BOLDsequenceGT(i).Subject]= BOLD_filter(BOLDsequenceGT(i).Subject, 0); %[BOLDsequence]=BOLD_filter(BOLDsequence,showPlots)
% [BOLDsequenceACM(i).Subject]= BOLD_filter(BOLDsequenceACM(i).Subject, 0);
% [BOLDsequenceASM(i).Subject]= BOLD_filter(BOLDsequenceASM(i).Subject, 0);
% 
% 
% % figure; subplot(2,3,1); plot(BOLDsequence(1).Seg); title('Anterior: BOLD');
% % subplot(2,3,2); plot(BOLDsequence(2).Seg); title('Lateral: BOLD');
% % subplot(2,3,3); plot(BOLDsequence(3).Seg); title('Deep: BOLD');
% % subplot(2,3,4); plot(BOLDsequence(4).Seg); title('Soleus: BOLD');
% % subplot(2,3,5); plot(BOLDsequence(5).Seg); title('Lateral head of Gatrocnemius: BOLD');
% end

load('BOLDsequence_GT_ACM_ASM');

%% Calculate dice
for k=1:5
    countACM = 1;
    countASM = 1;
    for i=1:31
    diceErrACM = dice(SegmentationACM(i).Subject(k).Seg,manSegGroundTruth(i).Subject(k).Seg);
    diceErrASM = dice(Segmentation(i).Subject(k).Seg,manSegGroundTruth(i).Subject(k).Seg);
    
    SignalGT(k).compartment(i,:) = BOLDsequenceGT(i).Subject(k).filt;
    
    if diceErrACM > 0.2 %0.75
    SignalACM(k).compartment(countACM,:) = BOLDsequenceACM(i).Subject(k).filt;
    countACM = countACM + 1;
    end
    if diceErrASM > 0.2 %0.75
    SignalASM(k).compartment(countASM,:) = BOLDsequenceASM(i).Subject(k).filt;
    countASM = countASM + 1;
    end
    end
end

%% Calculate mean signals

    meanAnteriorGT=mean(SignalGT(1).compartment);
    meanLateralGT=mean(SignalGT(2).compartment);
    meanDeepGT=mean(SignalGT(3).compartment);
    meanSoleusGT=mean(SignalGT(4).compartment);
    meanGastrocGT=mean(SignalGT(5).compartment);

    meanAnteriorACM=mean(SignalACM(1).compartment);
    meanLateralACM=mean(SignalACM(2).compartment);
    meanDeepACM=mean(SignalACM(3).compartment);
    meanSoleusACM=mean(SignalACM(4).compartment);
    meanGastrocACM=mean(SignalACM(5).compartment);
    
    meanAnteriorASM=mean(SignalASM(1).compartment);
    meanLateralASM=mean(SignalASM(2).compartment);
    meanDeepASM=mean(SignalASM(3).compartment);
    meanSoleusASM=mean(SignalASM(4).compartment);
    meanGastrocASM=mean(SignalASM(5).compartment);


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
t= (1:450)/60;

% figure;
% subplot(3,2,1)
% plot(t,BOLDsequence(1).filt, 'LineWidth',1.5)
% xlabel('Time [s]')
% ylabel('Normalised SI [%]')
% xlim([1 7.5]);
% xticks([0 2 4 6 7.5]);
% ylim([0.9 1.2]);
% set(gca,'fontsize', 13);
% title('Anterior','FontSize', 16);
% 
% 
% subplot(3,2,2)
% plot(t,BOLDsequence(2).filt, 'LineWidth',1.5)
% xlabel('Time [s]')
% ylabel('Normalised SI [%]')
% xlim([1 7.5]);
% xticks([0 2 4 6 7.5]);
% ylim([0.9 1.2]);
% set(gca,'fontsize', 13);
% title('Lateral','FontSize', 16);
% 
% 
% subplot(3,2,3)
% plot(t,BOLDsequence(3).filt, 'LineWidth',1.5)
% xlabel('Time [s]')
% ylabel('Normalised SI [%]')
% xlim([1 7.5]);
% xticks([0 2 4 6 7.5]);
% ylim([0.9 1.2]);
% set(gca,'fontsize', 13);
% title('Deep Posterior','FontSize', 16);
% 
% 
% subplot(3,2,4)
% plot(t,BOLDsequence(4).filt, 'LineWidth',1.5)
% xlabel('Sec')
% xlabel('Time [s]')
% ylabel('Normalised SI [%]')
% xlim([1 7.5]);
% xticks([0 2 4 6 7.5]);
% ylim([0.9 1.2]);
% set(gca,'fontsize', 13);
% title('Soleus','FontSize', 16);
% 
% 
% subplot(3,2,5)
% plot(t,BOLDsequence(5).filt, 'LineWidth',1.5)
% xlabel('Time [s]')
% ylabel('Normalised SI [%]')
% xlim([1 7.5]);
% xticks([0 2 4 6 7.5]);
% ylim([0.9 1.2]);
% set(gca,'fontsize', 13);
% title('Medial Gastrocnemius','FontSize', 16);

%% Plot with GT, ACM and ASM.
LineWidth = 1;
figure;
subplot(2,3,1)
plot(t,meanAnteriorGT, 'LineWidth',LineWidth); hold on
plot(t,meanAnteriorACM, 'LineWidth',LineWidth); hold on
plot(t,meanAnteriorASM,'LineWidth',LineWidth);
a=line([0.5 0.5], [0 2],'Color','k', 'LineStyle', '--');
b=line([5.5 5.5], [0 2],'Color','k', 'LineStyle', '--');
a.Color(4) = 0.25;
b.Color(4) = 0.25;
ylabel('Normalised SI [%]')
legend('Mean BOLD validation','Mean BOLD ACM','Mean BOLD ASM','location','northwest');
xlim([0.2 7.5]);
xticks([0 2 4 6 7.5]);
ylim([0.9 1.1]);
title('Anterior','FontSize', 16);


subplot(2,3,2)
plot(t,meanLateralGT, 'LineWidth',LineWidth); hold on
plot(t,meanLateralACM, 'LineWidth',LineWidth); hold on
plot(t,meanLateralASM, 'LineWidth',LineWidth);
c=line([0.5 0.5], [0 2],'Color','k', 'LineStyle', '--');
d=line([5.5 5.5], [0 2],'Color','k', 'LineStyle', '--');
c.Color(4) = 0.25;
d.Color(4) = 0.25;
%legend('Mean BOLD Ground Truth','Mean BOLD ACM','Mean BOLD ASM','location','northwest');
xlim([0.2 7.5]);
xticks([0 2 4 6 7.5]);
ylim([0.9 1.1]);
title('Lateral','FontSize', 16);


subplot(2,3,3)
plot(t,meanDeepGT, 'LineWidth',LineWidth); hold on
plot(t,meanDeepACM, 'LineWidth',LineWidth); hold on
plot(t,meanDeepASM, 'LineWidth',LineWidth);
e=line([0.5 0.5], [0 2],'Color','k', 'LineStyle', '--');
f=line([5.5 5.5], [0 2],'Color','k', 'LineStyle', '--');
e.Color(4) = 0.25;
f.Color(4) = 0.25;
xlabel('Time [min]')
%legend('Mean BOLD Ground Truth','Mean BOLD ACM','Mean BOLD ASM','location','northwest');
xlim([0.2 7.5]);
xticks([0 2 4 6 7.5]);
ylim([0.9 1.1]);
title('Deep posterior','FontSize', 16);


subplot(2,3,4)
plot(t,meanSoleusGT, 'LineWidth',LineWidth); hold on
plot(t,meanSoleusACM, 'LineWidth',LineWidth); hold on
plot(t,meanSoleusASM, 'LineWidth',LineWidth);
g=line([0.5 0.5], [0 2],'Color','k', 'LineStyle', '--');
h=line([5.5 5.5], [0 2],'Color','k', 'LineStyle', '--');
g.Color(4) = 0.25;
h.Color(4) = 0.25;
xlabel('Sec')
xlabel('Time [min]')
ylabel('Normalised SI [%]')
%legend('Mean BOLD Ground Truth','Mean BOLD ACM','Mean BOLD ASM','location','northwest');
xlim([0.2 7.5]);
xticks([0 2 4 6 7.5]);
ylim([0.9 1.1]);
title('Soleus','FontSize', 16);


subplot(2,3,5)
plot(t,meanGastrocGT, 'LineWidth',LineWidth); hold on
plot(t,meanGastrocACM, 'LineWidth',LineWidth); hold on
plot(t,meanGastrocASM, 'LineWidth',LineWidth);
i=line([0.5 0.5], [0 2],'Color','k', 'LineStyle', '--');
j=line([5.5 5.5], [0 2],'Color','k', 'LineStyle', '--');
i.Color(4) = 0.25;
j.Color(4) = 0.25;
xlabel('Time [min]')
%legend('Mean BOLD Ground Truth','Mean BOLD ACM','Mean BOLD ASM','location','northwest');
xlim([0.2 7.5]);
xticks([0 2 4 6 7.5]);
ylim([0.9 1.1]);
title('Gastrocnemius','FontSize', 16);

