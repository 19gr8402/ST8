%% Ground Truth Segmentation 
close all 
clearvars -except Subject

if ~exist('Subject','var')
load('C:\Users\mathi\Google Drive\ST8\MATLAB\Sorteret_MRI_data_SubjectsOnly.mat')
end
%% Specify Subject no
n = input('Subject no.:');
I = flip(Subject(n).Session(1).T2.left(:,:,2),2);

%% Anterior
fig = figure('units','normalized','outerposition',[0 0 1 1]);

imshow(I,[],'InitialMagnification','fit');
title('Anterior');

roi = drawassisted();
anterior = createMask(roi);
close(fig)

%% Lateral
fig = figure('units','normalized','outerposition',[0 0 1 1]);

I_double = mat2gray(I);
I_overlay= I_double + mat2gray(anterior);

imshow(I_overlay,'InitialMagnification','fit');
title('Lateral');


roi = drawassisted();
lateral = createMask(roi);
close(fig)

%% Deep Posterior
I_overlay= I_double + mat2gray(anterior)+mat2gray(lateral);

fig = figure('units','normalized','outerposition',[0 0 1 1]);
imshow(I_overlay,'InitialMagnification','fit');
title('Deep Posterior');

roi = drawassisted();
deep = createMask(roi);
close(fig)

%% Soleus
I_overlay= I_double + mat2gray(anterior)+mat2gray(lateral)+ mat2gray(deep);

fig = figure('units','normalized','outerposition',[0 0 1 1]);
imshow(I_overlay,'InitialMagnification','fit');
title('Soleus');

roi = drawassisted();
soleus = createMask(roi);
close(fig)

%% Gatrocnemius
I_overlay= I_double + mat2gray(anterior)+mat2gray(lateral)+ mat2gray(deep)+mat2gray(soleus);

fig = figure('units','normalized','outerposition',[0 0 1 1]);
imshow(I_overlay,'InitialMagnification','fit');
title('Gatrocnemius');

roi = drawassisted();
gastrocnemius = createMask(roi);
close(fig)
%% Save
filename = sprintf('Subject%i.mat', n);
save(filename, 'anterior', 'lateral', 'deep','soleus', 'gastrocnemius');
