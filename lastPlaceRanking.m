function Ln = lastPlaceRanking(n,N,simBest,sortedVector)
    rank=popolateRank(simBest,sortedVector,n);
    Ln=1-((rank(n)-n)/(N-n));    
end