clear all; close all; clc

imdata = imread('foto.jpg');
imdata = imresize(imdata, [250 250]);
figure(1);imshow(imdata); title('Original image')

imdata = rgb2gray(imdata);
figure(2);imshow(imdata); title('Gray image')

%trasformata di Fourier dell'immagine
F = fft2(imdata); 

%trasformata di Fuorier centrata
Fsh = fftshift(F);
figure(4);imshow(Fsh, []); title('Fuorier centered image')

%CLM(?) log della trasformata
Vpiu = log(1+Fsh);
figure(5);imshow(Vpiu, []); title('log transformed image')

VpiuCol = reshape(Vpiu, [], 1); %matrix to column vector
VpiuRow = reshape(Vpiu, 1, []); %matrix to row vector

V = pinv(VpiuRow)

function LoadImagesButton

    Vpiu = ExtractVpiuVector();
    V = pinv(Vpiu);

end
