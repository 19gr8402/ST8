clear; close all; clc;
list = dir('images\');
show = 1; result = zeros(0);
for i=4:length(list)
    if ~strcmp(list(i,1).name,{'.','..','desktop.ini'})        
        img = imread(['images\',list(i,1).name]);
        if size(img,3)>1,img = rgb2gray(img);end
        img = double(img);
        [time1,itr1] = ORACM1(img,show);
    %     [time2,itr2] = ORACM2(img,show);
        [time3,itr3] = ACMwithSBGFRLS(img,show);   
        [time4,itr4] = chenvese(img,show);
        result = [result;time1 itr1 time2 itr2 time3 itr3 time4 itr4];
    end
end
result