function [InitialDataAmong, PauseTotal, InitialDelay, PauseCount] = Modeling(E2ERTT, PlayAvgSpeed, InitialSpeedPeak, CodeSpeed, RndCS, TotalAvgSpeed, RndRTT, Replay, RndRTTi)
    global DataSize
    DataSize                                            = max(size(CodeSpeed));
    InitialPreDelay                                     = InitialPrepare(E2ERTT, TotalAvgSpeed, InitialSpeedPeak, PlayAvgSpeed);
    [InitialDataAmong ,InitialDelay, DownloadTempPool]  = ModelI(E2ERTT, InitialSpeedPeak, CodeSpeed, TotalAvgSpeed, RndRTTi, PlayAvgSpeed);
    InitialDelay                                        = InitialDelay + InitialPreDelay;
    [PauseTotal, PauseCount]                            = ModelP(DownloadTempPool, PlayAvgSpeed, CodeSpeed, E2ERTT, RndCS, RndRTT, Replay);
end

function InitialPreDelay = InitialPrepare(E2ERTT, TotalAvgSpeed, InitialSpeedPeak, PlayAvgSpeed)
    InitialPreDelay = 5 .* E2ERTT;                                          %获取视频信息时延（广告+视频）
    adPack          = 10485760;                                             %广告总缓冲量
    Speedtmp        = PlayAvgSpeed .* 5;                                    %广告缓冲速度
    InitialPreDelay = InitialPreDelay + (adPack ./ Speedtmp) .* (TotalAvgSpeed >= 380);
                                                                            %预缓冲阶段总时长
end

function [InitialDataAmong, InitialDelay, DownloadTempPool] = ModelI(E2ERTT, InitialSpeedPeak, CodeSpeed, TotalAvgSpeed, RndRTTi, PlayAvgSpeed)
    StartSymbol = false;                                                    %引入初始缓冲阶段结束标志
    RTTs = E2ERTT;                                                          %平滑E2ERTT的初始值
    RTTd = 0.5 .* E2ERTT;                                                   %E2ERTT误差的加权平均值的初始值
    time = 0;                                                               %定义初始缓冲阶段计时器
    pkg  = 1;                                                               %定义数据包序号
    pkgMax = InitialSpeedPeak * E2ERTT / 12000;                             %确定最大接收窗口
    pkgCurrent = 6;                                                         %拥塞窗口初值
    Pipe = struct('PkgNo',1,'SendTimeStamp',0,'RecTimePre',E2ERTT,'Acked',0);
                                                                            %以结构体表示管道模型中各个数据包的特征（标号、时间戳、预期到达时间、抽到信号）
    InitialDelay = 0;                                                       %定义初始缓冲时长
    count = 0;                                                              %定义循环计数器
    DownloadTempPool = 0;                                                   %定义缓冲池
    while StartSymbol == 0
        count = count + 1;                                                  %循环计数器计数
        if pkgCurrent - (Pipe.PkgNo(end) - Pipe.PkgNo(1)) > 0               %判断发送窗口是否还有剩余空间
            SndT = E2ERTT / pkgCurrent;
            time = time + SndT;                                             %即将发送的数据包的序号
            RTTc = E2ERTT .* RndRTTi(count);                                %即将发送的数据包的环回时间
                                                                            %考察这段时间内管道中的数据包
            Pipe.PkgNo(end + 1) = pkg;                                      
            Pipe.SendTimeStamp(end + 1) = time;
            Pipe.RecTimePre(end + 1) = RTTc;
            Pipe.Acked(end + 1) = 0;
                                                                            %计算新的超时重传时间
            RTTs = 0.875 .* RTTs + 0.125 .* RTTc;
            RTTd = 0.75 .* RTTd + 0.25 .* abs(RTTs - RTTc);
            RTO  = RTTs + 4 .* RTTd;
        else 
            time = Pipe.SendTimeStamp(1) + Pipe.RecTimePre(1);              %如果发送窗口没有剩余空间，将计时器进到管子中序号最小的数据包的ACK到达服务器时
        end
                                                                            %考察已接收的数据包
        Pipe.Acked = (time >= Pipe.RecTimePre + Pipe.SendTimeStamp);
        PkgAddin = find(Pipe.Acked == 0, 1, 'first') - 1; 
                                                                            %从流中去掉已经顺序收到的数据包
        if PkgAddin > 0
            Pipe.PkgNo = Pipe.PkgNo((PkgAddin + 1):end);
            Pipe.SendTimeStamp = Pipe.SendTimeStamp((PkgAddin + 1):end);
            Pipe.RecTimePre = Pipe.RecTimePre((PkgAddin + 1):end);
            Pipe.Acked = Pipe.Acked((PkgAddin + 1):end);
                                                                            %更改现在的窗口大小
            if pkgCurrent < 0.5 * pkgMax
                pkgCurrent = pkgCurrent + PkgAddin ;
            elseif (pkgCurrent >= 0.5 * pkgMax) && (pkgCurrent < pkgMax)
                pkgCurrent = pkgCurrent + PkgAddin / pkgCurrent ;
            else
                pkgCurrent = 0.5 * pkgCurrent;
            end
        end
                                                                            %考察超时重传和快恢复并对流体进行清零
        if ((time - Pipe.SendTimeStamp(1)) > RTO)
            Pipe.PkgNo = Pipe.PkgNo(1);
            Pipe.SendTimeStamp = time;
            Pipe.RecTimePre = E2ERTT;
            Pipe.Acked = 0;
            pkg  = Pipe.PkgNo(1);
            pkgCurrent = 6;                                                 %拥塞窗口恢复至初值
        end
                                                                            %缓冲池变化
        DownloadTempPool = DownloadTempPool + PkgAddin .* 11680 .* (~StartSymbol);
                                                                            %初始缓冲结束判断
        StartSymbol = logical((DownloadTempPool > CodeSpeed .* 4000)  + ...
                            (TotalAvgSpeed < 380) .* (DownloadTempPool > 200 * CodeSpeed));
        InitialDelay = time;
    end
    InitialDataAmong = (DownloadTempPool + 0.5 * pkgCurrent * 11680) * 0.1284246575342466;
                                                                            %初始缓冲下载数据量
