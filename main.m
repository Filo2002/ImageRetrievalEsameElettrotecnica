clear all; close all; clc

savefig(designImageRetrieval);
loadImagesButton();


function loadImagesButton

    Vpiu = ExtractVpiuVector();
    V = pinv(Vpiu);

end

