function [BOLDsequence]=Image_registration_and_BOLD(I,echoPlanarImages,ISegmented,showMethod)

%% Parameters 

[optimizer,metric] = imregconfig('multimodal');
%Anvender Optimizer= OnePlusOneEvolutionary og Metric= MattesMutualInformation

pyramidLevels = 3;  %Default = 3

%%%%%%% OPTIMIZER %%%%%%
%disp(optimizer)
%Initial Radius
optimizer.InitialRadius = 0.0018;

%Max Iterations
optimizer.MaximumIterations = 100; 

%Epsilon - Minimum søgeradius, kan derved give højere accuracy v.
%konvergens når den er lav
optimizer.Epsilon = 1.5e-06; 

%Growth Factor - Kontrollerer hvor hurtigt søgeradius stiger. 
optimizer.GrowthFactor = 1.005; 

%%%%%%% METRIC %%%%%%
%disp(metric)
%Number of Histogram Bins
metric.NumberOfHistogramBins = 32; %Default = 50

%% TEST REGISTATION - Single BOLD image


%% REGISTRATION - Full BOLD Sequence
antalSubjects = 1;
%antalSubjects = input('Number of Subjects:');

    fixed = I;
    
    %Estimering af transformationen m. Mutual Information (optimering)
    bold(:,:,1) = imresize(echoPlanarImages(:,:,1),8, 'nearest');
    tform = imregtform(bold(:,:,1),fixed,'affine',optimizer,metric,'PyramidLevels',pyramidLevels); %affine
    
    %Registrering vha. den estimerede transformation indtil billede 24.
    for i=1:450 %24
         bold(:,:,i) = imresize(echoPlanarImages(:,:,i),8, 'nearest');
         bold_reg(:,:,i) = imwarp(bold(:,:,i),tform,'OutputView',imref2d(size(fixed)));
         %bold_reg(:,:,i) = imregister(bold(:,:,i),fixed,'affine',optimizer,metric,'PyramidLevels',pyramidLevels);
         %Affine:  scaling, rotation, and (possibly) shear
    end
%     
%     %Genstimering af transformationen m. Mutual Information (optimering)
%     %for hver af billederne 25 til 35 (deformering pga. cuff occlusion)
%     for i=25:35
%        bold(:,:,i) = imresize(echoPlanarImages(:,:,i),8, 'nearest');
%        bold_reg(:,:,i) = imregister(bold(:,:,i),fixed,'affine',optimizer,metric,'PyramidLevels',pyramidLevels);
%     end
%     
%     %Genestimering af transformationen m. billede 36
%     bold(:,:,36) = imresize(echoPlanarImages(:,:,36),8, 'nearest');
%     tform = imregtform(bold(:,:,36),fixed,'affine',optimizer,metric,'PyramidLevels',pyramidLevels);
%     
%     %Registrering vha. den estimerede transformation indtil billede 424.
%     for i=36:424
%          bold(:,:,i) = imresize(echoPlanarImages(:,:,i),8, 'nearest');
%          bold_reg(:,:,i) = imwarp(bold(:,:,i),tform,'OutputView',imref2d(size(fixed)));
%     end
%     
%     %Genstimering af transformationen m. Mutual Information (optimering)
%     %for hver af billederne 25 til 35 (deformering pga. cuff occlusion)
%     for i=425:435
%        bold(:,:,i) = imresize(echoPlanarImages(:,:,i),8, 'nearest');
%        bold_reg(:,:,i) = imregister(bold(:,:,i),fixed,'affine',optimizer,metric,'PyramidLevels',pyramidLevels);
%     end
%     
%     %Genestimering af transformationen m. billede 436
%     bold(:,:,436) = imresize(echoPlanarImages(:,:,436),8, 'nearest');
%     tform = imregtform(bold(:,:,436),fixed,'affine',optimizer,metric,'PyramidLevels',pyramidLevels);
%     
%     %Registrering vha. den estimerede transformation indtil billede 424.
% for i=436:450
%      bold(:,:,i) = imresize(echoPlanarImages(:,:,i),8, 'nearest');
%      bold_reg(:,:,i) = imwarp(bold(:,:,i),tform,'OutputView',imref2d(size(fixed)));
% end

for compartment = 1:size(ISegmented,2)
for i=1:450
    bold_temp = bold_reg(:,:,i);
    bold_temp(~ISegmented(compartment).Seg)=0;
    bold_temp = bold_temp(:); %Omdanner billedmatricen til en rækkevektor.
    bold_temp = bold_temp(bold_temp>0);
    BOLDsequence(compartment).Seg(i,:)=mean(bold_temp);
    
end    
    baselineMean = mean(BOLDsequence(compartment).Seg(5:29));
    %Normaliser til procentvis i forhold til baseline på 1.
    BOLDsequence(compartment).Seg = BOLDsequence(compartment).Seg/baselineMean; %normalize( ,'range');
end



% %% PLOT
% %Images to plot:
figure;
plotI = [1 25 30 36 200 250 300 350 450];
%plotI = [23 24 25 26 27 28 29 30 31];

subplot(3,3,1)
imshowpair(bold_reg(:,:,plotI(1)),fixed)
title(sprintf('BOLD Image %i', plotI(1)))
subplot(3,3,2)
imshowpair(bold_reg(:,:,plotI(2)),fixed)
title(sprintf('BOLD Image %i', plotI(2)))
subplot(3,3,3)
imshowpair(bold_reg(:,:,plotI(3)),fixed)
title(sprintf('BOLD Image %i', plotI(3)))
subplot(3,3,4)
imshowpair(bold_reg(:,:,plotI(4)),fixed)
title(sprintf('BOLD Image %i', plotI(4)))
subplot(3,3,5)
imshowpair(bold_reg(:,:,plotI(5)),fixed)
title(sprintf('BOLD Image %i', plotI(5)))
subplot(3,3,6)
imshowpair(bold_reg(:,:,plotI(6)),fixed)
title(sprintf('BOLD Image %i', plotI(6)))
subplot(3,3,7)
imshowpair(bold_reg(:,:,plotI(7)),fixed)
title(sprintf('BOLD Image %i', plotI(7)))
subplot(3,3,8)
imshowpair(bold_reg(:,:,plotI(8)),fixed)
title(sprintf('BOLD Image %i', plotI(8)))
subplot(3,3,9)
imshowpair(bold_reg(:,:,plotI(9)),fixed)
title(sprintf('BOLD Image %i', plotI(9)))
end