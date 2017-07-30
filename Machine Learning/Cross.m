function ret = Cross(PCross, LengthChrom, Chrom, SizePop, Bound)
    for ii = 1:SizePop
        pick = rand(1,2);               %
        Index = ceil(pick .* SizePop);
        pick = rand();
        if pick > PCross
            continue;
        end
        flag =0;
        while flag ==0 
            pick = rand();
            pos = ceil(pick .* sum(LengthChrom));
            pick =rand();
            v1 = Chrom(Index(1),pos);
            v2  = Chrom(Index(2),pos);
            Chrom(Index(1),pos)=pick*v2+(1-pick)*v1;
            Chrom(Index(2),pos)=pick*v1+(1-pick)*v2;
            flag = 1;
        end
    end
    ret = Chrom;
end