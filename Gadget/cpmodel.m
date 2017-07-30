function final = cpmodel(ISPN1,E2EN1,PASN1)
if ISPN1 <= 10000
InitialSpeedPeakcp = (ISPN1 - 2625) ./ 7371;
E2ERTTcp = (148 - E2EN1) ./ 131;
PlayAvgSpeedcp = (PASN1 - 427) ./ 8090;     %综合评价变量的分量,cp为综合变量的缩写

InitialSpeedPeakwc  = 0.2026;
E2ERTTwc            = 0.4741;
PlayAvgSpeedwc      = 0.3233;
final               = InitialSpeedPeakwc .* InitialSpeedPeakcp + E2ERTTwc .*E2ERTTcp + PlayAvgSpeedwc .* PlayAvgSpeedcp;
else
InitialSpeedPeakcp = (ISPN1 - 10002) ./ 149223;
E2ERTTcp = (149 - E2EN1) ./ 134;
PlayAvgSpeedcp = (PASN1 - 420) ./ 30199;     %综合评价变量的分量,cp为综合变量的缩写

InitialSpeedPeakwc  = 0.1880;
E2ERTTwc            = 0.6015;
PlayAvgSpeedwc      = 0.2105;
final               = InitialSpeedPeakwc .* InitialSpeedPeakcp + E2ERTTwc .*E2ERTTcp + PlayAvgSpeedwc .* PlayAvgSpeedcp;

end
final               = (final + 0.0037)/0.7654;
end