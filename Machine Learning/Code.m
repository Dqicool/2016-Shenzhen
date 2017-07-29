function ret = Code(LengthChrom, Bound)
    flag = 0;
    while flag == 0
        tmp = rand(1,length(LengthChrom));
        ret = Bound(:,1)' + (Bound(:,2)' - Bound(:, 1)') .* tmp;
        flag = test(LengthChrom,Bound,ret);
    end
end