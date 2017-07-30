function ret=Mutation(pmutation,lenchrom,chrom,sizepop,num,maxgen,bound)
    for ii = 1: sizepop
        pick = rand;
        if pick>pmutation
            continue;
        end
        flag = 0;
        while flag == 0 
            pick = rand;
            pos = ceil(pick .* sum(lenchrom));

            pick = rand;
            fg=(rand*(1-num/maxgen))^2;
            if pick>0.5
                chrom(ii,pos)=chrom(ii,pos)+(bound(pos,2)-chrom(ii,pos))*fg;
            else
                chrom(ii,pos)=chrom(ii,pos)-(chrom(ii,pos)-bound(pos,1))*fg;
            end
            flag = 1;
        end
    end
ret = chrom;