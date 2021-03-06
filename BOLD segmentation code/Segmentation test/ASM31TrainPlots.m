clearvars -except Subject; close all; clc;

%% Load 
load('diceErrAll_testTrainSubjects_All_rounds');
font = 24;
set(0,'defaultAxesFontSize',font);

%% Boksplot

CharCompartmentTemp = ['Anterior      ';'Lateral       ';'Deep posterior'; 'Soleus        ';'Gastrocnemius '];
CharCompartment = CharCompartmentTemp;
for i=1:30
CharCompartment = [CharCompartment; CharCompartmentTemp];
end

diceData31 = diceRound(1).round(6).run(:);

%% Boxplot
h = boxplot(diceData31,CharCompartment,'Widths',0.8);
set(h,'LineWidth',1.5)
ylim([0.4 1]);
%title('Boxplot 31 train subjects')
ylabel('DSC')
%set(gca,'fontsize', 14);
xtickangle(45);

% % % ACM
% load('diceDataACM');
% h = boxplot(diceData31,CharCompartment,'Widths',0.8);
% set(h,'LineWidth',1.5)
% ylim([0.4 1]);
% %title('Boxplot 31 train subjects')
% ylabel('DSC')
% %set(gca,'fontsize', 14);
% xtickangle(45);

%% Calculate and add mean
for round=1:5
for i=1:6
%diceErr(i).run(6,:) = mean(diceErr(i).run);
diceRound(round).round(i).run(6,:) = mean(diceRound(round).round(i).run);
end
end

%% Plot training graph

Anterior = []; Lateral = []; Deep = []; Soleus = []; Gastrocnemius = []; Average = [];
for run = 1:6
for round = 1:5 
   temp1(round,:) = mean(diceRound(round).round(run).run(1,:));
   temp2(round,:) = mean(diceRound(round).round(run).run(2,:));
   temp3(round,:) = mean(diceRound(round).round(run).run(3,:));
   temp4(round,:) = mean(diceRound(round).round(run).run(4,:));
   temp5(round,:) = mean(diceRound(round).round(run).run(5,:));
   temp6(round,:) = mean(diceRound(round).round(run).run(6,:));
end
Anterior = [Anterior mean(temp1)];
Lateral = [Lateral mean(temp2)];
Deep = [Deep mean(temp3)];
Soleus = [Soleus mean(temp4)];
Gastrocnemius = [Gastrocnemius mean(temp5)];
Average = [Average mean(temp6)];
end

x = [5 10 15 20 25 31];
figure; plot(x,Anterior); hold on
plot(x,Lateral); hold on
plot(x,Deep); hold on
plot(x,Soleus); hold on
plot(x,Gastrocnemius); hold on
plot(x,Average);
%set(gca,'fontsize', 12);
legend('Anterior','Lateral','Deep posterior','Soleus','Gastrocnemius','Average','Location','southeast');
xlabel('Number of training images');
ylabel('Average DSC');
xlim([0 35]);
ylim([0 1]);
xticks([5 10 15 20 25 30])

%% Find max

for i=1:6
diceRound(1).round(6).run(7,:) = max(diceRound(1).round(6).run(1:5,:));
end

%% Find min

for i=1:6
diceRound(1).round(6).run(8,:) = min(diceRound(1).round(6).run(1:5,:));
end

%% Plot mean performance
figure;
x = 1:1:31;
y = diceRound(1).round(6).run(6,:);
ypos = diceRound(1).round(6).run(7,:)-diceRound(1).round(6).run(6,:);
yneg = -(diceRound(1).round(6).run(8,:)-diceRound(1).round(6).run(6,:));
h = errorbar(x,y,yneg,ypos,'x','MarkerSize',10);
set(h,'LineWidth',1.5)
%title('Errorbar 31 train subjects')
xlabel('Subject')
ylabel('DSC')
xticks([5 10 15 20 25 30])
ylim([0.4 1]);
xlim([0 32]);
%set(gca,'fontsize', 14);

%% Test for nomal distribution

