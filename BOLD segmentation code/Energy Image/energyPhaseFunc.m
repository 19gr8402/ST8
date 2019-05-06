function fasit = energyPhaseFunc(I)
gFrameCrop1 = I;

%% Scaling operation 
gFrameCrop2 = impyramid(gFrameCrop1, 'reduce');
gFrameCrop3 = impyramid(gFrameCrop2, 'reduce');
gFrameCrop4 = impyramid(gFrameCrop3, 'reduce');
gFrameCrop5 = impyramid(gFrameCrop4, 'reduce');

%% Create gabor filter
waveLen = [2 4 8 16];
orient  = [0 45 90 135];
filtBank = gabor(waveLen,orient,'SpatialFrequencyBandWidth',5); 

%% Perform gabor filtering using conv2
[s1Mag, s1Pha] = imgaborfilt(gFrameCrop1,filtBank);
[s2Mag, s2Pha] = imgaborfilt(gFrameCrop2,filtBank);
[s3Mag, s3Pha] = imgaborfilt(gFrameCrop3,filtBank);
[s4Mag, s4Pha] = imgaborfilt(gFrameCrop4,filtBank);
[s5Mag, s5Pha] = imgaborfilt(gFrameCrop5,filtBank);

s1All = s1Mag.*exp(s1Pha*1i);
s2All = s2Mag.*exp(s2Pha*1i);
s3All = s3Mag.*exp(s3Pha*1i);
s4All = s4Mag.*exp(s4Pha*1i);
s5All = s5Mag.*exp(s5Pha*1i);

%% Correct the imagenary part (abs)
s1All = complex(real(s1All),abs(imag(s1All)));
s2All = complex(real(s2All),abs(imag(s2All)));
s3All = complex(real(s3All),abs(imag(s3All)));
s4All = complex(real(s4All),abs(imag(s4All)));
s5All = complex(real(s5All),abs(imag(s5All)));

%% Rescale filtered images to the size of original
%s1All = s1All; 
s2All = imresize(s2All, [size(gFrameCrop1,1) size(gFrameCrop1,2)]);
s3All = imresize(s3All, [size(gFrameCrop1,1) size(gFrameCrop1,2)]);
s4All = imresize(s4All, [size(gFrameCrop1,1) size(gFrameCrop1,2)]);
s5All = imresize(s5All, [size(gFrameCrop1,1) size(gFrameCrop1,2)]);

%% Combine all orientations of the same scale by add complex values
allComb = zeros(size(gFrameCrop1,1),size(gFrameCrop1,2),5);

Wave = 1; 

for i=1:length(orient)
    allComb(:,:,1) = allComb(:,:,1) + s1All(:,:,Wave+4*(i-1));
    allComb(:,:,2) = allComb(:,:,2) + s2All(:,:,Wave+4*(i-1));
    allComb(:,:,3) = allComb(:,:,3) + s3All(:,:,Wave+4*(i-1)); 
    allComb(:,:,4) = allComb(:,:,4) + s4All(:,:,Wave+4*(i-1));
    allComb(:,:,5) = allComb(:,:,5) + s5All(:,:,Wave+4*(i-1));
end

% Multi-scale integration 
gamma = 3;  
fasit = 0; 
for i = 1:length(allComb(1,1,:))-3
    fasit = fasit + ((abs(allComb(:,:,i)).^gamma).*allComb(:,:,i)) ./(abs(allComb(:,:,i)).^gamma);
end  
end
