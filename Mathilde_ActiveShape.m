%Af Mathilde ud fra Dirk-Jan Kroons.
%This script requires functions from Dirk-Jan Kroons ASM and AAM package
%https://se.mathworks.com/matlabcentral/fileexchange/26706-active-shape-model-asm-and-active-appearance-model-aam?s_tid=srchtitle
clear all;clc; close all;

% Add functions path to matlab search path
functionname='ASM_2D_example.m'; functiondir=which(functionname);
functiondir=functiondir(1:end-length(functionname));
addpath([functiondir 'Functions'])
addpath([functiondir 'ASM Functions'])
addpath([functiondir 'InterpFast_version1'])

% Try to compile c-files
cd([functiondir 'InterpFast_version1'])
try
    mex('interp2fast_double.c','image_interpolation.c');
catch ME
    disp('compile c-files failed: example will be slow');
end
cd(functiondir);

%% Set options
% Number of contour points interpolated between the major landmarks.
options.ni=20;
% Length of landmark intensity profile
options.k = 8; 
% Search length (in pixels) for optimal contourpoint position, 
% in both normal directions of the contourpoint.
options.ns=6;
% Number of image resolution scales
options.nscales=2;
% Set normal contour, limit to +- m*sqrt( eigenvalue )
options.m=3;
% Number of search itterations
options.nsearch=40;
% If verbose is true all debug images will be shown.
options.verbose=true;
% The original minimal Mahanobis distance using edge gradient (true)
% or new minimal PCA parameters using the intensities. (false)
options.originalsearch=false;  

%% Collect training data

fileFolder = dir(uigetdir);
fileFolder = fileFolder.folder;
listOfFiles = dir(fullfile(fileFolder, '*.mat'));


%DrawContourGui()


