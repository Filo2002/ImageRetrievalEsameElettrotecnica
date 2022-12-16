clear all; close all; clc

savefig(designImageRetrieval);
loadImagesButton();


function loadImagesButton

    Vpiu = extractVpiuVector();
    V = pinv(Vpiu);

end