% x = diceErr(6).run(1,:); %diceErr(6,:);
% [h,p,adstat,cv] = adtest(x)

%% Calculate Standard Deviation

%diceErr(6).run(:,32)= std(diceErr(6).run,0,2);

%% Represent best (6) and worst (15) case.
%load('D:\Noter\Project\Sorteret_MRI_data_SubjectsOnly.mat')
%load('C:\Users\Bo\Documents\Noter\Project\Sorteret_MRI_data_SubjectsOnly.mat');
load('segmentation31TrainSubjects');
load('manSegS_s1_r2_6comp_Ground_Truth');

%for i = 1:31
chosenImage = 6;
IBest = flip(Subject(chosenImage).Session(1).T2.left(:,:,2),2);
figure; imshow(IBest,[], 'InitialMag', 'fit');
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

% Anterior
se = strel('disk', 1);
ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(1).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(1).Seg*0.15);
color1 = cat(3, zeros(size(IBest)), 0.4470*ones(size(IBest)), 0.7410*ones(size(IBest)));
hold on
a = imshow(color1);
b = imshow(color1);
hold off
set(a, 'AlphaData', manSeg)
set(b, 'AlphaData', ASMSeg)

% Lateral
ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(2).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(2).Seg*0.15);
color2 = cat(3, 0.8500*ones(size(IBest)), 0.3250*ones(size(IBest)), 0.0980*ones(size(IBest)));
hold on
c = imshow(color2);
d = imshow(color2);
hold off
set(c, 'AlphaData', manSeg)
set(d, 'AlphaData', ASMSeg)

% Deep
ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(3).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(3).Seg*0.15);
color3 = cat(3, 0.9290*ones(size(IBest)), 0.6940*ones(size(IBest)), 0.1250*ones(size(IBest)));
hold on
e = imshow(color3);
j = imshow(color3);
hold off
set(e, 'AlphaData', manSeg)
set(j, 'AlphaData', ASMSeg)

% Soleus
ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(4).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(4).Seg*0.15);
color4 = cat(3, 0.4660*ones(size(IBest)), 0.6740*ones(size(IBest)), 0.1880*ones(size(IBest)));
hold on
i = imshow(color4);
j = imshow(color4);
hold off
set(i, 'AlphaData', manSeg)
set(j, 'AlphaData', ASMSeg)

% Gastroc
ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(5).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(5).Seg*0.15);
color5 = cat(3, 0.6350*ones(size(IBest)), 0.0780*ones(size(IBest)), 0.1840*ones(size(IBest)));
hold on
i = imshow(color5);
j = imshow(color5);
hold off
set(i, 'AlphaData', manSeg)
set(j, 'AlphaData', ASMSeg)
x0 = get(gca,'xlim') ;
y0 = get(gca,'ylim') ;
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0    0.4470    0.7410])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.8500    0.3250    0.0980])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.9290    0.6940    0.1250])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.4660    0.6740    0.1880])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.6350    0.0780    0.1840])
axis([x0 y0])
% add the legend 
legend('Anterior','Lateral','Deep posterior','Soleus','Grastrocnemius')
axis off %hide axis
hold off

%end
%% いいいいいいいいいいいいいい� next plot いいいいいいいいいいいいいいい�
chosenImage = 15;
IWorst = flip(Subject(chosenImage).Session(1).T2.left(:,:,2),2);
figure; imshow(IWorst,[], 'InitialMag', 'fit');
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];


% Anterior
se = strel('disk', 1);
ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(1).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(1).Seg*0.15);
color1 = cat(3, zeros(size(IBest)), 0.4470*ones(size(IBest)), 0.7410*ones(size(IBest)));
hold on
a = imshow(color1);
b = imshow(color1);
hold off
set(a, 'AlphaData', manSeg)
set(b, 'AlphaData', ASMSeg)

% Lateral
ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(2).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(2).Seg*0.15);
color2 = cat(3, 0.8500*ones(size(IBest)), 0.3250*ones(size(IBest)), 0.0980*ones(size(IBest)));
hold on
c = imshow(color2);
d = imshow(color2);
hold off
set(c, 'AlphaData', manSeg)
set(d, 'AlphaData', ASMSeg)

