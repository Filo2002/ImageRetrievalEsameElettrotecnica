clear all; close all; clc

loadImagesButton();

function loadImagesButton

    Vpiu = extractVpiuVector();
    V = pinv(Vpiu);

end