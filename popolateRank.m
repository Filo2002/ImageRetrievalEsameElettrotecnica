function rank = popolateRank(simBest, sortedVector,n)
    rank = zeros(n, 1);
    for i=1:n
       rank(i)=simBest(sortedVector(i));
    end
end