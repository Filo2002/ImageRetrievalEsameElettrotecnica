function sortedVector = sortVector(simBest, maxImg)

    sortedVector = zeros(maxImg, 1);
    nSimBest = length(simBest);
    index = 0;

    for ii=1:maxImg
        best = simBest(ii);
        index = ii;
        for jj=1:nSimBest
            if (simBest(jj) > best)
                best = simBest(jj);
                index = jj;
            end
        end
        sortedVector(ii) = index;
        simBest(index) = 0;
    end

end