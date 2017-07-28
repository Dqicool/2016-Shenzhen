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
    StartSymbol = true;
    RTTs = E2ERTT;
    RTTd = 0.5 .* E2ERTT;
    time = 0;
    pkg  = 1;
    Pipe = struct('PkgNo',1,'SendTimeStamp',0,'RecTimePre',E2ERTT,'Acked',0);
    SndT = 4288 ./ PlayAvgSpeed;
    PauseCount = 0;
    PauseTotal = 0;
    count = 0;
    while time < 30000
        %一般性新
        count = count + 1;
        PlayTime = time - PauseTotal;
        pkg  = pkg + 1;
        time = time + SndT;
        RTTc = E2ERTT .* Replay(count);
        %新流体点
        Pipe.PkgNo(end + 1) = pkg;
        Pipe.SendTimeStamp(end + 1) = time;
        Pipe.RecTimePre(end + 1) = RTTc;
        Pipe.Acked(end + 1) = 0;
        %新RTO
        RTTs = 0.875 .* RTTs + 0.125 .* RTTc;
        RTTd = 0.75 .* RTTd + 0.25 .* abs(RTTs - RTTc);
        RTO  = RTTs + 4 .* RTTd;
        %考察已接收的包
        Pipe.Acked = (time - Pipe.SendTimeStamp) > Pipe.RecTimePre;
        PkgAddin = find(Pipe.Acked == 0, 1, 'first') - 1; 
        %从流中去掉已经顺序收到的包
        if PkgAddin > 0
            Pipe.PkgNo = Pipe.PkgNo((PkgAddin + 1):end);
            Pipe.SendTimeStamp = Pipe.SendTimeStamp((PkgAddin + 1):end);
            Pipe.RecTimePre = Pipe.RecTimePre((PkgAddin + 1):end);
            Pipe.Acked = Pipe.Acked((PkgAddin + 1):end);
        end
        %考察超时重传和快恢复并对流体进行清零
        if ((time - Pipe.SendTimeStamp(1)) > RTO)
            %Pipe = struct('PkgNo',Pipe.PkgNo(1),'SendTimeStamp',time,'RecTimePre',E2ERTT,'Acked',0);
            Pipe.PkgNo = Pipe.PkgNo(1);
            Pipe.SendTimeStamp = time;
            Pipe.RecTimePre = E2ERTT;
            Pipe.Acked = 0;
            pkg  = Pipe.PkgNo(1);
        end
        %池子变化
        if StartSymbol == true
            DownloadTempPool = DownloadTempPool + PkgAddin .* 4128 - SndT .* CodeSpeed .* RndCS(1 + fix(PlayTime));
        else
            DownloadTempPool = DownloadTempPool + PkgAddin .* 4128;
        end
        %卡顿和重播放判断
        if (DownloadTempPool < CodeSpeed) && StartSymbol == true
            StartSymbol = false;
            PauseCount = PauseCount + 1; 
        elseif (DownloadTempPool > 2700 * CodeSpeed) && (StartSymbol == false)
            StartSymbol = true;
        end
        PauseTotal = PauseTotal + SndT .* (~StartSymbol);
    end
end

