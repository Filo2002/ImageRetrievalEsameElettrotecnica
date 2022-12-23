function Rn = normalizedRecall(n,N,simBest,sortedVector)
    sumRank=0;
    sumI=0;
    rank=popolateRank(simBest,sortedVector,n);
    for i=1:n
        sumRank=sumRank+rank(i);
        sumI=sumI+i;
    end
    Rn=1-((sumRank-sumI)/n(N-n));
end