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

Sigma = 0.5;  %0.4  %0.5 sat empirisk

Ix=ImageDerivatives2D(I,Sigma,'x');
Iy=ImageDerivatives2D(I,Sigma,'y');
Ixx=ImageDerivatives2D(I,Sigma,'xx');
Ixy=ImageDerivatives2D(I,Sigma,'xy');
Iyy=ImageDerivatives2D(I,Sigma,'yy');

Eterm = (Iyy.*Ix.^2 -2*Ixy.*Ix.*Iy + Ixx.*Iy.^2)./((1+Ix.^2 + Iy.^2).^(3/2));
Eedge = sqrt(Ix.^2 + Iy.^2);

Eterm = uint8(255 * mat2gray(Eterm));
Eterm = imcomplement(Eterm);
Eedge = uint8(255 * mat2gray(Eedge));

fasit = energyPhaseFunc(I);
 T = 0.5;  %0.3 0.7 %0.5 sat empirisk
 e = 0.5;   %0.5 sat empirisk
Ephase = uint8(255 * mat2gray((1-(( abs(imag(fasit)) - abs(real(fasit)) - T) ./ ( sqrt((abs(real(fasit)).^2) + (abs(imag(fasit)).^2)) + e ))) ./2));


Eedge = histeq(Eedge);
% Eextrn = imcomplement(uint8(255 * mat2gray(Ephase-Eedge-Eterm)));
Eextern = im2double(uint8(255 * mat2gray(double(Ephase)-double(Eedge)+double(Eterm))));

