clearvars -except Subject; close all; clc;
font = 26;
set(0,'defaultAxesFontSize',font);

%% Load data
load('D:\Git\BOLD segmentation code\Data\segmentation31TrainSubjects.mat')
load('D:\Git\BOLD segmentation code\Data\manSegS_s1_r2_6comp_Ground_Truth.mat')
%load('D:\Noter\Project\Sorteret_MRI_data_SubjectsOnly.mat')

for i = 1:31
    for S = 1:5
    diff=1;
    mask = 1;
        while sum(diff)>0
        seD = strel('diamond',mask);
        diff = imerode(Segmentation(i).Subject(S).Seg,seD) - manSegGroundTruth(i).Subject(S).Seg;
        diff = diff(:);
        diff = diff(diff>0);
        
        erosion(i).Subject(S).Count = mask;
        mask = mask+1;
        if mask > 100
            break
        end
        end
    end
end


%% Find mean for each compartment

for i=1:31
tempAnterior(i,:) = erosion(i).Subject(1).Count;
tempLateral(i,:) = erosion(i).Subject(2).Count;
tempDeep(i,:) = erosion(i).Subject(3).Count;
tempSoleus(i,:) = erosion(i).Subject(4).Count;
tempGastrocnemius(i,:) = erosion(i).Subject(5).Count;
end
medianAnterior = median(tempAnterior);
medianLateral = median(tempLateral);
medianDeep = median(tempDeep);
medianSoleus = median(tempSoleus);
medianGastrocnemius = median(tempGastrocnemius);

maxAnterior = max(tempAnterior);
maxLateral = max(tempLateral);
maxDeep = max(tempDeep);
maxSoleus = max(tempSoleus);
maxGastrocnemius = max(tempGastrocnemius);

%% Plot til lige at visualisere hvor meget hver subjekt har spillet ind.

figure; subplot(2,3,1); plot(tempAnterior); xlim([0 32]);
subplot(2,3,2); plot(tempLateral); xlim([0 32]);
subplot(2,3,3); plot(tempDeep); xlim([0 32]);
subplot(2,3,4); plot(tempSoleus); xlim([0 32]);
subplot(2,3,5); plot(tempGastrocnemius); xlim([0 32]);

%% Plot effect

chosenSubject = 3;
totalSegmented = Segmentation(chosenSubject).Subject(1).Seg+Segmentation(chosenSubject).Subject(2).Seg+Segmentation(chosenSubject).Subject(3).Seg+Segmentation(chosenSubject).Subject(4).Seg+Segmentation(chosenSubject).Subject(5).Seg;
figure; title('No erosion');
imshow(totalSegmented);

seD = strel('diamond',medianAnterior);
medianSegmented(1).Seg = imerode(Segmentation(chosenSubject).Subject(1).Seg,seD);
seD = strel('diamond',medianLateral);
medianSegmented(2).Seg = imerode(Segmentation(chosenSubject).Subject(2).Seg,seD);
seD = strel('diamond',medianDeep);
medianSegmented(3).Seg = imerode(Segmentation(chosenSubject).Subject(3).Seg,seD);
seD = strel('diamond',medianSoleus);
medianSegmented(4).Seg = imerode(Segmentation(chosenSubject).Subject(4).Seg,seD);
seD = strel('diamond',medianGastrocnemius);
medianSegmented(5).Seg = imerode(Segmentation(chosenSubject).Subject(5).Seg,seD);

totalMdianSegmented = medianSegmented(1).Seg+medianSegmented(2).Seg+medianSegmented(3).Seg+medianSegmented(4).Seg+medianSegmented(5).Seg;
figure; title('Median erosion');
imshow(totalMdianSegmented);

seD = strel('diamond',maxAnterior);
maxSegmented(1).Seg = imerode(Segmentation(chosenSubject).Subject(1).Seg,seD);
seD = strel('diamond',maxLateral);
maxSegmented(2).Seg = imerode(Segmentation(chosenSubject).Subject(2).Seg,seD);
seD = strel('diamond',maxDeep);
maxSegmented(3).Seg = imerode(Segmentation(chosenSubject).Subject(3).Seg,seD);
seD = strel('diamond',maxSoleus);
maxSegmented(4).Seg = imerode(Segmentation(chosenSubject).Subject(4).Seg,seD);
seD = strel('diamond',maxGastrocnemius);
maxSegmented(5).Seg= imerode(Segmentation(chosenSubject).Subject(5).Seg,seD);

