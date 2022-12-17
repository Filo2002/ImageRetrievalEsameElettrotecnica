function vettOrdered = orderVector(vettA,vettB,delta)
    for i=1:length(vettA)
        if((vettA(i)*vettB(i))>delta)
           vettOrdered(i)=(vettA(i)*vettB(i)) - delta;
        else
           vettOrdered(i)=0;
        end
    end
end