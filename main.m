clear all; close all; clc

%savefig(designImageRetrieval);
loadImagesButton();
Vpiu = extractVpiuVector();
V = pinv(Vpiu);

imdata = imread('foto3.jpg');
imdata = imresize(imdata, [250 250]);
imdata = im2gray(imdata);

q = clm(imdata);

nVpiu = 3;
orderedVectors = zeros(nVpiu, 62500);

for ii=1:nVpiu
    X = reshape(Vpiu(ii), 1, []); %matrix to row vector
    orderedVectors(ii, :) = orderVector(X, q, 0);
end

similarityVec = zeros(nVpiu,1);

for ii=1:nVpiu  

    similarityVec(ii) = sumVector(orderedVectors(ii, :));

end

for ii=1:nVpiu  
    similarityVec(ii)
    simNorm = normalization(similarityVec(ii), similarityVec);
    simNorm = abs(simNorm)

end



function loadImagesButton

    Vpiu = extractVpiuVector();
    V = pinv(Vpiu);

end

