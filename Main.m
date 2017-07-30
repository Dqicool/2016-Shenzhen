cc;
load exdata
OOInitialDataAmong  = zeros(max(size(CodeSpeed)), 1);
OOInitialDelay      = zeros(max(size(CodeSpeed)), 1);
OOPauseTotal        = zeros(max(size(CodeSpeed)), 1);
OOPauseCount        = zeros(max(size(CodeSpeed)), 1);
RndCS               = normrnd(1,0.33,60000,1);
RndRTT              = 0.985 + 0.015 .* normrnd(1,1,1,600000);
RndRTTi             = 1 - 2e-5 + 2e-5 .* normrnd(1,1,1,600000);
Replay              = 1000 + 1700 .* cpmodel(InitialSpeedPeak, E2ERTT, PlayAvgSpeed);
tic
    parfor ii = 1:max(size(CodeSpeed))
        [OOInitialDataAmong(ii), OOPauseTotal(ii), OOInitialDelay(ii), OOPauseCount(ii)] = ...
        Modeling(E2ERTT(ii), PlayAvgSpeed(ii), InitialSpeedPeak(ii), CodeSpeed(ii), RndCS, TotalAvgSpeed(ii), RndRTT, Replay(ii), RndRTTi);
        %disp(ii);
    end
toc
clear ii RndCS RndRTT;

[OOSloading, OOSStalling, OOVMOS] = ScorePredict(OOInitialDelay, OOPauseTotal);

FigurePlot(PlayAvgSpeed, PauseTotal, OOPauseTotal, InitialSpeedPeak, InitialDelay, OOInitialDelay, InitialDataAmong, OOInitialDataAmong, CodeSpeed, PauseCount, OOPauseCount, E2ERTT, VMOS, OOVMOS)

[ErrPC, ErrID,ErrPT,ErrIDA] = ...
ErrorAnalyse(PauseCount ,InitialDelay, PauseTotal, InitialDataAmong, OOInitialDelay, OOPauseTotal, OOInitialDataAmong, OOPauseCount)

[ABSMerrIDA, MerrIDA, ABSMerrID, MerrID, ABSMerrPT, MerrPT, ABSMerrVMOS, MerrVMOS] = ...
MeanErrAnalyse(InitialDelay, PauseTotal, InitialDataAmong, OOInitialDelay, OOPauseTotal, OOInitialDataAmong, VMOS, OOVMOS)