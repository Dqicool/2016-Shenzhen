function [OOSloading, OOSStalling, OOVMOS] = ScorePredict(ID, PT)
    fID         = 1.053e-16 .* ID .^ 4 - 4.156e-12 .* ID .^ 3 + 7.816e-8 .* ID .^ 2 - 0.0008643 .* ID + 4.909;
    OOSloading  = (ID <= 9820) .* (fID > 1) .* fID + (ID > 9820);
    fSS2        = -2.625e-08 .* PT .^ 2 - 0.0006622 .* PT + 5;
    fSS1        = -1.373e-08 .* PT .^ 2 - 0.0001826 .* PT + 2.924;
    OOSStalling = (fSS1 > 2) .* fSS2 + (fSS1 <= 2) .* (fSS1 > 1) .* fSS1 + (fSS1 <= 1);
    x = OOSloading;
    y = OOSStalling;
    fVMOS       = -4.756 + 1.852.*x + 2.057.*y - 0.3178.*x.^2 + 0.008267.*x.*y - 0.3309.*y.^2 + 0.02305.*x.^3 -0.00034.*x.^2.*y - 0.0005279.*x.*y.^2 + 0.02244.*y.^3;
    OOVMOS      = (fVMOS > 1) .* fVMOS + (fVMOS <= 1);
end