totalMaxSegmented = maxSegmented(1).Seg+maxSegmented(2).Seg+maxSegmented(3).Seg+maxSegmented(4).Seg+maxSegmented(5).Seg;
figure; title('Max erosion');
imshow(totalMaxSegmented);

%% Plot image with erosions
Image = flip(Subject(chosenSubject).Session(1).T2.left(:,:,2),2);
figure; imshow(Image,[], 'InitialMag', 'fit');
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

% No
se = strel('disk', 1);
ASMSeg = imdilate(bwperim(totalSegmented), se);
color1 = cat(3, zeros(size(Image)), 0.4470*ones(size(Image)), 0.7410*ones(size(Image)));
hold on
a = imshow(color1);
hold off
set(a, 'AlphaData', ASMSeg)

% median
se = strel('disk', 1);
ASMSeg = imdilate(bwperim(totalMdianSegmented), se);
color1 = cat(3, 0.8500*ones(size(Image)), 0.3250*ones(size(Image)), 0.0980*ones(size(Image)));
hold on
a = imshow(color1);
hold off
set(a, 'AlphaData', ASMSeg)

% max
se = strel('disk', 1);
ASMSeg = imdilate(bwperim(totalMaxSegmented), se);
color1 = cat(3, 0.4660*ones(size(Image)), 0.6740*ones(size(Image)), 0.1880*ones(size(Image)));
hold on
a = imshow(color1);
hold off
set(a, 'AlphaData', ASMSeg)

x0 = get(gca,'xlim') ;
y0 = get(gca,'ylim') ;
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0    0.4470    0.7410])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.8500    0.3250    0.0980])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.4660    0.6740    0.1880])
axis([x0 y0])
% add the legend 
legend('ASM segment: No erosion','ASM segment: Median erosion','ASM segment: Max erosion')
axis off %hide axis
hold off

%% Plot BOLD response

echoPlanarImages = flip(Subject(chosenSubject).Session(1).BOLD.left(:,:,:),2);

[BOLDsequenceGT]=Image_registration_and_BOLD(flip(Subject(chosenSubject).Session(1).T2.left(:,:,2),2),echoPlanarImages,manSegGroundTruth(chosenSubject).Subject,false);
[medianBOLDsequence]=Image_registration_and_BOLD(flip(Subject(chosenSubject).Session(1).T2.left(:,:,2),2),echoPlanarImages,medianSegmented,false);
[maxBOLDsequence]=Image_registration_and_BOLD(flip(Subject(chosenSubject).Session(1).T2.left(:,:,2),2),echoPlanarImages,maxSegmented,false);

figure;
% experimental data
M(:,1) = 1:1:450;

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
plot(BOLDsequenceGT(4).Seg,'LineWidth',1.5); hold on; plot(medianBOLDsequence(4).Seg,'LineWidth',1.5); hold on; plot(maxBOLDsequence(4).Seg,'color',[0.4660 0.6740 0.1880],'LineWidth',1.5);

% set limits and labels
set(a,'xlim',[0 xmaxa]);
set(b,'xlim',[0 xmaxb]);
set(c,'xlim',[0 xmaxb]);
xlabel(a,'Frames')
ylabel('Normalized SI [%]');
ylim([0.9 1.14]);
set(gca,'fontsize', font);
xticks(b,[0 10 30 180 330 400 450]);
xticks(c,[0 30 330 450]);
xticklabels(b,{'','Baseline       ','30','Ischemia','330','Reactive Hyperaemia',''})
xticklabels(c,{'','','',''})
legend('ASM segment: No erosion','ASM segment: Median erosion','ASM segment: Max erosion','Location','northwest')

%% いいいいいいいいいいいいいいいい ACM いいいいいいいいいいいいいいいいい�

%% Load data
load('D:\Git\BOLD segmentation code\Data\SegmentationACM.mat')
load('D:\Git\BOLD segmentation code\Data\manSegS_s1_r2_6comp_Ground_Truth.mat')
%load('D:\Noter\Project\Sorteret_MRI_data_SubjectsOnly.mat')
Segmentation = SegmentationACM;

