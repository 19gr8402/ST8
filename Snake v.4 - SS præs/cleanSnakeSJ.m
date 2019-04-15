%% Kass-Witken-Terzopoulos + Xu-prince test af snakes med SJ korrektion
% efter load af vores workspace med MRI billlederne, manuelt segmenteret og
% initContourAllSubjects
close all
clearvars -except Subject manSegS_s1_r2 P
%% read, show and initial contour:
antalSubjects = 31;

for n=1:antalSubjects
    % Read an image
    I = Subject(n).Session(1).T2.right(:,:,2);
    manSeg = manSegS_s1_r2{n};   % fundet med SegmenteringsAlgo
    
    % Convert the image to double data type
    I = uint8(255 * mat2gray(I));
    I = im2double(I);
    % Show the image and select some points with the mouse (at least 4)
%     figure('units','normalized','outerposition',[0 0 1 1])
%     imshow(I,[],'InitialMagnification','fit');
%     title(sprintf('Original Subject %d',n));
%     [y_init,x_init] = getpts;
%     figure
%     imshow(manSeg,[]);
%     title(sprintf('Manually Segmented Subject %d',n));
%     P{n}=[x_init(:) y_init(:)];
    %% Set parameters
    % predetermined snake options
    Options = struct;
    Options.Verbose = false; % show important images if true
    
    % Default values
    finalDelta = 0.1;                % 0.1;
    finalKappa = 5;                  % 2;
    finalAlpha = 0.2;                % 0.2;
    finalBeta = 0.4;                   % 0.2;
    finalSigma2 = 1.6;               % 20;
    finalSigma3 = 0.9;                 % 1;
    finalMu = 0;                     % 0.2;
    finalIterations = 300;
    finalGIterations = 100;
    
    % General Parameters
    % Options.nPoints = finalnPoints;
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
    
    %% Do da snek
    [O,J]=SnakeSJ(I,P{n},Options);
    diceErr(n) = dice(manSeg,J);
    % show results
    %%
    figure
    imshow(I)
    hold on
    R   = 1;  % Value in range [0, 1]
    G   = 1;
    B   = 1;
    RGB = cat(3, (J-J.*manSeg)+ (manSeg-J.*manSeg)+(J.*manSeg) * R, (J.*manSeg) * G, (J.*manSeg)* B);
    himage = imshow(RGB(:,:,:),[]);
    himage.AlphaData = 0.2;
    plot([P{n}(:,2);P{n}(1,2)],[P{n}(:,1);P{n}(1,1)]);
    plot([O(:,2);O(1,2)],[O(:,1);O(1,1)],'.g');
    legend('Initial Contour', 'Snake Contour')
    title(sprintf('Segmentated Area Superimposed on Subject %d',n))
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