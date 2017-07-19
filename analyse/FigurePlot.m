function FigurePlot(PlayAvgSpeed, PauseTotal, OOPauseTotal, InitialSpeedPeak, InitialDelay, OOInitialDelay, InitialDataAmong, OOInitialDataAmong, CodeSpeed, PauseCount, OOPauseCount, E2ERTT)
    figure(1);
    plot3(PlayAvgSpeed,   PauseTotal,   PauseCount, 'r. ')
    hold on
    plot3(PlayAvgSpeed, OOPauseTotal, OOPauseCount, 'b. ')
    hold off
    xlabel PlayAvgSpeed;
    ylabel PauseTotal;
    zlabel PauseCount;

    figure(2)
    plot3(PlayAvgSpeed, InitialSpeedPeak,   InitialDelay,'r. ')
    hold on
    plot3(PlayAvgSpeed, InitialSpeedPeak, OOInitialDelay,'b. ')
    hold off
    xlabel PlayAvgSpeed
    ylabel InitialSpeedPeak;
    zlabel InitialDelay;


    figure(3)
    plot(InitialSpeedPeak,   InitialDataAmong / 8 ./ CodeSpeed,'r. ')
    hold on
    plot(InitialSpeedPeak, OOInitialDataAmong / 8 ./ CodeSpeed,'b. ')
    hold off
    xlabel InitialSpeedPeak;
    ylabel InitialDataAmong;

    figure(4)
    plot(InitialDelay,   InitialDataAmong / 8 ./ CodeSpeed, 'r. ')
    hold on
    plot(InitialDelay, OOInitialDataAmong / 8 ./ CodeSpeed, 'b. ')
    hold off
    xlabel InitialDelay;
    ylabel InitialDataAmong;    

    figure(5)
    scatter3(PlayAvgSpeed, PauseTotal, PauseCount, 2, E2ERTT, 'filled')
    xlabel PlayAvgSpeed
    ylabel PauseTotal
    zlabel PauseCount
    colorbar
    box on
    caxis([0,150])

    figure(6)
    scatter3(PlayAvgSpeed, OOPauseTotal, OOPauseCount, 2, E2ERTT, 'filled')
    xlabel PlayAvgSpeed
    ylabel OOPauseTotal
    zlabel OOPauseCount
    colorbar
    box on
    caxis([0,150])
end
