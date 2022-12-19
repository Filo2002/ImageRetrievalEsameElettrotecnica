function Vpiu = extractVpiuVector(fullName)
    directory = 'Images/keywords/';
    imagefiles = dir(strcat(directory, '*.jpg'));     
    nfiles = length(imagefiles) +1;

    imageSize = StoreData.GetImageSize();

    Vpiu = zeros(nfiles, imageSize.^2);
    
    imdata = imread(fullName);
    imdata = imresize(imdata, [imageSize imageSize]);
    imdata = im2gray(imdata);
    VpiuKRow = clm(imdata); %matrix to row vector
    Vpiu(1,:) = VpiuKRow;

    for ii=2:nfiles
        currentfilename = imagefiles(ii - 1).name;
        imdata = imread(strcat(directory, currentfilename));
        imdata = imresize(imdata, [imageSize imageSize]);
        imdata = im2gray(imdata);

        VpiuKRow = clm(imdata); %matrix to row vector

        Vpiu(ii,:) = VpiuKRow;
    end
    
end