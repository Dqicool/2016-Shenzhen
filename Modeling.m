function [InitialDataAmong, PauseTotal, InitialDelay, PauseCount] = Modeling(E2ERTT, PlayAvgSpeed, InitialSpeedPeak, CodeSpeed, RndCS, TotalAvgSpeed)
    global DataSize
    DataSize                                            = max(size(CodeSpeed));
    InitialPreDelay                                     = InitialPrepare(E2ERTT, TotalAvgSpeed, InitialSpeedPeak);
    [InitialDataAmong ,InitialDelay, DownloadTempPool]  = ModelI(E2ERTT, InitialSpeedPeak, CodeSpeed, TotalAvgSpeed);
    InitialDelay                                        = InitialDelay + InitialPreDelay;
    [PauseTotal, PauseCount]                            = ModelP(DownloadTempPool, PlayAvgSpeed, CodeSpeed, E2ERTT, RndCS);
end

function InitialPreDelay = InitialPrepare(E2ERTT, TotalAvgSpeed, InitialSpeedPeak)
    InitialPreDelay = 2.5 .* E2ERTT;
    adPack          = 7650000;
    InitialPreDelay = InitialPreDelay + adPack ./ (0.75 .* InitialSpeedPeak) .* (TotalAvgSpeed >= 380);
end

function [InitialDataAmong, InitialDelay, DownloadTempPool] = ModelI(E2ERTT, InitialSpeedPeak, CodeSpeed, TotalAvgSpeed)
    global DataSize    
    InitialDelay        = zeros(DataSize, 1);
    StartSymbol         = false(DataSize, 1);
    DownloadTempPool    = zeros(DataSize, 1);
    MaxCwnd             = InitialSpeedPeak .* E2ERTT;
    CurrentCwnd         = 21440 - 800;                                            %cwnd1 = 42880
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

function [PauseTotal, PauseCount] = ModelP(DownloadTempPool, PlayAvgSpeed, CodeSpeed, E2ERTT, RndCS)
    global DataSize
    time                = 0;
    PauseTotal          = zeros(DataSize, 1);
    StartSymbol         = true (DataSize, 1);
    PauseCount          = zeros(DataSize, 1);
    while time < 30000
        time                = time + 1;
        PlayTime            = time - PauseTotal;                                                                                %播放时间
        DownloadTempPool    = DownloadTempPool - 1.25 .* StartSymbol .* CodeSpeed .* RndCS(PlayTime) + ...                              %减去播放量
                              PlayAvgSpeed .* E2ERTT .* (mod(time, E2ERTT) == 0);                                               %每传输轮次增加下载量
        PauseCount          = PauseCount + (DownloadTempPool < CodeSpeed .* RndCS(PlayTime)) .* StartSymbol;                    %卡段时间
        StartSymbol         = StartSymbol - (DownloadTempPool < CodeSpeed .* RndCS(PlayTime)) .* StartSymbol + ...              %刚刚开始卡顿的数目
                              (~StartSymbol) .* (DownloadTempPool > 2700 .*  CodeSpeed);                           %卡顿还没有开始的数目
        PauseTotal          = PauseTotal + (~StartSymbol);
    end
end