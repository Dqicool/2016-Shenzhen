cc
load data
inputtmp    = [InitialSpeedPeak';PlayAvgSpeed';E2ERTT'];
outputtmp   = [InitialDelay';InitialDataAmong'];
[Inputn,InPs]   = mapminmax(inputtmp);
[Outputn,OutPs] = mapminmax(outputtmp);
%网络结构
InputNum = 3;
OutputNum = 2;
HiddenNum = 5;
%构建网络
net = newff(Inputn,Outputn,HiddenNum);
%遗传算法参数
MaxGen = 50;        %迭代次数
SizePop = 10;       %种群规模
PCross = 0.2;       %交叉概率
PMutation = 0.1;    %变异概率
%节点数量
NumSum = InputNum .* HiddenNum + HiddenNum + HiddenNum .* OutputNum + OutputNum;
LengthChrom = ones(1,NumSum);                           %个体长度
bound = [-3 * ones(NumSum, 1), 3 * ones(NumSum, 1)];    %个体范围
%种族信息struct
Individuals = struct('fitness', zeros(1, SizePop), 'chrom', []);

for ii = 1:SizePop
    Individuals.chrom(ii, :) = Code(LengthChrom, bound); %随机产生一个种群
    x = Individuals.chrom(ii, :);
    Individuals.fitness(ii) = fun(x, InputNum, HiddenNum, OutputNum, net, Inputn, Outputn); %染色体的适应度
end

[BestFitness, BestIndex]=min(Individuals.fitness);
BestChrom   = Individuals.chrom(BestIndex,:);
AvgFitness = mean(Individuals.fitness);

tracee = [AvgFitness, BestFitness];

%进化开始
for ii = 1:MaxGen
    disp(ii)
    
end
