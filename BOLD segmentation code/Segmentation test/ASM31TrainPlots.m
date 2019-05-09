clearvars -except Subject; close all; clc;

%% Load 
load('diceErrAll_testTrainSubjects');

%% Boksplot

CharCompartmentTemp = ['Anterior     ';'Lateral      ';'Deep         '; 'Soleus       ';'Gastrocnemius'];
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

x = [5 10 15 20 25 31];
figure; plot(x,Anterior); hold on
plot(x,Lateral); hold on
plot(x,Deep); hold on
plot(x,Soleus); hold on
plot(x,Gastrocnemius); hold on
plot(x,Average);
legend('Anterior','Lateral','Deep','Soleus','Gastrocnemius','Average');
xlim([0 35]);
ylim([0 1]);
xticks([5 10 15 20 25 30])

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
load('segmentation31TrainSubjects');
load('manSegS_s1_r2_6comp_Ground_Truth');

chosenImage = 23;
IBest = flip(Subject(chosenImage).Session(1).T2.left(:,:,2),2);
figure; imshow(IBest,[], 'InitialMag', 'fit');
title('Segmentation with higest mean dice'); hold on

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
color2 = cat(3, 0.8500*ones(size(IBest)), 0.3250*ones(size(IBest)), 0.0980*zeros(size(IBest)));
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
legend('Anterior','Lateral','Deep','Soleus','Grastrocnemius')
axis off %hide axis
hold off

%% ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ next plot ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
chosenImage = 29;
IWorst = flip(Subject(chosenImage).Session(1).T2.left(:,:,2),2);
figure; imshow(IWorst,[]);
title('Segmentation with lowest mean dice');

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
color2 = cat(3, 0.8500*ones(size(IBest)), 0.3250*ones(size(IBest)), 0.0980*zeros(size(IBest)));
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
legend('Anterior','Lateral','Deep','Soleus','Grastrocnemius')
axis off %hide axis
hold off


%% ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ New plot ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
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
color2 = cat(3, 0.8500*ones(size(IBest)), 0.3250*ones(size(IBest)), 0.0980*zeros(size(IBest)));
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


%% ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤ next plot ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

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

    