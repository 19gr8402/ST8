%% Kass-Witken-Terzopoulos + Xu-prince test af snakes
% efter load af vores workspace med MRI billlederne
close all
clearvars -except Subject manSegS9_1_r2 testimage
%% read, show and initial contour:

% Read an image
  I = Subject(9).Session(1).T2.right(:,:,2);
  manSeg = manSegS9_1_r2;   % fundet med drawassisted() og createMask(myROI)
  
% Med Ryans segmenterede billeder
%   subject = 9;    
%   I = Subject(subject).Session(1).T2.right(:,:,2);
%   manSeg = manSegS_s1_r2{subject, 1};   

% test image
%   I = testimage;
%   manSeg = imbinarize(testimage);
% Convert the image to double data type 
  I = uint8(255 * mat2gray(I));
  I = im2double(I);
% Show the image and select some points with the mouse (at least 4)
  figure 
  imshow(I,[]);
  title('original');
  [y,x] = getpts;
  figure 
  imshow(manSeg,[]);
  title('Manuelt segmenteret');
  % star contour: (rember to comment [y,x] = getpts if used)
%   y=[115.0000 128.0000 144.0000 93.0000 101.0000 167.0000 186.0000 207.0000 235.0000 297.0000 269.0000 210.0000 156.0000];
%   x=[333.5000 279.5000 228.5000 184.5000 153.5000 150.5000 102.5000 42.5000 152.5000 174.5000 224.5000 272.5000 303.5000];
%% Make an array with the clicked coordinates
  P=[x(:) y(:)];
%% Set parameters
  % predetermined snake options
  Options = struct;
  Options.Verbose = true; % show important images if true
  Options.Iterations = 300;        % Number of iterations, default 100
  
  % parameters
  % load('finalEnergyGVF_testImage')    % load if any
  % Default values
  finalDelta = 0.1;                % 0.1;
  finalKappa = 1;                  % 2;
  finalAlpha = 0.4;                % 0.2;
  finalBeta = 0;                   % 0.2;
  finalSigma1 = 60;                % 10;
  finalSigma2 = 100;               % 20;
  finalSigma3 = 9;                 % 1;
  finalMu = 1;                     % 0.2;
  finalWline = 0;                  % 0.04;
  finalWedge = 1;                  % 0.01;
  finalWterm = 0.05;               % 10;
  
  % Snake parameters  
  Options.Delta = finalDelta;       % Baloon force, default 0.1
  Options.Kappa = finalKappa;       % Weight of external image force, default 2
  Options.Alpha = finalAlpha;       % Membrame energy  (first order), default 0.2
  Options.Beta = finalBeta;         % Thin plate energy (second order), default 0.2
  
  % Energy parameters
  Options.Sigma1 = finalSigma1;     % Sigma used to calculate image derivatives, default 10
  Options.Wline = finalWline;       % Attraction to lines, if negative to black lines otherwise white lines , default 0.04
  Options.Wedge = finalWedge;       % Attraction to edges, default 2.0
  Options.Wterm = finalWterm;       % Attraction to terminations of lines (end points) and corners, default 0.01
  Options.Sigma2 = finalSigma2;     % Sigma used to calculate the gradient of the edge energy image (which gives the image force), default 20
  
  %  and GVF parameters  
  Options.GIterations= finalGItearations;         % Number of GVF iterations, default 0
  Options.Sigma3 = finalSigma3;     % Sigma used to calculate the laplacian in GVF, default 1.0
  Options.Mu = finalMu;             % Trade of between real edge vectors, and noise vectors, default 0.2. (Warning setting this to high >0.5 gives an instable Vector Flow)
  
  %% Do da snek
  [O,J]=Snake2D(I,P,Options);
  diceErr= dice(manSeg,J);
  
  % show results
  Irgb(:,:,1)=I;
  Irgb(:,:,2)=manSeg;
  Irgb(:,:,3)=J;
  figure, imshow(Irgb,[]); 
  hold on; plot([P(:,2);P(1,2)],[P(:,1);P(1,1)]);