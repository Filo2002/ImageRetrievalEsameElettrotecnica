function Vpiu = extractVpiuVector()
    directory = 'Images/keywords/';
    imagefiles = dir(strcat(directory, '*.jpg'));     
    nfiles = length(imagefiles);

    imageSize = StoreData.GetImageSize();

    Vpiu = zeros(nfiles, imageSize.^2);

    for ii=1:nfiles
        currentfilename = imagefiles(ii).name;
        imdata = imread(strcat(directory, currentfilename));
        imdata = imresize(imdata, [imageSize imageSize]);
        imdata = im2gray(imdata);

        VpiuKRow = clm(imdata); %matrix to row vector

        Vpiu(ii,:) = VpiuKRow;
    end
    
end