% Deep
ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(3).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(3).Seg*0.15);
color3 = cat(3, 0.9290*ones(size(IBest)), 0.6940*ones(size(IBest)), 0.1250*ones(size(IBest)));
hold on
e = imshow(color3);
j = imshow(color3);
hold off
set(e, 'AlphaData', manSeg)
set(j, 'AlphaData', ASMSeg)

% Soleus
ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(4).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(4).Seg*0.15);
color4 = cat(3, 0.4660*ones(size(IBest)), 0.6740*ones(size(IBest)), 0.1880*ones(size(IBest)));
hold on
i = imshow(color4);
j = imshow(color4);
hold off
set(i, 'AlphaData', manSeg)
set(j, 'AlphaData', ASMSeg)

% Gastroc
ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(5).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(5).Seg*0.15);
color5 = cat(3, 0.6350*ones(size(IBest)), 0.0780*ones(size(IBest)), 0.1840*ones(size(IBest)));
hold on
i = imshow(color5);
j = imshow(color5);
hold off
set(i, 'AlphaData', manSeg)
set(j, 'AlphaData', ASMSeg)
x0 = get(gca,'xlim') ;
y0 = get(gca,'ylim') ;
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0    0.4470    0.7410])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.8500    0.3250    0.0980])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.9290    0.6940    0.1250])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.4660    0.6740    0.1880])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.6350    0.0780    0.1840])
axis([x0 y0])
% add the legend 
legend('Anterior','Lateral','Deep posterior','Soleus','Grastrocnemius')
axis off %hide axis
hold off

%% いいいいいいいいいいいいいい� ACM いいいいいいいいいいいいいいいいいいい

load('SegmentationACM');

chosenImage = 6;
IBest = flip(Subject(chosenImage).Session(1).T2.left(:,:,2),2);
figure; imshow(IBest,[], 'InitialMag', 'fit');
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

% Anterior
se = strel('disk', 1);
ACMSeg = imdilate(bwperim(SegmentationACM(chosenImage).Subject(1).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(1).Seg*0.15);
color1 = cat(3, zeros(size(IBest)), 0.4470*ones(size(IBest)), 0.7410*ones(size(IBest)));
hold on
a = imshow(color1);
b = imshow(color1);
hold off
set(a, 'AlphaData', manSeg)
set(b, 'AlphaData', ACMSeg)

% Lateral
ACMSeg = imdilate(bwperim(SegmentationACM(chosenImage).Subject(2).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(2).Seg*0.15);
color2 = cat(3, 0.8500*ones(size(IBest)), 0.3250*ones(size(IBest)), 0.0980*ones(size(IBest)));
hold on
c = imshow(color2);
d = imshow(color2);
hold off
set(c, 'AlphaData', manSeg)
set(d, 'AlphaData', ACMSeg)

% Deep
ACMSeg = imdilate(bwperim(SegmentationACM(chosenImage).Subject(3).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(3).Seg*0.15);
color3 = cat(3, 0.9290*ones(size(IBest)), 0.6940*ones(size(IBest)), 0.1250*ones(size(IBest)));
hold on
e = imshow(color3);
j = imshow(color3);
hold off
set(e, 'AlphaData', manSeg)
set(j, 'AlphaData', ACMSeg)

% Soleus
ACMSeg = imdilate(bwperim(SegmentationACM(chosenImage).Subject(4).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(4).Seg*0.15);
color4 = cat(3, 0.4660*ones(size(IBest)), 0.6740*ones(size(IBest)), 0.1880*ones(size(IBest)));
hold on
i = imshow(color4);
j = imshow(color4);
hold off
set(i, 'AlphaData', manSeg)
set(j, 'AlphaData', ACMSeg)

% Gastroc
ACMSeg = imdilate(bwperim(SegmentationACM(chosenImage).Subject(5).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(5).Seg*0.15);
color5 = cat(3, 0.6350*ones(size(IBest)), 0.0780*ones(size(IBest)), 0.1840*ones(size(IBest)));
hold on
i = imshow(color5);
j = imshow(color5);
hold off
set(i, 'AlphaData', manSeg)
set(j, 'AlphaData', ACMSeg)
x0 = get(gca,'xlim') ;
y0 = get(gca,'ylim') ;
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0    0.4470    0.7410])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.8500    0.3250    0.0980])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.9290    0.6940    0.1250])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.4660    0.6740    0.1880])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.6350    0.0780    0.1840])
axis([x0 y0])
% add the legend 
legend('Anterior','Lateral','Deep posterior','Soleus','Grastrocnemius')
axis off %hide axis
hold off

