clear all; close all; clc

loadImagesButton();

function loadImagesButton

    Vpiu = ExtractVpiuVector();
    V = pinv(Vpiu);

end