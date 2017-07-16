function [MerrIDA, MerrID, MerrPT] = MeanErrAnalyse(InitialDelay, PauseTotal, InitialDataAmong, OOInitialDelay, OOPauseTotal, OOInitialDataAmong)
    MerrIDA = mean(abs(InitialDataAmong - OOInitialDataAmong)   ./ InitialDataAmong);
    MerrID  = mean(abs(InitialDelay     - OOInitialDelay)       ./ InitialDelay);
    MerrPT  = mean(abs(PauseTotal       - OOPauseTotal));
end