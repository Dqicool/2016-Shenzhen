cc
load data
inputtmp    = [InitialSpeedPeak';PlayAvgSpeed';E2ERTT'];
outputtmp   = VMOS';
[Inputn,InPs]   = mapminmax(inputtmp);
[Outputn,OutPs] = mapminmax(outputtmp);

net=newff(Inputn,Outputn,[5 5]);

net.trainParam.epochs=89266;
net.trainParam.lr=0.1;
net.trainParam.goal=0.00004;
net.trainParam.max_fail = 20;

net=train(net,Inputn,Outputn);