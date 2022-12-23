%funzione per popolare vettore contenente parametri di similarità per funzioni sotto
function rank = popolateRank(simBest, sortedVector,n)
    for i=1:n
       rank(i)=simBest(sortedVector(i));
    end
end

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

function Pn = normalizedPrecision(n,N,simBest,sortedVector)
    sumRank=0;
    sumI=0;
    rank=popolateRank(simBest,sortedVector,n);
    for i=1:n
        sumRank=sumRank+log(rank(i));
        sumI=sumI+log(i);
    end
    den = log(factorial(N)/log(factorial(n)*factorial(N-n)));
    Pn=1-((sumRank-sumI)/den);
end

function Ln = lastPlaceRanking(n,N,simBest,sortedVector)
    rank=popolateRank(simBest,sortedVector,n);
    Ln=1-((rank(n)-n)/(N-n));
end