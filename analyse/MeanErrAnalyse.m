function [ABSMerrIDA, MerrIDA, ABSMerrID, MerrID, ABSMerrPT, MerrPT, ABSMerrVMOS, MerrVMOS] = MeanErrAnalyse(InitialDelay, PauseTotal, InitialDataAmong, OOInitialDelay, OOPauseTotal, OOInitialDataAmong, VMOS, OOVMOS)
    ABSMerrIDA  = mean(abs(InitialDataAmong - OOInitialDataAmong) ./ InitialDataAmong);
    ABSMerrID   = mean(abs(InitialDelay     - OOInitialDelay    ) ./ InitialDelay    );
    ABSMerrPT   = mean(abs(PauseTotal       - OOPauseTotal      )                    );
    MerrPT      = mean(-(PauseTotal       - OOPauseTotal        )                    );
    MerrID      = mean(-(InitialDelay     - OOInitialDelay      ) ./ InitialDelay    );
    MerrIDA     = mean(-(InitialDataAmong - OOInitialDataAmong  ) ./ InitialDataAmong);
    MerrVMOS    = mean(-(VMOS - OOVMOS  ));
    ABSMerrVMOS = mean(abs(VMOS - OOVMOS  ));
end