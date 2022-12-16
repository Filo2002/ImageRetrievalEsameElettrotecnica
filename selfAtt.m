function CalculatedSselfatt = selfAtt(Vrpiu,Vr,q,delta)
    orderedVVpiu = orderVector(Vrpiu,Vr,delta);
    orderedVpiuQ = orderVector(Vrpiu,q,delta);
    CalculatedSselfatt=0;
    for i=1:length(Vr)
         CalculatedSselfatt=CalculatedSselfatt + abs(orderedVVpiu(i)-orderedVpiuQ(i));
    end
end