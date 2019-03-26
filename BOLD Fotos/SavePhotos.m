clearvars -except Subject
close all
clc

%load('C:\Users\Bo\Documents\MATLAB\2. semester kandidat\Project\Data\Sorteret_MRI_data_SubjectsOnly.mat')

for number=1:31
Image = Subject(number).Session(1).T2.right(:,:,2);
Image=mat2gray(Image);
filename=sprintf('Subject%dSession1.T2.right.jpg',number);
imwrite(Image,filename)
end