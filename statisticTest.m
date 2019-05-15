% Scipt for the statistic test between ACM and ASM.

close all
clearvars -except Subject y_plotGns diceRound
set(0,'defaultAxesFontSize',15);

x = y_plotGns;
for round=1:5
for i=1:6
%diceErr(i).run(6,:) = mean(diceErr(i).run);
diceRound(round).round(i).run(6,:) = mean(diceRound(round).round(i).run);
end
end
y = diceRound(1).round(6).run(6,:);

xNorm=normalitytest(x)
yNorm=normalitytest(y)
%% Boxplot data setup

CharCompartmentTemp = ['ACM';'ASM'];
CharCompartment = CharCompartmentTemp;
for i=1:30
CharCompartment = [CharCompartment; CharCompartmentTemp];
end

diceData = [x; y];

%% Boxplot
figure;
boxplot(diceData,CharCompartment,'Widths',0.8)
ylim([0.4 1]);
%title('Boxplot 31 train subjects')
ylabel('Dice')
% set(gca,'fontsize', 15);

%% Statistic test
[p,h,stats] = signrank(x,y)