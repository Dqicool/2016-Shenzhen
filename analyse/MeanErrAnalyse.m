function [ABSMerrIDA, MerrIDA, ABSMerrID, MerrID, ABSMerrPT, MerrPT] = MeanErrAnalyse(InitialDelay, PauseTotal, InitialDataAmong, OOInitialDelay, OOPauseTotal, OOInitialDataAmong)
    ABSMerrIDA  = mean(abs(InitialDataAmong - OOInitialDataAmong) ./ InitialDataAmong);
    ABSMerrID   = mean(abs(InitialDelay     - OOInitialDelay    ) ./ InitialDelay    );
    ABSMerrPT   = mean(abs(PauseTotal       - OOPauseTotal      )                    );
    MerrPT      = mean(-(PauseTotal       - OOPauseTotal        )                    );
    MerrID      = mean(-(InitialDelay     - OOInitialDelay      ) ./ InitialDelay    );
    MerrIDA     = mean(-(InitialDataAmong - OOInitialDataAmong  ) ./ InitialDataAmong);
end