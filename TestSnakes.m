%% Kass-Witken-Terzopoulos + Xu-prince test af snakes
% efter load af vores workspace med MRI billlederne
close all
clearvars -except Subject manSegS9_1_r2
%% read, show and initial contour:

% Read an image
  I = Subject(9).Session(1).T2.right(:,:,2);
  %I= img_filt;
  manSeg = manSegS9_1_r2;   % fundet med drawassisted() og createMask(myROI)
% Convert the image to double data type 
  I = uint8(255 * mat2gray(I));
  I = im2double(I);
% Show the image and select some points with the mouse (at least 4)
  figure 
  imshow(I,[]); 
  [y,x] = getpts;
%   y=[182 233 251 205 169];
%   x=[163 166 207 248 210];
%% Make an array with the clicked coordinates
  P=[x(:) y(:)];
%% Start Snake optimization Process
  dice_snakeVSman = 0;
  
  % predetermined snake options
  Options = struct;
  Options.Verbose = false; % show important images if true
  Options.Iterations = 200;
  Options.GIterations= 200;
  Options.Delta = 0.1;     % Baloon force, default 0.1
  %%
  % snake parameters (aplha, beta and kappa) limits
  minAlpha = 0;
  maxAlpha = 1;
  incAlpha = 0.1;
  minBeta = 0;
  maxBeta = 1;
  incBeta = 0.1;
  minKappa = 0;
  maxKappa = 10;
  incKappa = 1;
  
  % GVF parameters limits
  minMu = 0;
  maxMu = 0.5;
  incMu = 0.05;
  minSigma3 = 0;
  maxSigma3 = 5;
  incSigma3 = 0.5;
  
  % optimization
  for myKappa = minKappa:incKappa:maxKappa     % Weight of external image force, default 2
      for myAlpha = minAlpha:incAlpha:maxAlpha
          for myBeta = minBeta:incBeta:maxBeta
              for myMu = minMu:incMu:maxMu
                  for mySigma3 = minSigma3:incSigma3:maxSigma3
                      Options.Sigma3 = mySigma3;    % Sigma used to calculate the laplacian in GVF, default 1.0
                      Options.Mu = myMu;            % Trade of between real edge vectors, and noise vectors
                      Options.Kappa = myKappa;      % noget med intensiteten af billedet eller grænserne
                      Options.Alpha = myAlpha;      % Membrame energy  (first order), default 0.2
                      Options.Beta = myBeta;        % Thin plate energy (second order), default 0.2
                      [~,J]=Snake2D(I,P,Options);
                      
                      temp_dice_snakeVSman = dice(manSeg,J);
                      
                      if temp_dice_snakeVSman > dice_snakeVSman
                          dice_snakeVSman = temp_dice_snakeVSman;
                          finalSigma3 = mySigma3;
                          finalMu = myMu;
                          finalKappa = myKappa;
                          finalAlpha = myAlpha;
                          finalBeta = myBeta;
                      else
                      end
                  end
              end
          end
      end
  end
  
  % Snake with optimized options
%   Options.Verbose = true; % show important images if true
%   Options.Kappa = finalKappa;
%   Options.Alpha = finalAlpha;     % Membrame energy  (first order), default 0.2
%   Options.Beta = finalBeta;      % Thin plate energy (second order), default 0.2
%   Options.Mu = finalMu;
%   Options.Sigma3 = finalSigma3;
  
  %% sæt variable
  Options.Verbose = true;   % show important images if true
  Options.Kappa = 1;
  Options.Alpha = 0.4;     % Membrame energy  (first order), default 0.2
  Options.Beta = 0;      % Thin plate energy (second order), default 0.2
  %Options.Mu = ;
  %Options.Sigma3 = finalSigma3;
  
  [O,J]=Snake2D(I,P,Options);
  
  %% Show the result
  Irgb(:,:,1)=I;
  Irgb(:,:,2)=manSeg;
  Irgb(:,:,3)=J;
  figure, imshow(Irgb,[]); 
  hold on; plot([O(:,2);O(1,2)],[O(:,1);O(1,1)]);
