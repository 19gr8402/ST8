%% Kass-Witken-Terzopoulos + Xu-prince test af snakes med SJ korrektion
% efter load af vores workspace med MRI billlederne, manuelt segmenteret og
% initContourAllSubjects
close all
clearvars -except Subject manSeg manSegGroundTruth P P1 P2 P3 P4 P5
%% read, show and initial contour:
set(0,'defaultAxesFontSize',15);
antalSubjects = 1;
finalgnsErr = 0;
diceErr1 = zeros(1,antalSubjects);
diceErr2 = zeros(1,antalSubjects);
diceErr3 = zeros(1,antalSubjects);
diceErr4 = zeros(1,antalSubjects);
diceErr5 = zeros(1,antalSubjects);
P1 = cell(1,antalSubjects);
P2 = cell(1,antalSubjects);
P3 = cell(1,antalSubjects);
P4 = cell(1,antalSubjects);
P5 = cell(1,antalSubjects);
J1 = cell(1,antalSubjects);
J2 = cell(1,antalSubjects);
J3 = cell(1,antalSubjects);
J4 = cell(1,antalSubjects);
J5 = cell(1,antalSubjects);
O1 = cell(1,antalSubjects);
O2 = cell(1,antalSubjects);
O3 = cell(1,antalSubjects);
O4 = cell(1,antalSubjects);
O5 = cell(1,antalSubjects);
    %% Set parameters
    % predetermined snake options
    Options = struct;
    Options.Verbose = false; % show important images if true
    
    % General Parameters
    finalIterations = 300;
    Options.Iterations = finalIterations;
    finalGIterations = 100;
    Options.GIterations= finalGIterations;         % Number of GVF iterations, default 0
    
    % Copy general Options
    Options1 = Options;
    Options2 = Options;
    Options3 = Options;
    Options4 = Options;
    Options5 = Options;
    
    %% Anterior Options
    % Snake parameters
    Options1.Delta = 0.1;       % Baloon force, default 0.1
    Options1.Kappa = 5.5;         % Weight of external image force, default 2
    Options1.Alpha = 0.2;       % Membrame energy  (first order), default 0.2
    Options1.Beta = 0.5;        % Thin plate energy (second order), default 0.2
    % Energy parameters
    Options1.Sigma2 = 0.5;      % Sigma used to calculate the gradient of the edge energy image (which gives the image force), default 20
    %  and GVF parameters
    Options1.Sigma3 = 0.1;      % Sigma used to calculate the laplacian in GVF, default 1.0
    Options1.Mu = 0;            % Trade of between real edge vectors, and noise vectors, default 0.2. (Warning setting this to high >0.5 gives an instable Vector Flow)
    
    Options1.nPoints = 115;
   
    %% Lateral Options
    % Snake parameters
    Options2.Delta = 0.1;
    Options2.Kappa = 4;
    Options2.Alpha = 0.4;
    Options2.Beta = 0.1;
    % Energy parameters
    Options2.Sigma2 = 0.5;
    %  and GVF parameters
    Options2.Sigma3 = 0.1;
    Options2.Mu = 0;
    
    Options2.nPoints = 125;
    
    %% Deep Options
    % Snake parameters
    Options3.Delta = 0.1;
    Options3.Kappa = 4;
    Options3.Alpha = 0.4;
    Options3.Beta = 0.5;
    % Energy parameters
    Options3.Sigma2 = 0.5;
    %  and GVF parameters
    Options3.Sigma3 = 0.1;
    Options3.Mu = 0;
    
    Options3.nPoints = 110;
    
    %% Soleus Options
    % Snake parameters
    Options4.Delta = 0.1;
    Options4.Kappa = 5;
    Options4.Alpha = 0.2;
    Options4.Beta = 0;
    % Energy parameters
    Options4.Sigma2 = 1.9;
    %  and GVF parameters
    Options4.Sigma3 = 0.8;
    Options4.Mu = 0.5;
    
    Options4.nPoints = 135;
    
    %% Gastrocnemius Options
    % Snake parameters
    Options5.Delta = 0.1;
    Options5.Kappa = 6;
    Options5.Alpha = 0;
    Options5.Beta = 0.1;
    % Energy parameters
    Options5.Sigma2 = 0.4;
    %  and GVF parameters
    Options5.Sigma3 = 0.1;
    Options5.Mu = 0;
    
    Options5.nPoints = 140;
 
