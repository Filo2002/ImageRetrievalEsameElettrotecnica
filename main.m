clear all; close all; clc

%savefig(designImageRetrieval);
loadImagesButton();
Vpiu = extractVpiuVector('foto.jpg');
V = pinv(Vpiu);

choseIndex = mainFunction(Vpiu, V);
imageSize = StoreData.GetImageSize();
directory = 'Images/foto_icon/';
imagefiles = dir(strcat(directory, '*.jpg')); 
 

%feedback di prova impostando prefissata l'immagine 3
currentfilename = imagefiles(choseIndex).name;
imdata = imread(strcat(directory, currentfilename));
imdata = imresize(imdata, [imageSize imageSize]);
imdata = im2gray(imdata);
q = clm(imdata);
vsi = pinv(q);

vnew = feedback(V(:,3),vsi);

V(:,3) = vnew;
Vpiu = pinv(V);

mainFunction(Vpiu, V);


function choseIndex = mainFunction(Vpiu, V)
    close all;
    imageSize = StoreData.GetImageSize();
    
    directory = 'Images/foto_icon/';
    imagefiles = dir(strcat(directory, '*.jpg'));     
    totImage = length(imagefiles);
    
    simBest = zeros(totImage, 2);
    
    for index=1:totImage
    
        currentfilename = imagefiles(index).name;
        imdata = imread(strcat(directory, currentfilename));
        imdata = imresize(imdata, [imageSize imageSize]);
        imdata = im2gray(imdata);
        q = clm(imdata);
        
        nVpiu = size(Vpiu);
        nVpiu = nVpiu(1);
        orderedVectors = zeros(nVpiu, imageSize.^2);
        
        for ii=1:nVpiu
            X = Vpiu(ii, :); %matrix to row vector
            orderedVectors(ii, :) = orderVector(X, q, 50);   %delta 5 sembra al limite per attendibilità
        end
        
        similarityVec = zeros(nVpiu,1);
        selfAttVec = zeros(nVpiu,1);
    
        
        for ii=1:nVpiu  
        
            similarityVec(ii) = sumVector(orderedVectors(ii, :));
            selfAttVec(ii) = selfAtt(Vpiu(ii, :), V(:, ii), q, 50);
        end
        
        simNorm = normalization(similarityVec(2), similarityVec); %1 corrisponde alla 1 foto per la ricerca, in questo caso il cerchio.
        selfAttNorm = normalization(selfAttVec(2), selfAttVec);
        simBest(index, 1) = abs(simNorm);
        simBest(index, 2) = abs(selfAttNorm);
    end

    simBest
    sortedVect = sortVector(simBest, StoreData.GetMaximumImages());
    
    for jj=1:StoreData.GetMaximumImages()
    
        currentfilename = imagefiles(sortedVect(jj)).name;
        imdata = imread(strcat(directory, currentfilename));
        figure(jj);imshow(imdata); title(jj)
    
    end

    choseIndex = sortedVect(1);
end

