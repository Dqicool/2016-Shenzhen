cc
load data
inputtmp    = [InitialSpeedPeak';PlayAvgSpeed';E2ERTT'];
outputtmp   = [InitialDelay';InitialDataAmong'];
[inputn,inps]   = mapminmax(inputtmp);
[outputn,outps] = mapminmax(outputtmp);
net         = newff(inputn,outputn,[5 5 5]);

net.trainParam.epochs   = 89266;
net.trainParam.lr       = 0.00001;
net.trainParam.goal     = 0.00000001;
net.trainParam.max_fail = 50;

net         = train(net,inputn,outputn);

load exdata
intesttmp   = [InitialSpeedPeak';PlayAvgSpeed';E2ERTT'];
outtesttmp  = [InitialDelay';InitialDataAmong'];
intest      = mapminmax('apply',intesttmp,inps);
outtest     = mapminmax('apply',outtesttmp,outps);
anss        = sim(net, intest);
bpout       = mapminmax('reverse', anss, outps);
OOInitialDelay = bpout(1,:);
OOIintialDataAmong = bpout(2,:);
plot(InitialSpeedPeak, InitialDelay,'b.');
hold on
plot(InitialSpeedPeak, OOInitialDelay,'r.');
hold off
mean((InitialDelay - OOInitialDelay')./InitialDelay)