for i = 1:31
    for S = 1:5
    diff=1;
    mask = 1;
        while sum(diff)>0
        seD = strel('diamond',mask);
        diff = imerode(Segmentation(i).Subject(S).Seg,seD) - manSegGroundTruth(i).Subject(S).Seg;
        diff = diff(:);
        diff = diff(diff>0);
        
        erosion(i).Subject(S).Count = mask;
        mask = mask+1;
        if mask > 100
            break
        end
        end
    end
end


%% Find mean for each compartment

for i=1:31
tempAnterior(i,:) = erosion(i).Subject(1).Count;
tempLateral(i,:) = erosion(i).Subject(2).Count;
tempDeep(i,:) = erosion(i).Subject(3).Count;
tempSoleus(i,:) = erosion(i).Subject(4).Count;
tempGastrocnemius(i,:) = erosion(i).Subject(5).Count;
end
medianAnterior = median(tempAnterior);
medianLateral = median(tempLateral);
medianDeep = median(tempDeep);
medianSoleus = median(tempSoleus);
medianGastrocnemius = median(tempGastrocnemius);

maxAnterior = max(tempAnterior);
maxLateral = max(tempLateral);
maxDeep = max(tempDeep);
maxSoleus = max(tempSoleus);
maxGastrocnemius = max(tempGastrocnemius);

%% Plot til lige at visualisere hvor meget hver subjekt har spillet ind.

figure; subplot(2,3,1); plot(tempAnterior); xlim([0 32]);
subplot(2,3,2); plot(tempLateral); xlim([0 32]);
subplot(2,3,3); plot(tempDeep); xlim([0 32]);
subplot(2,3,4); plot(tempSoleus); xlim([0 32]);
subplot(2,3,5); plot(tempGastrocnemius); xlim([0 32]);

%% Plot effect

chosenSubject = 3;
totalSegmented = Segmentation(chosenSubject).Subject(1).Seg+Segmentation(chosenSubject).Subject(2).Seg+Segmentation(chosenSubject).Subject(3).Seg+Segmentation(chosenSubject).Subject(4).Seg+Segmentation(chosenSubject).Subject(5).Seg;
figure; title('No erosion');
imshow(totalSegmented);

seD = strel('diamond',medianAnterior);
medianSegmented(1).Seg = imerode(Segmentation(chosenSubject).Subject(1).Seg,seD);
seD = strel('diamond',medianLateral);
medianSegmented(2).Seg = imerode(Segmentation(chosenSubject).Subject(2).Seg,seD);
seD = strel('diamond',medianDeep);
medianSegmented(3).Seg = imerode(Segmentation(chosenSubject).Subject(3).Seg,seD);
seD = strel('diamond',medianSoleus);
medianSegmented(4).Seg = imerode(Segmentation(chosenSubject).Subject(4).Seg,seD);
seD = strel('diamond',medianGastrocnemius);
medianSegmented(5).Seg = imerode(Segmentation(chosenSubject).Subject(5).Seg,seD);

totalMdianSegmented = medianSegmented(1).Seg+medianSegmented(2).Seg+medianSegmented(3).Seg+medianSegmented(4).Seg+medianSegmented(5).Seg;
figure; title('Median erosion');
imshow(totalMdianSegmented);

seD = strel('diamond',maxAnterior);
maxSegmented(1).Seg = imerode(Segmentation(chosenSubject).Subject(1).Seg,seD);
seD = strel('diamond',maxLateral);
maxSegmented(2).Seg = imerode(Segmentation(chosenSubject).Subject(2).Seg,seD);
seD = strel('diamond',maxDeep);
maxSegmented(3).Seg = imerode(Segmentation(chosenSubject).Subject(3).Seg,seD);
seD = strel('diamond',maxSoleus);
maxSegmented(4).Seg = imerode(Segmentation(chosenSubject).Subject(4).Seg,seD);
seD = strel('diamond',maxGastrocnemius);
maxSegmented(5).Seg= imerode(Segmentation(chosenSubject).Subject(5).Seg,seD);

totalMaxSegmented = maxSegmented(1).Seg+maxSegmented(2).Seg+maxSegmented(3).Seg+maxSegmented(4).Seg+maxSegmented(5).Seg;
figure; title('Max erosion');
imshow(totalMaxSegmented);

