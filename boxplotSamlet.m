%% Boksplot
close all
clearvars -except Subject diceRound y_plot1 y_plot2 y_plot3 y_plot4 y_plot5
set(0,'defaultAxesFontSize',15);
CharCompartmentTemp = ['Anterior      ';'1             ';'Lateral       ';'2             ';'Deep posterior';'3             '; 'Soleus        ';'4             ';'Gastrocnemius ';'5             '];
CharCompartment = CharCompartmentTemp;
for i=1:30
CharCompartment = [CharCompartment; CharCompartmentTemp];
end
x_plot = 1:10;
diceData = [y_plot1; diceRound(1).round(6).run(1,:); y_plot2; diceRound(1).round(6).run(2,:); y_plot3; diceRound(1).round(6).run(3,:); y_plot4; diceRound(1).round(6).run(4,:); y_plot5; diceRound(1).round(6).run(5,:)];

%% Boxplot
figure;
h = boxplot(diceData,CharCompartment,'Widths',0.8);
set(h,{'linew'},{1.5});
a = get(get(gca,'children'),'children');   % Get the handles of all the objects
t = get(a,'tag');   % List the names of all the objects 
box1 = a(21);   % The 7th object is the first box
box2 = a(23);   % The 7th object is the first box
box3 = a(25);   % The 7th object is the first box
box4 = a(27);   % The 7th object is the first box
box5 = a(29);   % The 7th object is the first box
set(box1, 'Color', 'g');   % Set the color of the first box to green
set(box2, 'Color', 'g');   % Set the color of the first box to green
set(box3, 'Color', 'g');   % Set the color of the first box to green
set(box4, 'Color', 'g');   % Set the color of the first box to green
set(box5, 'Color', 'g');   % Set the color of the first box to green
ylim([0.4 1]);
%title('Boxplot 31 train subjects')
ylabel('Dice')
xtickangle(45)
names = {'Anterior'; 'Lateral';'Deep posterior';'Soleus';'Gastrocnemius'};
set(gca,'xtick',[1.5:2:10.5],'xticklabel',names)
% set(gca,'fontsize', 15);