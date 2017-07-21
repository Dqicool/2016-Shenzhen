cc
load data
load 80000score
t = 1;
for ii = 1:89266
    if VMOS(ii) > 1
        E2EN1(t) = E2ERTT(ii);
        ISPN1(t) = InitialSpeedPeak(ii);
        PASN1(t) = PlayAvgSpeed(ii);
        VMOSN1(t) = VMOS(ii);
        IDN1(t) = InitialDelay(ii);
        PCN1(t) = PauseCount(ii);
        PTN1(t) = PauseTotal(ii);
        SLN1(t) = SLoading(ii);
        SSN1(t) = Sstalling(ii);
        t = t + 1;
    end
end
clear TotalAvgSpeed ii t E2ERTT InitialSpeedPeak PlayAvgSpeed VMOS InitialDelay PauseCount PauseTotal SLoading Sstalling CodeSpeed InitialDataAmong