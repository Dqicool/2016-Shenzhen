function OOVMOS = VmosPre(RTT, ISP, PAS)
    load net
    inputtmp = [ISP'; PAS'; RTT'];
    inputn   = mapminmax('apply', inputtmp, InPs);
    an = sim(net, inputn);
    OOVMOS = mapminmax('reverse', an, OutPs);
    OOVMOS = OOVMOS';
end