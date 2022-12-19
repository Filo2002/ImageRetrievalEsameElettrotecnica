function images = getImages(directory)
    images = dir(strcat(directory, '*.jpg'));
end