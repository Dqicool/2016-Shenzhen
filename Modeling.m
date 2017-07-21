function [InitialDataAmong, PauseTotal, InitialDelay, PauseCount] = Modeling(E2ERTT, PlayAvgSpeed, InitialSpeedPeak, CodeSpeed, RndCS, TotalAvgSpeed, Replay)
    global DataSize
    DataSize                                            = max(size(CodeSpeed));
    InitialPreDelay                                     = InitialPrepare(E2ERTT, TotalAvgSpeed, InitialSpeedPeak, PlayAvgSpeed);
    [InitialDataAmong ,InitialDelay, DownloadTempPool]  = ModelI(E2ERTT, InitialSpeedPeak, CodeSpeed, TotalAvgSpeed);
    InitialDelay                                        = InitialDelay + InitialPreDelay;
    [PauseTotal, PauseCount]                            = ModelP(DownloadTempPool, PlayAvgSpeed, CodeSpeed, E2ERTT, RndCS, Replay);
end

function InitialPreDelay = InitialPrepare(E2ERTT, TotalAvgSpeed, InitialSpeedPeak, PlayAvgSpeed)
    InitialPreDelay = 2.5 .* E2ERTT;
    adPack          = 4200000;
    InitialPreDelay = InitialPreDelay + adPack ./ (PlayAvgSpeed .* (2 + cpmodel(InitialSpeedPeak,E2ERTT,PlayAvgSpeed))) .* (TotalAvgSpeed >= 380);
end

function [InitialDataAmong, InitialDelay, DownloadTempPool] = ModelI(E2ERTT, InitialSpeedPeak, CodeSpeed, TotalAvgSpeed)
    global DataSize    
    InitialDelay        = zeros(DataSize, 1);
    StartSymbol         = false(DataSize, 1);
    DownloadTempPool    = zeros(DataSize, 1);
    MaxCwnd             = InitialSpeedPeak .* E2ERTT;
    CurrentCwnd         = 20640;                                            %21440 - 800; cwnd1 = 42880
    while sum(StartSymbol) < DataSize
        InitialDelay        = InitialDelay + (~StartSymbol) .* E2ERTT;
        CurrentCwnd         = 2 * CurrentCwnd .* (CurrentCwnd < 0.5 * MaxCwnd) + ...
                              0.75 * MaxCwnd .* (CurrentCwnd >= 0.5 * MaxCwnd);
        CurrentSpeed        = (~StartSymbol) .* CurrentCwnd;
        DownloadTempPool    = DownloadTempPool + CurrentSpeed;
        StartSymbol         = logical((DownloadTempPool > CodeSpeed .* 4000)  + ...
                                      (TotalAvgSpeed < 380) .* (DownloadTempPool > 200 * CodeSpeed));
    end
    InitialDataAmong = DownloadTempPool * 0.129844961240310;
end

function [PauseTotal, PauseCount] = ModelP(DownloadTempPool, PlayAvgSpeed, CodeSpeed, E2ERTT, RndCS, Replay)
    global DataSize
    time                = zeros(DataSize, 1);
    PauseTotal          = zeros(DataSize, 1);
    StartSymbol         = true (DataSize, 1);
    PauseCount          = zeros(DataSize, 1);
    SendT               = 4288 ./ PlayAvgSpeed;                                                    %引入发送时间概念
    FinishSymbol        = false(DataSize, 1);                                                      %播放结束标志
    PkgPRTT             = E2ERTT ./ SendT;
    PkgSend             = ones (DataSize, 1);
    DownloadTempPool    = 4128 .* PkgPRTT;
    while sum(FinishSymbol) < DataSize
        time                = time + SendT;
        PkgSend             = PkgSend + 1;
        FinishSymbol        = (time(end) >= 30000);
        PlayTime            = time - PauseTotal;                                                    %播放时间
        Addins              = 4128 .* (mod(PkgSend, 1e4) > PkgPRTT);                                %4288 - 160
        PlayedOut           = 1.1 .* StartSymbol .* CodeSpeed .* RndCS(1 + fix(PlayTime)) .* SendT;
        DownloadTempPool    = DownloadTempPool - PlayedOut + Addins;
        PauseJudge          = DownloadTempPool < CodeSpeed .* RndCS(1 + fix(PlayTime)) .* SendT;
        PauseCount          = PauseCount +  PauseJudge .* StartSymbol;                              %卡段时间
        StartSymbol         = StartSymbol - PauseJudge .* StartSymbol + ...                         %刚刚开始卡顿的数目
                              (~StartSymbol) .* (DownloadTempPool > Replay .* CodeSpeed);             %卡顿还没有开始的数目
        PauseTotal          = PauseTotal + (~StartSymbol) .* SendT;
    end
end