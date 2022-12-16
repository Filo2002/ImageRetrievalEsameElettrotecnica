function Vpiu = extractVpiuVector()
    imagefiles = dir('Images/*.jpg');     
    nfiles = length(imagefiles);

    Vpiu = zeros(nfiles, 62500);

    for ii=1:nfiles
        currentfilename = imagefiles(ii).name;
        imdata = imread(currentfilename);
        imdata = imresize(imdata, [250 250]);
        imdata = rgb2gray(imdata);

        VpiuKRow = clm(imdata); %matrix to row vector

        Vpiu(ii,:) = VpiuKRow;
    end
    
end