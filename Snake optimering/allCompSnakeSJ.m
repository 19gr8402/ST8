%% Kass-Witken-Terzopoulos + Xu-prince test af snakes med SJ korrektion
% efter load af vores workspace med MRI billlederne, manuelt segmenteret og
% initContourAllSubjects
close all
clearvars -except Subject manSegS_s1_r2 P1 P2 P3 P4 P5
%% read, show and initial contour:
antalSubjects = 3;
diceErr = zeros(1,antalSubjects);
diceErr2 = zeros(1,antalSubjects);
diceErr3 = zeros(1,antalSubjects);
diceErr4 = zeros(1,antalSubjects);
diceErr5 = zeros(1,antalSubjects);
%% Set parameters
% predetermined snake options
Options = struct;
Options.Verbose = false; % show important images if true

% Values from fullParameterAllSbjectsOptimize
finalDelta = 0.1;                % 0.1;
finalKappa = 5;                  % 2;
finalAlpha = 0.2;                % 0.2;
finalBeta = 0.4;                   % 0.2;
finalSigma2 = 1.4;               % 20;
finalSigma3 = 0.1;                 % 1;
finalMu = 0;                     % 0.2;
finalIterations = 300;
finalGIterations = 100;
finalnPoints = 126;             % Fundet ved optimering

% General Parameters
Options.nPoints = finalnPoints;
Options.Iterations = finalIterations;
% Options.Gamma = finalGamma;

% Snake parameters
Options.Delta = finalDelta;       % Baloon force, default 0.1
Options.Kappa = finalKappa;       % Weight of external image force, default 2
Options.Alpha = finalAlpha;       % Membrame energy  (first order), default 0.2
Options.Beta = finalBeta;         % Thin plate energy (second order), default 0.2

% Energy parameters
Options.Sigma2 = finalSigma2;     % Sigma used to calculate the gradient of the edge energy image (which gives the image force), default 20

%  and GVF parameters
Options.GIterations= finalGIterations;         % Number of GVF iterations, default 0
Options.Sigma3 = finalSigma3;     % Sigma used to calculate the laplacian in GVF, default 1.0
Options.Mu = finalMu;             % Trade of between real edge vectors, and noise vectors, default 0.2. (Warning setting this to high >0.5 gives an instable Vector Flow)

for n=1:antalSubjects
    % Read an image
    I = Subject(n).Session(1).T2.right(:,:,1);
    manSeg = manSegS_s1_r2{n};   % fundet med SegmenteringsAlgo
    
    % Convert the image to double data type
    I = uint8(255 * mat2gray(I));
    I = im2double(I);
    
    % draw initial contour
    figure
    imshow(I);
    hold on
    title(sprintf('Subject %d : Set initial contour for anterior compartment',n));
    [y1,x1] = getpts;
    P1{n}=[x1(:) y1(:)];
    hold on
    plot([P1{n}(:,2);P1{n}(1,2)],[P1{n}(:,1);P1{n}(1,1)],'b');
    % lateral
    title(sprintf('Subject %d : Set initial contour for lateral compartment',n));
    [y2,x2] = getpts;
    P2{n}=[x2(:) y2(:)];
    hold on
    plot([P2{n}(:,2);P2{n}(1,2)],[P2{n}(:,1);P2{n}(1,1)],'b');
    % deep
    title(sprintf('Subject %d : Set initial contour for deep posterior compartment',n));
    [y3,x3] = getpts;
    P3{n}=[x3(:) y3(:)];
    hold on
    plot([P3{n}(:,2);P3{n}(1,2)],[P3{n}(:,1);P3{n}(1,1)],'b');
    % soleus
    title(sprintf('Subject %d : Set initial contour for soleus',n));
    [y4,x4] = getpts;
    P4{n}=[x4(:) y4(:)];
    hold on
    plot([P4{n}(:,2);P4{n}(1,2)],[P4{n}(:,1);P4{n}(1,1)],'b');
    % gastroc
    title(sprintf('Subject %d : Set initial contour for gastrocnemius',n));
    [y5,x5] = getpts;
    P5{n}=[x5(:) y5(:)];
    hold on
    plot([P5{n}(:,2);P5{n}(1,2)],[P5{n}(:,1);P5{n}(1,1)],'b');
    title(sprintf('Subject %d Original',n));
    %% Do da snek anterior
    [O1,J1]=SnakeSJ(I,P1{n},Options);
    diceErr(n) = dice(manSeg,J1);
    
    %% Do da snek lateral
    [O2,J2]=SnakeSJ(I,P2{n},Options);
%    diceErr2(n) = dice(manSeg,J);
    
    %% Do da snek deep posterior
    [O3,J3]=SnakeSJ(I,P3{n},Options);
%    diceErr3(n) = dice(manSeg,J);
    
    %% Do da snek soleus
    [O4,J4]=SnakeSJ(I,P4{n},Options);
%    diceErr4(n) = dice(manSeg,J);
    
    %% Do da snek gastrocnemius
    [O5,J5]=SnakeSJ(I,P5{n},Options);
%    diceErr5(n) = dice(manSeg,J);
    
    %% Show results
    figure
    imshow(I)
    hold on
%     R   = 1;  % Value in range [0, 1]
%     G   = 1;
%     B   = 1;
%    RGB = cat(3, (J-J.*manSeg)+ (manSeg-J.*manSeg)+(J.*manSeg) * R, (J.*manSeg) * G, (J.*manSeg)* B);
%     RGB = cat(3, (J-J.*J_adjust)+ (J_adjust-J.*J_adjust)+(J.*J_adjust) * R, (J.*J_adjust) * G, (J.*J_adjust)* B);
%    himage = imshow(RGB(:,:,:),[]);
%    himage.AlphaData = 0.1;
    plot([O1(:,2);O1(1,2)],[O1(:,1);O1(1,1)],'.g');
    plot([O2(:,2);O2(1,2)],[O2(:,1);O2(1,1)],'.y');
    plot([O3(:,2);O3(1,2)],[O3(:,1);O3(1,1)],'.r');
    plot([O4(:,2);O4(1,2)],[O4(:,1);O4(1,1)],'.c');
    plot([O5(:,2);O5(1,2)],[O5(:,1);O5(1,1)],'.m');
    legend('Anterior', 'Lateral', 'Posterior', 'Soleus', 'Gastrocnemius')
    title(sprintf('Segmentated Areas Superimposed on Subject %d',n))
end

%% Show error
x_plot = 1:n;
y_plot = diceErr(x_plot);
e = std(y_plot)*ones(size(x_plot));

fig = figure;
errorbar(x_plot,y_plot,e)
xlim([0 n+1])
ylim([0.75 1])
title('DICE similarity coefficient for the segmented area')
ylabel('DICE')
xlabel('Subject')

gnsErr = mean(diceErr);