for n=1:antalSubjects
    tic
    % Read an image
    I = fliplr(Subject(n).Session(1).T2.left(:,:,2));
    %I = Subject(n).Session(1).T2.right(:,:,2);
    % manSegI = manSeg(n).Subject;
    manSegI = manSegGroundTruth(n).Subject;
    
    
    % Convert the image to double data type
    I = uint8(255 * mat2gray(I));
    I = im2double(I);
    figure
    imshow(I)
    
    % Place anterior shape
    [x,y,offsetr]=SelectPosition(I,P{1,1}(:,1),P{1,1}(:,2),0);
    R = [cos(offsetr) -sin(offsetr); sin(offsetr) cos(offsetr)];
    P1{n} = P{1,1}*R+[x,y];
    hold on
    plot([P1{n}(:,2);P1{n}(1,2)],[P1{n}(:,1);P1{n}(1,1)],'-','Color',[0    0.4470    0.7410],'LineWidth',2);
    
    % Place lateral shape
    [x,y,offsetr]=SelectPosition(I,P{1,2}(:,1),P{1,2}(:,2),0);
    R = [cos(offsetr) -sin(offsetr); sin(offsetr) cos(offsetr)];
    P2{n} = P{1,2}*R+[x,y];
    hold on
    plot([P2{n}(:,2);P2{n}(1,2)],[P2{n}(:,1);P2{n}(1,1)],'-','Color',[0.8500    0.3250    0.0980],'LineWidth',2);
    
    % Place deep shape
    [x,y,offsetr]=SelectPosition(I,P{1,3}(:,1),P{1,3}(:,2),0);
    R = [cos(offsetr) -sin(offsetr); sin(offsetr) cos(offsetr)];
    P3{n} = P{1,3}*R+[x,y];
    hold on
    plot([P3{n}(:,2);P3{n}(1,2)],[P3{n}(:,1);P3{n}(1,1)],'-','Color',[0.9290    0.6940    0.1250],'LineWidth',2);
    
    % Place soleus shape
    [x,y,offsetr]=SelectPosition(I,P{1,4}(:,1),P{1,4}(:,2),0);
    R = [cos(offsetr) -sin(offsetr); sin(offsetr) cos(offsetr)];
    P4{n} = P{1,4}*R+[x,y];
    hold on
    plot([P4{n}(:,2);P4{n}(1,2)],[P4{n}(:,1);P4{n}(1,1)],'-','Color',[0.4660    0.6740    0.1880],'LineWidth',2);
    
    % Place Gatrocnemius shape
    [x,y,offsetr]=SelectPosition(I,P{1,5}(:,1),P{1,5}(:,2),0);
    R = [cos(offsetr) -sin(offsetr); sin(offsetr) cos(offsetr)];
    P5{n} = P{1,5}*R+[x,y];
    hold on
    plot([P5{n}(:,2);P5{n}(1,2)],[P5{n}(:,1);P5{n}(1,1)],'-','Color',[0.6350    0.0780    0.1840],'LineWidth',2);
    legend('Anterior', 'Lateral','Deep','Soleus','Gastrocnemius Medialis')
    title(sprintf('Initial contour Superimposed on Subject %d',n))
    % pause(0.5)
    
    %% Do da snek Anterior
    [O1{n},J1{n}]=SnakeSJ(I,P1{n},Options1);
    diceErr1(n) = dice(manSegI(1).Seg,J1{n});
    
    %% Do da snek Lateral
    [O2{n},J2{n}]=SnakeSJ(I,P2{n},Options2);
    diceErr2(n) = dice(manSegI(2).Seg,J2{n}); 
    
    %% Do da snek Deep
    [O3{n},J3{n}]=SnakeSJ(I,P3{n},Options3);
    diceErr3(n) = dice(manSegI(3).Seg,J3{n});
    
    %% Do da snek Soleus
    [O4{n},J4{n}]=SnakeSJ(I,P4{n},Options4);
    diceErr4(n) = dice(manSegI(4).Seg,J4{n});
    
    %% Do da snek Gastrocnemius Medialis
    [O5{n},J5{n}]=SnakeSJ(I,P5{n},Options5);
    diceErr5(n) = dice(manSegI(5).Seg,J5{n});
    
    toc
    
    %% Creating data struct
    SegmentationACM(n).Subject(1).Seg = J1{n};
    SegmentationACM(n).Subject(2).Seg = J2{n};
    SegmentationACM(n).Subject(3).Seg = J3{n};
    SegmentationACM(n).Subject(4).Seg = J4{n};
    SegmentationACM(n).Subject(5).Seg = J5{n};

