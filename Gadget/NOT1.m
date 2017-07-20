cc
load data
t = 1;
for ii = 1:89266
    if VMOS(ii) > 1
        E2EN1(t) = E2ERTT(ii);
        ISPN1(t) = InitialSpeedPeak(ii);
        PASN1(t) = PlayAvgSpeed(ii);
        VMOSN1(t) = VMOS(ii);
        t = t + 1;
    end
end
E2EN1    = (E2EN1 - mean(E2EN1))./var(E2EN1).^(1/2);
ISPN1    = (ISPN1 - mean(ISPN1))./var(ISPN1).^(1/2);
PASN1    = (PASN1 - mean(PASN1))./var(PASN1).^(1/2);