end

function [PauseTotal, PauseCount] = ModelP(DownloadTempPool, PlayAvgSpeed, CodeSpeed, E2ERTT, RndCS, RndRTT, Replay)
    StartSymbol = true;                                                     %引入播放开始标志
    RTTs = E2ERTT;                                                          %平滑E2ERTT的初始值
    RTTd = 0.5 .* E2ERTT;                                                   %E2ERTT误差的加权平均值
    time = 0;                                                               %播放总时间
    pkg  = 1;                                                               %发包数
    Pipe = struct('PkgNo',1,'SendTimeStamp',0,'RecTimePre',E2ERTT,'Acked',0);
                                                                            %以结构体表示管道模型中各个数据包的特征（标号、时间戳、预期到达时间、抽到信号）
    SndT = 4288 ./ PlayAvgSpeed;                                            %发送间隔
    PauseCount = 0;                                                         %卡顿次数
    PauseTotal = 0;                                                         %卡顿总时长
    count = 0;                                                              %标号
    while time < 30000
        if DownloadTempPool < 29660000
            count = count + 1;
            PlayTime = time - PauseTotal;                                   %播放时长
            pkg  = pkg + 1;
            time = time + SndT;
            RTTc = E2ERTT .* RndRTT(count);
                                                                            %考察这段时间内管道中的数据包
            Pipe.PkgNo(end + 1)         = pkg;
            Pipe.SendTimeStamp(end + 1) = time;
            Pipe.RecTimePre(end + 1)    = RTTc;
            Pipe.Acked(end + 1)         = 0;
                                                                            %重新计算RTO
            RTTs                    = 0.875 .* RTTs + 0.125 .* RTTc;
            RTTd                    = 0.75 .* RTTd + 0.25 .* abs(RTTs - RTTc);
            RTO                     = RTTs + 4 .* RTTd;
                                                                            %考察已接收的包
            Pipe.Acked              = (time - Pipe.SendTimeStamp) > Pipe.RecTimePre;
                                                                            %判断管中的包是否被及时接收
            PkgAddin                = find(Pipe.Acked == 0, 1, 'first') - 1;%该发送间隔内成功接收的数据包数量
                                                                            %从管道中去掉已顺序收到的包
            if PkgAddin > 0
                Pipe.PkgNo          = Pipe.PkgNo((PkgAddin + 1):end);
                Pipe.SendTimeStamp  = Pipe.SendTimeStamp((PkgAddin + 1):end);
                Pipe.RecTimePre     = Pipe.RecTimePre((PkgAddin + 1):end);
                Pipe.Acked          = Pipe.Acked((PkgAddin + 1):end);
            end
                                                                            %考察超时重传
            if ((time - Pipe.SendTimeStamp(1)) > RTO)
                Pipe.PkgNo          = Pipe.PkgNo(1);
                Pipe.SendTimeStamp  = time;
                Pipe.RecTimePre     = E2ERTT;
                Pipe.Acked          = 0;
                pkg                 = Pipe.PkgNo(1);
            end
                                                                            %考察缓冲池中数据量的变化
            DownloadTempPool    =   DownloadTempPool + PkgAddin .* 4128 - ...
                                    StartSymbol .* SndT .* CodeSpeed .* RndCS(1 + fix(PlayTime));
                                                                            %卡顿和播放判断
            PauseJudge          =   DownloadTempPool < CodeSpeed .* SndT;
            ReplayJudge         =   (DownloadTempPool > Replay .* CodeSpeed);
            PauseCount          =   PauseCount +  PauseJudge .* StartSymbol;
            StartSymbol         =   StartSymbol - PauseJudge .* StartSymbol + (~StartSymbol) .* ReplayJudge;
            PauseTotal          =   PauseTotal + SndT .* (~StartSymbol);
        else
            time = 30000;
        end
    end
end