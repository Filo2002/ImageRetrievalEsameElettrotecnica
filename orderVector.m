function vettOrdered = orderVector(vettA,vettB,delta)
    for i=1:size(vettA)
        if((vettA(i)*vettB(i))>delta)
           vettOrdered(i)=vettA(i)*vettB(i);
        else
           vettOrdered(i)=0;
        end
    end
end