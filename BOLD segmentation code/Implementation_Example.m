% Example of implementation

clear; close all; clc;

load('31testSubject1compMuscle');
load('manSegS_s1_r2_6comp');

for i=1:2
I=testSubject(i).p.I;

ISegmented = ASM_Segmentation_BOLD(I);

for k=1:size(ISegmented,2)
diceErr(i,k) = dice(manSeg(i).Subject(k).compartment,ISegmented(k).Seg);
end
%% Calculate mean dice
diceErr(i,size(ISegmented,2)+1) = mean(diceErr(i,1:size(ISegmented,2)-1)); %-1 da vi ikke vil have gastrocL med
end

%% Plot

figure('units','normalized','outerposition',[0 0 1 1]);
for k=1:size(ISegmented,2)+1
subplot(2,3,k);
x_plot = 1:(i);
y_plot = diceErr(x_plot,k);
e = std(y_plot)*ones(size(x_plot));
if k>size(ISegmented,2); e = std(diceErr(:,1:size(ISegmented,2)-1)'); end
errorbar(x_plot,y_plot,e)
title(['Compartment:',num2str(k),' Mean dice error: ',num2str(mean(diceErr(:,k)))]) %,'. With std: ',num2str(mean(e)),
if k>size(ISegmented,2); title(['Overall: Mean dice error: ',num2str(mean(diceErr(:,k)))]); end
xlim([0 i+1])
ylim([0 1])
end