%% Plot image with erosions
Image = flip(Subject(chosenSubject).Session(1).T2.left(:,:,2),2);
figure; imshow(Image,[], 'InitialMag', 'fit');
ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset; 
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

% No
se = strel('disk', 1);
ASMSeg1 = imdilate(bwperim(Segmentation(chosenSubject).Subject(1).Seg), se);
ASMSeg2 = imdilate(bwperim(Segmentation(chosenSubject).Subject(2).Seg), se);
ASMSeg3 = imdilate(bwperim(Segmentation(chosenSubject).Subject(3).Seg), se);
ASMSeg4 = imdilate(bwperim(Segmentation(chosenSubject).Subject(4).Seg), se);
ASMSeg5 = imdilate(bwperim(Segmentation(chosenSubject).Subject(5).Seg), se);
color1 = cat(3, zeros(size(Image)), 0.4470*ones(size(Image)), 0.7410*ones(size(Image)));
hold on
a = imshow(color1);
b = imshow(color1);
c = imshow(color1);
d = imshow(color1);
e = imshow(color1);
hold off
set(a, 'AlphaData', ASMSeg1)
set(b, 'AlphaData', ASMSeg2)
set(c, 'AlphaData', ASMSeg3)
set(d, 'AlphaData', ASMSeg4)
set(e, 'AlphaData', ASMSeg5)

% median
se = strel('disk', 1);
ASMSeg = imdilate(bwperim(totalMdianSegmented), se);
color1 = cat(3, 0.8500*ones(size(Image)), 0.3250*ones(size(Image)), 0.0980*ones(size(Image)));
hold on
a = imshow(color1);
hold off
set(a, 'AlphaData', ASMSeg)

% max
se = strel('disk', 1);
ASMSeg = imdilate(bwperim(totalMaxSegmented), se);
color1 = cat(3, 0.4660*ones(size(Image)), 0.6740*ones(size(Image)), 0.1880*ones(size(Image)));
hold on
a = imshow(color1);
hold off
set(a, 'AlphaData', ASMSeg)

x0 = get(gca,'xlim') ;
y0 = get(gca,'ylim') ;
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0    0.4470    0.7410])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.8500    0.3250    0.0980])
hold on
scatter(0,0,200,'s','MarkerEdgeColor','k','MarkerFaceColor',[0.4660    0.6740    0.1880])
axis([x0 y0])
% add the legend 
legend('ACM segment: No erosion','ACM segment: Median erosion','ACM segment: Max erosion')
axis off %hide axis
hold off

%% Plot BOLD response

echoPlanarImages = flip(Subject(chosenSubject).Session(1).BOLD.left(:,:,:),2);

[BOLDsequenceGT]=Image_registration_and_BOLD(flip(Subject(chosenSubject).Session(1).T2.left(:,:,2),2),echoPlanarImages,manSegGroundTruth(chosenSubject).Subject,false);
[medianBOLDsequence]=Image_registration_and_BOLD(flip(Subject(chosenSubject).Session(1).T2.left(:,:,2),2),echoPlanarImages,medianSegmented,false);
[maxBOLDsequence]=Image_registration_and_BOLD(flip(Subject(chosenSubject).Session(1).T2.left(:,:,2),2),echoPlanarImages,maxSegmented,false);

figure;
% experimental data
M(:,1) = 1:1:450;

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
plot(BOLDsequenceGT(4).Seg,'LineWidth',1.5); hold on; plot(medianBOLDsequence(4).Seg,'LineWidth',1.5); hold on; plot(maxBOLDsequence(4).Seg,'color',[0.4660 0.6740 0.1880],'LineWidth',1.5);

% set limits and labels
set(a,'xlim',[0 xmaxa]);
set(b,'xlim',[0 xmaxb]);
set(c,'xlim',[0 xmaxb]);
xlabel(a,'Frames')
ylabel('Normalized SI [%]');
ylim([0.85 1.2]);
set(gca,'fontsize', font);
xticks(b,[0 10 30 180 330 400 450]);
xticks(c,[0 30 330 450]);
xticklabels(b,{'','Baseline       ','30','Ischemia','330','Reactive Hyperaemia',''})
xticklabels(c,{'','','',''})
legend('ACM segment: No erosion','ACM segment: Median erosion','ACM segment: Max erosion','Location','northwest')
