clear all; close all; clc

imdata = imread('foto.jpg');
imdata = imresize(imdata, [1080 1080]);
figure(1);imshow(imdata); title('Original image')

imdata = rgb2gray(imdata);
figure(2);imshow(imdata); title('Gray image')

F = fft2(imdata);

S = abs(F);
figure(3);imshow(S, []); title('Fuorier transform of image')

Fsh = fftshift(F);
figure(4);imshow(Fsh, []); title('Fuorier centered image')

S2 = log(1+Fsh);
figure(5);imshow(S2, []); title('log transformed image')