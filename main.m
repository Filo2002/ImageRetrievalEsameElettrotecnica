clear all; close all; clc

savefig(designImageRetrieval);
loadImagesButton();

imdata = imread('foto.jpg');
imdata = imresize(imdata, [250 250]);
imdata = rgb2gray(imdata);

q = clm(imdata);

nVpiu = lenght(Vpiu);
orderedVectors = zeros(nVpiu, 62500);

for ii=1:nVpiu
    X = reshape(Vpiu(ii), 1, []); %matrix to row vector
    orderedVectors(ii, :) = orderVector(X, q);
end



function loadImagesButton

    Vpiu = extractVpiuVector();
    V = pinv(Vpiu);

end