%% いいいいいいいいいいいいいい New plot いいいいいいいいいいいいいいいい�

chosenImage = 15;
IBest = flip(Subject(chosenImage).Session(1).T2.left(:,:,2),2);
figure; imshow(IBest,[], 'InitialMag', 'fit');
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

% Anterior
se = strel('disk', 1);
ACMSeg = imdilate(bwperim(SegmentationACM(chosenImage).Subject(1).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(1).Seg*0.15);
color1 = cat(3, zeros(size(IBest)), 0.4470*ones(size(IBest)), 0.7410*ones(size(IBest)));
hold on
a = imshow(color1);
b = imshow(color1);
hold off
set(a, 'AlphaData', manSeg)
set(b, 'AlphaData', ACMSeg)

% Lateral
ACMSeg = imdilate(bwperim(SegmentationACM(chosenImage).Subject(2).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(2).Seg*0.15);
color2 = cat(3, 0.8500*ones(size(IBest)), 0.3250*ones(size(IBest)), 0.0980*ones(size(IBest)));
hold on
c = imshow(color2);
d = imshow(color2);
hold off
set(c, 'AlphaData', manSeg)
set(d, 'AlphaData', ACMSeg)

% Deep
ACMSeg = imdilate(bwperim(SegmentationACM(chosenImage).Subject(3).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(3).Seg*0.15);
color3 = cat(3, 0.9290*ones(size(IBest)), 0.6940*ones(size(IBest)), 0.1250*ones(size(IBest)));
hold on
e = imshow(color3);
j = imshow(color3);
hold off
set(e, 'AlphaData', manSeg)
set(j, 'AlphaData', ACMSeg)

% Soleus
ACMSeg = imdilate(bwperim(SegmentationACM(chosenImage).Subject(4).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(4).Seg*0.15);
color4 = cat(3, 0.4660*ones(size(IBest)), 0.6740*ones(size(IBest)), 0.1880*ones(size(IBest)));
hold on
i = imshow(color4);
j = imshow(color4);
hold off
set(i, 'AlphaData', manSeg)
set(j, 'AlphaData', ACMSeg)

% Gastroc
ACMSeg = imdilate(bwperim(SegmentationACM(chosenImage).Subject(5).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(5).Seg*0.15);
color5 = cat(3, 0.6350*ones(size(IBest)), 0.0780*ones(size(IBest)), 0.1840*ones(size(IBest)));
hold on
i = imshow(color5);
j = imshow(color5);
hold off
set(i, 'AlphaData', manSeg)
set(j, 'AlphaData', ACMSeg)
x0 = get(gca,'xlim') ;
y0 = get(gca,'ylim') ;
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0    0.4470    0.7410])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.8500    0.3250    0.0980])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.9290    0.6940    0.1250])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.4660    0.6740    0.1880])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.6350    0.0780    0.1840])
axis([x0 y0])
% add the legend 
legend('Anterior','Lateral','Deep posterior','Soleus','Grastrocnemius')
axis off %hide axis
hold off

%% いいいいいいいいいいいい� New plot いいいいいいいいいいいいいいいいいい�
load('BOLD_reg_Subject_23');

chosenImage = 23;
IBOLD = bold_reg(:,:,5);
figure; imshow(IBOLD,[]);

