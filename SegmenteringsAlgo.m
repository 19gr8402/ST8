%% Script til manuel segmentering af MR billeder.
% House keeping
clear
close all
%% Load and setup
load('Sorteret_MRI_data_SubjectsOnly');

antalSubjects = 2; %sættes i samråd med Ryan
manSegS_s1_r2 = cell(antalSubjects, 1);

%% Løkke af manuelle segmenteringer

for n = 1:antalSubjects
    Fig = figure('units','normalized','outerposition',[0 0 1 1]);
    imshow(Subject(n).Session(1).T2.right(:,:,2),[],'InitialMagnification','fit')
    myROI = drawassisted();
    manSegS_s1_r2{n} = createMask(myROI);
    close(Fig)
end

%% Save results
save('manSegS_s1_r2','manSegS_s1_r2')
