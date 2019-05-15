%% Average shape creator
close all
clearvars -except binarySegment P
i=6;

    I = binarySegment;
    I = uint8(255 * mat2gray(I));
    I = im2double(I);
    % Show the image and select some points with the mouse (at least 4)
    figure
    se = strel('disk',10);    
    I_erode = imerode(I,se);
    imshow(I-I_erode);
    [y,x] = getpts;
    close all
    P{i}=[x(:)-mean(x(:)) y(:)-mean(y(:))];
    P{i}=InterpolateContourPoints2D(P{i},15);