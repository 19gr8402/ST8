clearvars -except Subject; close all; clc;

%% Load 
load('diceErrAll_testTrainSubjects');

%% Boksplot

CharCompartmentTemp = ['Anterior    ';'Lateral     ';'Deep        '; 'Soleus      ';'Gastronemius'];
CharCompartment = CharCompartmentTemp;
for i=1:30
CharCompartment = [CharCompartment; CharCompartmentTemp];
end

diceData31 = diceErr(6).run(:);

%% Boxplot
boxplot(diceData31,CharCompartment)
ylim([0 1]);
title('Boxplot 31 train subjects')
xlabel('Compartment')
ylabel('Dice')


%% Calculate and add mean
for i=1:6
diceErr(i).run(6,:) = mean(diceErr(i).run);
end

%% Plot training graph

Anterior = [mean(diceErr(1).run(1,:)) mean(diceErr(2).run(1,:)) mean(diceErr(3).run(1,:)) mean(diceErr(4).run(1,:)) mean(diceErr(5).run(1,:)) mean(diceErr(6).run(1,:))];
Lateral = [mean(diceErr(1).run(2,:)) mean(diceErr(2).run(2,:)) mean(diceErr(3).run(2,:)) mean(diceErr(4).run(2,:)) mean(diceErr(5).run(2,:)) mean(diceErr(6).run(2,:))];
Deep = [mean(diceErr(1).run(3,:)) mean(diceErr(2).run(3,:)) mean(diceErr(3).run(3,:)) mean(diceErr(4).run(3,:)) mean(diceErr(5).run(3,:)) mean(diceErr(6).run(3,:))];
Soleus = [mean(diceErr(1).run(4,:)) mean(diceErr(2).run(4,:)) mean(diceErr(3).run(4,:)) mean(diceErr(4).run(4,:)) mean(diceErr(5).run(4,:)) mean(diceErr(6).run(4,:))];
Gastrocnemius = [mean(diceErr(1).run(5,:)) mean(diceErr(2).run(5,:)) mean(diceErr(3).run(5,:)) mean(diceErr(4).run(5,:)) mean(diceErr(5).run(5,:)) mean(diceErr(6).run(5,:))];
Average = [mean(diceErr(1).run(6,:)) mean(diceErr(2).run(6,:)) mean(diceErr(3).run(6,:)) mean(diceErr(4).run(6,:)) mean(diceErr(5).run(6,:)) mean(diceErr(6).run(6,:))];

figure; plot(Anterior); hold on
plot(Lateral); hold on
plot(Deep); hold on
plot(Soleus); hold on
plot(Gastrocnemius); hold on
plot(Average);
xlim([0 7]);
%% Find max

diceErr(6).run(7,:) = max(diceErr(6).run(1:5,:));

%% Find min

diceErr(6).run(8,:) = min(diceErr(6).run(1:5,:));

%% Plot mean performance
figure;
x = 1:1:31;
y = diceErr(6).run(6,:);
ypos = diceErr(6).run(7,:)-diceErr(6).run(6,:);
yneg = -(diceErr(6).run(8,:)-diceErr(6).run(6,:));
errorbar(x,y,yneg,ypos,'x','MarkerSize',10)
title('Errorbar 31 train subjects')
xlabel('Subject')
ylabel('Dice')
xticks([5 10 15 20 25 30])
ylim([0 1]);
xlim([0 32]);

%% Test for nomal distribution

% x = diceErr(6).run(1,:); %diceErr(6,:);
% [h,p,adstat,cv] = adtest(x)

%% Calculate Standard Deviation

%diceErr(6).run(:,32)= std(diceErr(6).run,0,2);

%% Represent best (23) and worst (29) case.

%load('C:\Users\Bo\Documents\Noter\Project\Sorteret_MRI_data_SubjectsOnly.mat');
%load('D:\MATLAB\2. semester kandidat\Project\Data\Sorteret_MRI_data_SubjectsOnly.mat');
%load('Segmentation31Train');

IBest = flip(Subject(23).Session(1).T2.left(:,:,2),2);
figure; imshow(IBest,[]);
title('Segmentation with higest mean dice');
%     hold on
%     R   = 1;  % Value in range [0, 1]
%     G   = 1;
%     B   = 1;
%     RGB = cat(3, manSeg * R, J * G, J * B);
%     himage = imshow(RGB(:,:,1),[]);
%     himage.AlphaData = 0.1;
    
IWorst = flip(Subject(29).Session(1).T2.left(:,:,2),2);
figure; imshow(IWorst,[]);
title('Segmentation with lowest mean dice');
    