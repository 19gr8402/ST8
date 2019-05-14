clear; close all; clc;


%% Load data
load('D:\Git\BOLD segmentation code\Data\segmentation31TrainSubjects.mat')
load('D:\Git\BOLD segmentation code\Data\manSegS_s1_r2_6comp_Ground_Truth.mat')

seD = strel('diamond',1);

for i = 1:31
    for S = 1:5
    testImage = Segmentation(i).Subject(S).Seg;
    diff=1;
    erosion(i).Subject(S).Count = 0;
        while sum(diff)>0
    
        diff = testImage - manSegGroundTruth(i).Subject(S).Seg;
        diff = diff(:);
        diff = diff(diff>0);

        testImage=imerode(testImage,seD);
        
        erosion(i).Subject(S).Count = erosion(i).Subject(S).Count + 1;
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
meanAnterior = mean(tempAnterior);
meanLateral = mean(tempLateral);
meanDeep = mean(tempDeep);
meanSoleus = mean(tempSoleus);
meanGastrocnemius = mean(tempGastrocnemius);

%% Plot til lige at visualisere hvor meget hver subjekt har spillet ind.

figure; subplot(2,3,1); plot(tempAnterior); xlim([0 32]);
subplot(2,3,2); plot(tempLateral); xlim([0 32]);
subplot(2,3,3); plot(tempDeep); xlim([0 32]);
subplot(2,3,4); plot(tempSoleus); xlim([0 32]);
subplot(2,3,5); plot(tempGastrocnemius); xlim([0 32]);
