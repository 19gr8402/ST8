function [Isegmented]=ASM_Segmentation_BOLD(I)%,AppearanceData,ShapeData,TrainingDataLines)
    
%% Set options
% Length of landmark intensity profile
options.k = 15;
% Search length (in pixels) for optimal contourpoint position, 
% in both normal directions of the contourpoint.
options.ns=1;
% Number of image resolution scales
options.nscales=7;
% Set normal contour, limit to +- m*sqrt( eigenvalue )
options.m=2;
% Number of search itterations
options.nsearch=150;  %150
% If testverbose is true all test images will be shown.
options.testverbose=false;
% The original minimal Mahanobis distance using edge gradient (true)
% or new minimal PCA parameters using the intensities. (false)
options.originalsearch=false;  

%% Test the ASM model %%

compartments = 5;
load('TrainingDataASMfinal');

%IProcessedImage = ExternalForceImage(double(mat2gray(I)));
IProcessedImage = ExternalForceImage(double(I));
% Initial position offset and rotation, of the initial/mean contour
tform.offsetr = 0.5; tform.offsetv=[-256 -256]; tform.offsets=0;
pos=[ShapeData.x_mean(1:end/2) ShapeData.x_mean(end/2+1:end)];
pos=ASM_align_data_inverse2D(pos,tform);

% Apply the ASM model onm the test image
Isegmented=ASM_ApplyModel2D(I,IProcessedImage,tform,ShapeData,AppearanceData,options,TrainingDataLines,compartments);

end


    