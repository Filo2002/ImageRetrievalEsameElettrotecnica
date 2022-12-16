function X = clm(A)
%CLM   Complex Logarithm Mapping

%trasformata di Fourier dell'immagine
F = fft2(A); 

%trasformata di Fuorier centrata
Fsh = fftshift(F);

%CLM(?) log della trasformata
Vpiu = log(1+Fsh);

X = reshape(Vpiu, 1, []); %matrix to row vector
end