% Anterior
se = strel('disk', 1);
ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(1).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(1).Seg*0.15);
color1 = cat(3, zeros(size(IBOLD)), 0.4470*ones(size(IBOLD)), 0.7410*ones(size(IBOLD)));
hold on
a = imshow(color1);
b = imshow(color1);
hold off
set(a, 'AlphaData', manSeg)
set(b, 'AlphaData', ASMSeg)

% Lateral
ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(2).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(2).Seg*0.15);
color2 = cat(3, 0.8500*ones(size(IBest)), 0.3250*ones(size(IBest)), 0.0980*ones(size(IBest)));
hold on
c = imshow(color2);
d = imshow(color2);
hold off
set(c, 'AlphaData', manSeg)
set(d, 'AlphaData', ASMSeg)

% Deep
ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(3).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(3).Seg*0.15);
color3 = cat(3, 0.9290*ones(size(IBest)), 0.6940*ones(size(IBest)), 0.1250*ones(size(IBest)));
hold on
e = imshow(color3);
j = imshow(color3);
hold off
set(e, 'AlphaData', manSeg)
set(j, 'AlphaData', ASMSeg)

% Soleus
ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(4).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(4).Seg*0.15);
color4 = cat(3, 0.4660*ones(size(IBest)), 0.6740*ones(size(IBest)), 0.1880*ones(size(IBest)));
hold on
i = imshow(color4);
j = imshow(color4);
hold off
set(i, 'AlphaData', manSeg)
set(j, 'AlphaData', ASMSeg)

% Gastroc
ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(5).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(5).Seg*0.15);
color5 = cat(3, 0.6350*ones(size(IBest)), 0.0780*ones(size(IBest)), 0.1840*ones(size(IBest)));
hold on
i = imshow(color5);
j = imshow(color5);
hold off
set(i, 'AlphaData', manSeg)
set(j, 'AlphaData', ASMSeg)
x0 = get(gca,'xlim') ;
y0 = get(gca,'ylim') ;


%% いいいいいいいいいいいいいい� next plot いいいいいいいいいいいいいいい�

img = imread('BOLDsegmentedForStack.jpg');
I = repmat(im2double(img),[1 1 5]);
%cmap = img.map;

figure; %imshow(im2double(img));
%alpha(0.6)
%# coordinates
[X,Y] = meshgrid(1:size(I,2), 1:size(I,1));
Z = ones(size(I,1),size(I,2));

%# plot each slice as a texture-mapped surface (stacked along the Z-dimension)
for k=1:4
    surface('XData',X-0.5, 'YData',Y-0.5, 'ZData',Z.*k, ...
        'CData',I(:,:,1+((k-1)*3):3+((k-1)*3)), 'CDataMapping','direct', ...
        'EdgeColor','none', 'FaceColor','texturemap','FaceAlpha',.6)
end
k=5;
surface('XData',X-0.5, 'YData',Y-0.5, 'ZData',Z.*k, ...
        'CData',I(:,:,1+((k-1)*3):3+((k-1)*3)), 'CDataMapping','direct', ...
        'EdgeColor','none', 'FaceColor','texturemap')
    
%colormap(cmap)
view([126.4043 46.0527]),  axis tight square
set(gca, 'YDir','reverse', 'ZLim',[0 size(I,3)+1])
zlim([0 8]);
xticks([])
yticks([])
names = {'450'; '449'; '...'; '2'; '1'};
set(gca,'ztick',[1:5],'zticklabel',names)
%zticks([450 449 '...' 2 1])
zlabel('Frames')

%% いいいいいいいいいいい� BOLD plot いいいいいいいいいいいいいいいいい�

load('BOLDsequence_GT_ACM_ASM');
figure; %plot(BOLDplot,'b');
% experimental data
M(:,1) = 1:1:450;
M(:,3) = BOLDsequenceGT(3).Subject(1).filt; %manSegGroundTruth

% get bounds
xmaxa = max(M(:,1));    
xmaxb = max(M(:,1));
xmaxc = max(M(:,1));

