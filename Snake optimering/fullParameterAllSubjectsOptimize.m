%% Kass-Witken-Terzopoulos + Xu-prince test af snakes med SJ korrektion
% efter load af vores workspace med MRI billlederne, manuelt segmenteret og
% initContourAllSubjects
close all
clearvars -except Subject manSegS_s1_r2 P
%% read, show and initial contour:
antalSubjects = 31;
finalgnsErr = 0;
% predetermined snake options
Options = struct;
Options.Verbose = false; % show important images if true

finalIterations = 300;
finalGIterations = 100;
finalnPoints = 126;
Options.nPoints = finalnPoints;
Options.Iterations = finalIterations;
Options.GIterations= finalGIterations;         % Number of GVF iterations, default 0

finalDelta = 0.1;                % 0.1;
Options.Delta = finalDelta;       % Baloon force, default 0.1

% intial optimazation parameters (from optimazation on subject 9)

initSigma2 = 1.6;               % 20;
initSigma3 = 0.9;               % 1;
initMu = 0;                     % 0.2;
initKappa = 5;                  % 2;
initAlpha = 0.2;                % 0.2;
initBeta = 0.4;                 % 0.2;

Options.Sigma2 = initSigma2;     % Sigma used to calculate the gradient of the edge energy image (which gives the image force), default 20
Options.Sigma3 = initSigma3;     % Sigma used to calculate the laplacian in GVF, default 1.0
Options.Mu = initMu;
Options.Kappa = initKappa;       % Weight of external image force, default 2
Options.Alpha = initAlpha;       % Membrame energy  (first order), default 0.2
Options.Beta = initBeta;         % Thin plate energy (second order), default 0.2

% 1. opt
minSigma2 = 0.1;
maxSigma2 = 2;
incSigma2 = 0.1;

% 2. opt
minMu = -2;
maxMu = 2;
incMu = 1;
minSigma3 = 0.1;
maxSigma3 = 1;
incSigma3 = 0.05;

% 3. opt
minAlpha = 0;
maxAlpha = 1;
incAlpha = 0.1;
minBeta = 0;
maxBeta = 0.5;
incBeta = 0.05;
minKappa = 4;
maxKappa = 6;
incKappa = 0.5;

%% Opt1
initErr = 0;
diceErr = zeros(1,antalSubjects);

for mySigma2 = minSigma2:incSigma2:maxSigma2
    Options.Sigma2 = mySigma2;
    for n=1:antalSubjects
        I = Subject(n).Session(1).T2.right(:,:,2);
        manSeg = manSegS_s1_r2{n};
        I = uint8(255 * mat2gray(I));
        I = im2double(I);
        % do snek
        [O,J]=SnakeSJ(I,P{n},Options);
        diceErr(n) = dice(manSeg,J);
    end
    tempErr = mean(diceErr);
    
    if tempErr > initErr
        finalSigma2 = mySigma2;
        initErr = tempErr;
    end
    percCompleted = round((100/(maxSigma2/incSigma2-minSigma2/incSigma2))*(mySigma2/incSigma2-minSigma2/incSigma2));
    fprintf('Part 1 loading: %i%% \n', percCompleted)
end

% set final Energy parameters
Options.Sigma2 = finalSigma2;     % Sigma used to calculate the gradient of the edge energy image (which gives the image force), default 20
fprintf('Part 1 Done!\n\n')

%% Opt2
initErr = 0;
diceErr = zeros(1,antalSubjects);

for myMu = minMu:incMu:maxMu
    for mySigma3 = minSigma3:incSigma3:maxSigma3
        Options.Sigma3 = mySigma3;
        Options.Mu = myMu;
        for n=1:antalSubjects
            I = Subject(n).Session(1).T2.right(:,:,2);
            manSeg = manSegS_s1_r2{n};
            I = uint8(255 * mat2gray(I));
            I = im2double(I);
            % do snek
            [O,J]=SnakeSJ(I,P{n},Options);
            diceErr(n) = dice(manSeg,J);
        end
        tempErr = mean(diceErr);
        
        if tempErr > initErr
            finalMu = myMu;
            finalSigma3 = mySigma3;
            initErr = tempErr;
        end
    end
    percCompleted = round((100/(maxMu/incMu-minMu/incMu))*(myMu/incMu-minMu/incMu));
    fprintf('Part 2 loading: %i%% \n', percCompleted) 
end

%  set final GVF parameters
Options.Sigma3 = finalSigma3;     % Sigma used to calculate the laplacian in GVF, default 1.0
Options.Mu = finalMu;             % Trade of between real edge vectors, and noise vectors, default 0.2. (Warning setting this to high >0.5 gives an instable Vector Flow)
fprintf('Part 2 Done!\n\n')
%% Opt3
initErr = 0;
diceErr = zeros(1,antalSubjects);

for myKappa = minKappa:incKappa:maxKappa     % Weight of external image force, default 2
    for myAlpha = minAlpha:incAlpha:maxAlpha
        for myBeta = minBeta:incBeta:maxBeta
            Options.Kappa = myKappa;      % noget med intensiteten af billedet eller grænserne
            Options.Alpha = myAlpha;      % Membrame energy  (first order), default 0.2
            Options.Beta = myBeta;        % Thin plate energy (second order), default 0.2
            for n=1:antalSubjects
                I = Subject(n).Session(1).T2.right(:,:,2);
                manSeg = manSegS_s1_r2{n};
                I = uint8(255 * mat2gray(I));
                I = im2double(I);
                % do snek
                [O,J]=SnakeSJ(I,P{n},Options);
                diceErr(n) = dice(manSeg,J);
            end
            tempErr = mean(diceErr);
            
            if tempErr > initErr
                finalKappa = myKappa;
                finalAlpha = myAlpha;
                finalBeta = myBeta;
                initErr = tempErr;
            end
        end
    end
    percCompleted = round((100/(maxKappa/incKappa-minKappa/incKappa))*(myKappa/incKappa-minKappa/incKappa));
    fprintf('Part 3 loading: %i%% \n', percCompleted)
end


% set final Snake parameters
Options.Kappa = finalKappa;       % Weight of external image force, default 2
Options.Alpha = finalAlpha;       % Membrame energy  (first order), default 0.2
Options.Beta = finalBeta;         % Thin plate energy (second order), default 0.2
fprintf('Part 3 Done!\n\n')

%% Do da final snek
diceErr = zeros(1,antalSubjects);
for n=1:antalSubjects
    % Read an image
    I = Subject(n).Session(1).T2.right(:,:,2);
    manSeg = manSegS_s1_r2{n};   % fundet med SegmenteringsAlgo
    
    % Convert the image to double data type
    I = uint8(255 * mat2gray(I));
    I = im2double(I);
    [O,J]=SnakeSJ(I,P{n},Options);
    diceErr(n) = dice(manSeg,J);
    
    % Show results
    figure
    imshow(I)
    hold on
    R   = 1;  % Value in range [0, 1]
    G   = 1;
    B   = 1;
    RGB = cat(3, (J-J.*manSeg)+ (manSeg-J.*manSeg)+(J.*manSeg) * R, (J.*manSeg) * G, (J.*manSeg)* B);
    himage = imshow(RGB(:,:,:),[]);
    himage.AlphaData = 0.1;
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
