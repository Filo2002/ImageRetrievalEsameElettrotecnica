function Pn = normalizedPrecision(n,N,simBest,sortedVector)
    sumRank=0;
    sumI=0;
    rank=popolateRank(simBest,sortedVector,n);
    for i=1:n
        sumRank=sumRank+log(rank(i));
        sumI=sumI+log(i);
    end
    den = log(factorial(N)/log(factorial(n)*factorial(N-n)));
    Pn=1-abs(((sumRank-sumI)/den));
end