%% Show results
    figure
    imageOri = imshow(I,[]);
    hold on
    color1 = cat(3, 0*manSegI(1).Seg, 0.4470*manSegI(1).Seg, 0.7410*manSegI(1).Seg);
    image1 = imshow(color1,[]);
    image1.AlphaData = manSegI(1).Seg*0.15;
    color2 = cat(3, 0.8500*manSegI(2).Seg, 0.3250*manSegI(2).Seg, 0.0980*manSegI(2).Seg);
    image2 = imshow(color2,[]);
    image2.AlphaData = manSegI(2).Seg*0.15;
    color3 = cat(3, 0.9290*manSegI(3).Seg, 0.6940*manSegI(3).Seg, 0.1250*manSegI(3).Seg);
    image3 = imshow(color3,[]);
    image3.AlphaData = manSegI(3).Seg*0.15;
    color4 = cat(3, 0.4660*manSegI(4).Seg, 0.4660*manSegI(4).Seg, 0.1880*manSegI(4).Seg);
    image4 = imshow(color4,[]);
    image4.AlphaData = manSegI(4).Seg*0.15;
    color5 = cat(3, 0.6350*manSegI(5).Seg, 0.0780*manSegI(5).Seg, 0.1840*manSegI(5).Seg);
    image5 = imshow(color5,[]);
    image5.AlphaData = manSegI(5).Seg*0.15;
    plot([O1{n}(:,2);O1{n}(1,2)],[O1{n}(:,1);O1{n}(1,1)],'-','Color',[0    0.4470    0.7410],'LineWidth',2);
    plot([O2{n}(:,2);O2{n}(1,2)],[O2{n}(:,1);O2{n}(1,1)],'-','Color',[0.8500    0.3250    0.0980],'LineWidth',2);
    plot([O3{n}(:,2);O3{n}(1,2)],[O3{n}(:,1);O3{n}(1,1)],'-','Color',[0.9290    0.6940    0.1250],'LineWidth',2);
    plot([O4{n}(:,2);O4{n}(1,2)],[O4{n}(:,1);O4{n}(1,1)],'-','Color',[0.4660    0.6740    0.1880],'LineWidth',2);
    plot([O5{n}(:,2);O5{n}(1,2)],[O5{n}(:,1);O5{n}(1,1)],'-','Color',[0.6350    0.0780    0.1840],'LineWidth',2);
    legend('Anterior', 'Lateral','Deep Posterior','Soleus','Gastrocnemius')
    title(sprintf('Segmentated Area Superimposed on Subject %d',n))
end

%% Show error
x_plot = 1:n;

y_plot1 = diceErr1(x_plot);
e1 = std(y_plot1)*ones(size(x_plot));
gnsErr1 = mean(diceErr1);

y_plot2 = diceErr2(x_plot);
e2 = std(y_plot2)*ones(size(x_plot));
gnsErr2 = mean(diceErr2);

y_plot3 = diceErr3(x_plot);
e3 = std(y_plot3)*ones(size(x_plot));
gnsErr3 = mean(diceErr3);

y_plot4 = diceErr4(x_plot);
e4 = std(y_plot4)*ones(size(x_plot));
gnsErr4 = mean(diceErr4);

y_plot5 = diceErr5(x_plot);
e5 = std(y_plot5)*ones(size(x_plot));
gnsErr5 = mean(diceErr5);

y_plotGns = mean([y_plot1; y_plot2; y_plot3; y_plot4; y_plot5],1);
eGns = std([y_plot1; y_plot2; y_plot3; y_plot4; y_plot5],0,1);

medErrGns = median(y_plotGns);
eIQRGns = iqr(y_plotGns);

%% plot DICE
fig = figure;
subplot(2,3,1)
errorbar(x_plot,y_plot1,e1)
xlim([0 n+1])
ylim([0 1])
title('DICE - Anterior')
ylabel('DICE')
xlabel('Subject')

subplot(2,3,2)
errorbar(x_plot,y_plot2,e2)
xlim([0 n+1])
ylim([0 1])
title('DICE - Lateral')
ylabel('DICE')
xlabel('Subject')

subplot(2,3,3)
errorbar(x_plot,y_plot3,e3)
xlim([0 n+1])
ylim([0 1])
title('DICE - Deep')
ylabel('DICE')
xlabel('Subject')

subplot(2,3,4)
errorbar(x_plot,y_plot4,e4)
xlim([0 n+1])
ylim([0 1])
title('DICE - Soleus')
ylabel('DICE')
xlabel('Subject')

subplot(2,3,5)
errorbar(x_plot,y_plot5,e5)
xlim([0 n+1])
ylim([0 1])
title('DICE - Gastrocnemius')
ylabel('DICE')
xlabel('Subject')

subplot(2,3,6)
errorbar(x_plot,y_plotGns,eGns)
xlim([0 n+1])
ylim([0 1])
title('DICE - Average')
ylabel('DICE')
xlabel('Subject')

%% Boksplot

CharCompartmentTemp = ['Anterior      ';'Lateral       ';'Deep posterior'; 'Soleus        ';'Gastrocnemius '];
CharCompartment = CharCompartmentTemp;
for i=1:antalSubjects-1
CharCompartment = [CharCompartment; CharCompartmentTemp];
end

diceData = [y_plot1; y_plot2; y_plot3; y_plot4; y_plot5];

%% Boxplot
figure;
boxplot(diceData,CharCompartment,'Widths',0.8)
ylim([0.4 1]);
%title('Boxplot 31 train subjects')
ylabel('Dice')
xtickangle(45)
% set(gca,'fontsize', 15);

%% Find max
maxValue = max([y_plot1; y_plot2; y_plot3; y_plot4; y_plot5]);
ypos = maxValue-y_plotGns;

%% Find min
minValue = min([y_plot1; y_plot2; y_plot3; y_plot4; y_plot5]);
yneg = -(minValue-y_plotGns);

%% Plot mean performance
figure;
errorbar(x_plot,y_plotGns,yneg,ypos,'x','MarkerSize',10)
%title('Errorbar 31 train subjects')
xlabel('Subject')
ylabel('Dice')
xticks([5 10 15 20 25 30])
ylim([0.4 1]);
xlim([0 32]);
% set(gca,'fontsize', 15);
