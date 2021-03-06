function Eextern = ExternalForceImageSJ(I)
% Eextern = ExternalForceImage2D(I)
% 
% inputs, 
%  I : The image
%
% outputs,
%  Eextern : The energy function described by the image
%
% Function is an adaption, by Steffen Jensen Aalborg university (2019), of 
% a function by D.Kroon University of Twente (July 2010)

Sigma = 0.5;    %sat empirisk

Ix=ImageDerivatives2D(I,Sigma,'x');
Iy=ImageDerivatives2D(I,Sigma,'y');
Ixx=ImageDerivatives2D(I,Sigma,'xx');
Ixy=ImageDerivatives2D(I,Sigma,'xy');
Iyy=ImageDerivatives2D(I,Sigma,'yy');

Eterm = (Iyy.*Ix.^2 -2*Ixy.*Ix.*Iy + Ixx.*Iy.^2)./((1+Ix.^2 + Iy.^2).^(3/2));
Eterm = uint8(255 * mat2gray(Eterm));
Eterm = imcomplement(Eterm);
% Eterm = histeq(Eterm);
% Eterm = medfilt2(Eterm);

Eedge = sqrt(Ix.^2 + Iy.^2);
Eedge = uint8(255 * mat2gray(Eedge));
Eedge = histeq(Eedge);
Eedge = medfilt2(Eedge);

sigmaLine = 8;
Eline = imgaussian(I,sigmaLine);
% 
%Elinefilt = medfilt2(Eline);
Elinefilt = medfilt2(Eline,[50 50],'symmetric');
Eline = Eline-Elinefilt;
%Eline = histeq(Eline);
%Eline = imcomplement(Eline);
Eline = uint8(255 * mat2gray(Eline));

fasit = energyPhaseFunc(I);
 T = 0.5;   %sat empirisk
 e = 0.5;   %sat empirisk
Ephase = uint8(255 * mat2gray((1-(( abs(imag(fasit)) - abs(real(fasit)) - T) ./ ( sqrt((abs(real(fasit)).^2) + (abs(imag(fasit)).^2)) + e ))) ./2));
Ephase = medfilt2(Ephase);

% [IMuscle, INoMuscle, IFatAndBoneBinary] = AllMuscleSegmentation(I,0);
% IFatAndBoneBinary = uint8(mat2gray(IFatAndBoneBinary));

%% Show images
% figure
% subplot(3,3,1)
% imshow(Eedge)
% title('edge')
% subplot(3,3,2)
% imshow(Eline)
% title('line')
% subplot(3,3,3)
% imshow(Ephase)
% title('phase')
% subplot(3,3,4)
% imshow(Eterm)
% title('term')
% subplot(3,3,5)
% imshow(Ephase-Eedge-Eterm+Eline)
% title('extern')
% subplot(3,3,6)
% imshow(((Ephase-Eedge+Eterm).*IFatAndBoneBinary)+imgaussfilt(imcomplement(IFatAndBoneBinary*255),50).*(imcomplement(IFatAndBoneBinary*255)./255))
% title('extern u. line')
% subplot(3,3,7); imshow(IMuscle,[]), title('Cut original muscle image');
% subplot(3,3,8); imshow(INoMuscle,[]), title('Cut original no muscle image');
% subplot(3,3,9); imshow(imgaussfilt(imcomplement(IFatAndBoneBinary*255),50).*(imcomplement(IFatAndBoneBinary*255)./255),[]), title('Binary image');

%% Output
% Eextrn = imcomplement(uint8(255 * mat2gray(Ephase-Eedge-Eterm)));
% Eextern = im2double(uint8(255 * mat2gray((((Ephase-Eedge+Eterm).*IFatAndBoneBinary)+imgaussfilt(imcomplement(IFatAndBoneBinary*255),50).*(imcomplement(IFatAndBoneBinary*255)./255)))));%+imcomplement(IFatAndBoneBinary*255))));
Eextern = im2double(uint8(255 * mat2gray(Ephase-Eedge+Eterm))); %<��� DEN GODE
% Eextern = im2double(uint8(255 * mat2gray(Ephase-Eedge-Eterm+Eline.*(imcomplement(IFatAndBoneBinary*255)./255))));
