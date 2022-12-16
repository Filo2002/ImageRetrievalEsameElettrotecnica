function normSimilarity = normalization(currentValue, listValues)
    
    nvalues = length(listValues);
    tot = 0;

    for ii=1:nvalues
        
        tot = tot + listValues(ii);

    end
    
    normSimilarity = currentValue / tot;

end
