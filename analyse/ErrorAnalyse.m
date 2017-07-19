function [ErrPC, ErrID,ErrPT,ErrIDA] = ErrorAnalyse(PauseCount ,InitialDelay, PauseTotal, InitialDataAmong, OOInitialDelay, OOPauseTotal, OOInitialDataAmong, OOPauseCount)
%ID is for InitialDelay
%PT is for PauseTotal
%IDA is for InitialDataAmong
    DataSize    = max(size(InitialDelay));
    ABSTmpID    = abs(OOInitialDelay     - InitialDelay);
    ABSTmpPT    = abs(OOPauseTotal       - PauseTotal);
    ABSTmpIDA   = abs(OOInitialDataAmong - InitialDataAmong);


    ErrID       = [sum(ABSTmpID     ./ InitialDelay     < 0.05) ./ DataSize; 
                   sum(ABSTmpID     ./ InitialDelay     < 0.10) ./ DataSize;
                   sum(ABSTmpID     ./ InitialDelay     < 0.20) ./ DataSize;
                   sum(ABSTmpID     ./ InitialDelay     < 0.40) ./ DataSize;
                   sum(ABSTmpID     ./ InitialDelay     < 0.80) ./ DataSize];

    ErrPT       = [sum((ABSTmpPT                        <  100)); 
                   sum((ABSTmpPT                        <  200));
                   sum((ABSTmpPT                        <  400));
                   sum((ABSTmpPT                        <  800));
                   sum((ABSTmpPT                        <  1600))];

    ErrIDA      = [sum(ABSTmpIDA    ./ InitialDataAmong < 0.05) ./ DataSize; 
                   sum(ABSTmpIDA    ./ InitialDataAmong < 0.10) ./ DataSize;
                   sum(ABSTmpIDA    ./ InitialDataAmong < 0.20) ./ DataSize;
                   sum(ABSTmpIDA    ./ InitialDataAmong < 0.40) ./ DataSize;
                   sum(ABSTmpIDA    ./ InitialDataAmong < 0.80) ./ DataSize];
    
    ErrPC       = [ 0, sum((PauseCount ~= 0) .* (OOPauseCount ~= 0) .* (PauseCount == OOPauseCount)); %所有卡顿时间不为零
                    0, sum((PauseCount == 0) .* (OOPauseCount == 0));
                    1, sum((PauseCount - OOPauseCount ==  1));
                   -1, sum((PauseCount - OOPauseCount == -1));
                    2, sum((PauseCount - OOPauseCount ==  2));
                   -2, sum((PauseCount - OOPauseCount == -2));
                    3, sum((PauseCount - OOPauseCount ==  3));
                   -3, sum((PauseCount - OOPauseCount == -3));
                    4, sum((PauseCount - OOPauseCount ==  4));
                   -4, sum((PauseCount - OOPauseCount == -4));
                    5, sum((PauseCount - OOPauseCount ==  5));
                   -5, sum((PauseCount - OOPauseCount == -5));
                    6, sum((PauseCount - OOPauseCount ==  6));
                   -6, sum((PauseCount - OOPauseCount == -6));
                    7, sum((PauseCount - OOPauseCount ==  7));
                   -7, sum((PauseCount - OOPauseCount == -7));
                    8, sum((PauseCount - OOPauseCount ==  8));
                   -8, sum((PauseCount - OOPauseCount == -8));
                    9, sum((PauseCount - OOPauseCount ==  9));
                   -9, sum((PauseCount - OOPauseCount == -9))];
end