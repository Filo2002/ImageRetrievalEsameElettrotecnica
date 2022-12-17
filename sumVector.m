function tot = sumVector(orderVett)

    nValues = length(orderVett);
    tot = 0;

    for ii=1:nValues
        
        tot = tot + abs(orderVett(ii));

    end

end