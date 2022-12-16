clear all; close all; clc

imdata = imread('foto.jpg');
imdata = imresize(imdata, [250 250]);
figure(1);imshow(imdata); title('Original image')

imdata = rgb2gray(imdata);
figure(2);imshow(imdata); title('Gray image')

immClm = clm(imdata);

V = pinv(immClm);



function vettOrdered = orderVector(vettA,vettB,delta)
    for i=1:size(vettA)
        if((vettA(i)*vettB(i))>delta)
           vettOrdered(i)=vettA(i)*vettB(i);
        else
           vettOrdered(i)=0;
        end
    end
end

    
