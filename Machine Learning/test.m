function flag = test(LengthChrom, Bound, code)
    x = code;
    flag = 1;
    if (x(1)<0)&&(x(2)<0)&&(x(3)<0)&&(x(1)>Bound(1,2))&&(x(2)>Bound(2,2))&&(x(3)>Bound(3,2))
        flag=0;
    end   
end