clearvars -except Subject; clc; close all;

%% Load data
%load('D:\Noter\Project\Sorteret_MRI_data_SubjectsOnly.mat')
% load('C:\Users\mathi\Google Drive\ST8\MATLAB\Sorteret_MRI_data_SubjectsOnly.mat')
load('manSegS_s1_r2_6comp_Ground_Truth');

%% Set options
% Number of contour points interpolated between the major landmarks.
options.ni=30;   %30
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
% If verbose is true all debug images will be shown.
options.verbose=false;

%% Load training data
% First Load the Hand Training DataSets (Contour and Image)
% The LoadDataSetNiceContour, not only reads the contour points, but 
% also resamples them to get a nice uniform spacing, between the important
% landmark contour points.

compartments = 10;
load('31trainSubject10comp');

%for run=5:5:25

%A = randperm(31,run);
    
TrainingData=struct;
for i=1:31%31
    %a = A(1,i);
    I = ExternalForceImage(double(Subject(i).Session(1).T2.right(:,:,2))); %double(mat2gray(mat2gray(
    
    if(options.verbose); figure; imshow(Subject(i).Session(1).T2.right(:,:,2),[]); hold on; end
    for k=1:compartments
    p = trainSubject(i).p(k);
    
    [Vertices,Lines,I]=LoadDataSetNiceContour(I,p,options.ni,options.verbose);
    TrainingData(i).VerticesComp(k).c = Vertices;
    TrainingData(i).LinesComp(k).c = Lines;
    end
    
    TrainingData(i).Vertices=TrainingData(i).VerticesComp(1).c;
    TrainingData(i).Lines=TrainingData(i).LinesComp(1).c;
	TrainingData(i).I=I;
    
    for k=2:compartments
    TrainingData(i).Vertices=[TrainingData(i).Vertices; TrainingData(i).VerticesComp(k).c];
    TrainingData(i).Lines=[TrainingData(i).Lines; TrainingData(i).LinesComp(k).c];
    end
    TrainingData(i).Lines=[(1:size(TrainingData(i).Vertices,1))' ([2:size(TrainingData(i).Vertices,1) 1])'];
    i
end

%figure; imshow(I);
%% Shape Model %%
% Make the Shape model, which finds the variations between contours
% in the training data sets. And makes a PCA model describing normal
% contours
[ShapeData TrainingData]= ASM_MakeShapeModel2D(TrainingData);
  
% Show some eigenvector variations
if(options.verbose)
    figure,
    for i=1:min(6,length(ShapeData.Evalues))
        xtest = ShapeData.x_mean + ShapeData.Evectors(:,i)*sqrt(ShapeData.Evalues(i))*3;
        subplot(2,3,i), hold on;
        plot(xtest(end/2+1:end),xtest(1:end/2),'r.');
        plot(ShapeData.x_mean(end/2+1:end),ShapeData.x_mean(1:end/2),'b.');
    end
    drawnow;
end

    
%% Appearance model %%
% Make the Appearance model, which samples a intensity pixel profile/line 
% perpendicular to each contourpoint in each trainingdataset. Which is 
% used to build correlation matrices for each landmark. Which are used
% in the optimization step, to find the best fit.
AppearanceData = ASM_MakeAppearanceModel2D(TrainingData,options);

%% Test the ASM model %%

TrainingDataLines = TrainingData.LinesComp;
testCompartments = 5;
for i=1:3 % Number of subject test images
I=flip(Subject(i).Session(1).T2.left(:,:,2),2);
number = num2str(i);

ISegmented = ASM_Segmentation_BOLD(I,AppearanceData,ShapeData,TrainingDataLines);
Segmentation(i).Subject=ISegmented;
% Plot ASM segmentation
% Segout = mat2gray(I);
% for k=1:5
% Outline = bwperim(ISegmented(k).Seg);
% Segout(Outline) = 1;
% end
% figure; imshow(Segout,[]); title(['ASM: Subject ', number,]);
% 
% %Plot ground truth segmentation
% ISegmentedGT = manSegGroundTruth(i).Subject(1:5);
% Segout = mat2gray(I);
%     for k=1:5
%     Outline = bwperim(ISegmentedGT(k).Seg);
%     Segout(Outline) = 1;
%     end
% figure; imshow(Segout,[]); title(['GT: Subject ', number,]);

%% Calculate dice
    for k=1:testCompartments
    diceErr(1).run(k,i) = dice(manSegGroundTruth(i).Subject(k).Seg,ISegmented(k).Seg);
    end
i
end

%end