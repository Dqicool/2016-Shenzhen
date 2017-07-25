function FigurePlot(PlayAvgSpeed, PauseTotal, OOPauseTotal, InitialSpeedPeak, InitialDelay, OOInitialDelay, InitialDataAmong, OOInitialDataAmong, CodeSpeed, PauseCount, OOPauseCount, E2ERTT, VMOS, OOVMOS)
    figure(1);
    plot3(PlayAvgSpeed,   PauseTotal,   PauseCount, 'r. ')
    hold on
    plot3(PlayAvgSpeed, OOPauseTotal, OOPauseCount, 'b. ')
    hold off
    xlabel PlayAvgSpeed;
    ylabel PauseTotal;
    zlabel PauseCount;

    figure(2)
    plot3(E2ERTT, InitialSpeedPeak,   InitialDelay,'r. ')
    hold on
    plot3(E2ERTT, InitialSpeedPeak, OOInitialDelay,'b. ')
    hold off
    xlabel E2ERTT
    ylabel InitialSpeedPeak
    zlabel InitialDelay

    figure(3)
    scatter3(InitialSpeedPeak, InitialDelay - OOInitialDelay, PlayAvgSpeed, 3, abs(InitialDelay - OOInitialDelay) ./ InitialDelay, 'filled');
    colorbar
    xlabel InitialSpeedPeak
    ylabel IDOOID
    caxis([0, 1])

    figure(4)
    scatter(PlayAvgSpeed, PauseCount - OOPauseCount, 'r. ');
    xlabel PlayAvgSpeed
    ylabel PCOOPC

    figure(5)
    scatter(PlayAvgSpeed, PauseTotal - OOPauseTotal, 3, abs(PauseTotal - OOPauseTotal) ./ (1 + PauseTotal), 'filled');
    colorbar
    xlabel PlayAvgSpeed 
    ylabel PTOOPT
    caxis([0, 1])

    figure(6)
    scatter3(InitialSpeedPeak, PlayAvgSpeed, E2ERTT, 3, abs(OOVMOS - VMOS), 'filled')
    xlabel InitialSpeedPeak
    ylabel PlayAvgSpeed
    zlabel E2ERTT
    caxis([0, 1])
    colorbar

    figure(7)
    plot3(PauseTotal, InitialDelay,VMOS,'r.')
    hold on 
    plot3(PauseTotal, InitialDelay,OOVMOS,'b.')
    hold off
    xlabel PauseTotal
    ylabel InitialDelay   

%    figure(3)
%    plot(InitialSpeedPeak,   InitialDataAmong / 8 ./ CodeSpeed,'r. ')
%    hold on
%    plot(InitialSpeedPeak, OOInitialDataAmong / 8 ./ CodeSpeed,'b. ')
%    hold off
%    xlabel InitialSpeedPeak;
%    ylabel InitialDataAmong;

%    figure(4)
%    plot(InitialDelay,   InitialDataAmong / 8 ./ CodeSpeed, 'r. ')
%    hold on
%    plot(InitialDelay, OOInitialDataAmong / 8 ./ CodeSpeed, 'b. ')
%    hold off
%    xlabel InitialDelay;
%    ylabel InitialDataAmong;    

%    figure(5)
%    scatter3(PlayAvgSpeed, PauseTotal, PauseCount, 2, E2ERTT, 'filled')
%    xlabel PlayAvgSpeed
%    ylabel PauseTotal
%    zlabel PauseCount
%    colorbar
%    box on
%   caxis([0,150])

%    figure(6)
%    scatter3(PlayAvgSpeed, OOPauseTotal, OOPauseCount, 2, E2ERTT, 'filled')
%    xlabel PlayAvgSpeed
%    ylabel OOPauseTotal
%    zlabel OOPauseCount
%    colorbar
%    box on
%    caxis([0,150])
end