% axis for second axis. B bruges til ticklabels
b=axes('Position',[.1 .07 .8 1e-12]);
set(b,'Units','normalized');
set(b,'Color','none');
set(b,'fontsize',font);
set(b,'TickLength',[0 0])
%c aksen bruges til at vise ticks
c=axes('Position',[.1 .07 .8 1e-12]);
set(c,'Units','normalized');
set(c,'Color','none');
set(c,'fontsize',font);

% axis with plot
a=axes('Position',[.1 .2 .8 .7]);
set(a,'Units','normalized');
plot(BOLDsequenceGT(3).Subject(1).filt,'Linewidth',2);

% set limits and labels
set(a,'xlim',[0 xmaxa]);
set(b,'xlim',[0 xmaxb]);
set(c,'xlim',[0 xmaxb]);
xlabel(a,'Frames')
ylabel('Normalized SI [%]');
ylim([0.9 1.1]);
set(gca,'fontsize', font);
xticks(b,[0 10 30 180 330 400 450]);
xticks(c,[0 30 330 450]);
xticklabels(b,{'','Baseline       ','30','Ischemia','330','Reactive Hyperaemia',''})
xticklabels(c,{'','','',''})


%% いいいいいいいいいいいいいい New plot いいいいいいいいいいいいいいいいい
chosenImage = 3;
IBest = flip(Subject(chosenImage).Session(1).T2.left(:,:,2),2);
figure; imshow(IBest,[], 'InitialMag', 'fit');
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

% Anterior
se = strel('disk', 1);
%ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(1).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(1).Seg*0.25);
color1 = cat(3, zeros(size(IBest)), 0.4470*ones(size(IBest)), 0.7410*ones(size(IBest)));
hold on
a = imshow(color1);
%b = imshow(color1);
hold off
set(a, 'AlphaData', manSeg)
%set(b, 'AlphaData', ASMSeg)

% Lateral
%ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(2).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(2).Seg*0.25);
color2 = cat(3, 0.8500*ones(size(IBest)), 0.3250*ones(size(IBest)), 0.0980*ones(size(IBest)));
hold on
c = imshow(color2);
%d = imshow(color2);
hold off
set(c, 'AlphaData', manSeg)
%set(d, 'AlphaData', ASMSeg)

% Deep
%ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(3).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(3).Seg*0.25);
color3 = cat(3, 0.9290*ones(size(IBest)), 0.6940*ones(size(IBest)), 0.1250*ones(size(IBest)));
hold on
e = imshow(color3);
%j = imshow(color3);
hold off
set(e, 'AlphaData', manSeg)
%set(j, 'AlphaData', ASMSeg)

% Soleus
%ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(4).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(4).Seg*0.25);
color4 = cat(3, 0.4660*ones(size(IBest)), 0.6740*ones(size(IBest)), 0.1880*ones(size(IBest)));
hold on
i = imshow(color4);
%j = imshow(color4);
hold off
set(i, 'AlphaData', manSeg)
%set(j, 'AlphaData', ASMSeg)

% Gastroc
%ASMSeg = imdilate(bwperim(Segmentation(chosenImage).Subject(5).Seg), se);
manSeg = (manSegGroundTruth(chosenImage).Subject(5).Seg*0.25);
color5 = cat(3, 0.6350*ones(size(IBest)), 0.0780*ones(size(IBest)), 0.1840*ones(size(IBest)));
hold on
i = imshow(color5);
%j = imshow(color5);
hold off
set(i, 'AlphaData', manSeg)
%set(j, 'AlphaData', ASMSeg)
x0 = get(gca,'xlim') ;
y0 = get(gca,'ylim') ;
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0    0.4470    0.7410])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.8500    0.3250    0.0980])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.9290    0.6940    0.1250])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.4660    0.6740    0.1880])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.6350    0.0780    0.1840])
axis([x0 y0])
% add the legend 
legend('Anterior','Lateral','Deep posterior','Soleus','Grastrocnemius')
axis off %hide axis
hold off