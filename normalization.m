function normSimilarity = normalization(currentValue, listValues)
    
    tot = sumVector(listValues);
    
    normSimilarity = currentValue / tot;

end
