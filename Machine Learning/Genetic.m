cc
load data
inputtmp    = [InitialSpeedPeak';PlayAvgSpeed';E2ERTT'];
outputtmp   = VMOS';
[Inputn,InPs]   = mapminmax(inputtmp);
[Outputn,OutPs] = mapminmax(outputtmp);
%网络结构
InputNum = 3;
OutputNum = 1;
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
    %选择
    Individuals = Select(Individuals,SizePop);
    AvgFitness = mean(Individuals.fitness);
    %交叉
    Individuals.chrom=Cross(PCross,LengthChrom,Individuals.chrom,SizePop,bound);
    %变异
    Individuals.chrom=Mutation(PMutation,LengthChrom,Individuals.chrom,SizePop,ii,MaxGen,bound);
    for j=1:SizePop
        x=Individuals.chrom(j,:); %解码
        Individuals.fitness(j)=fun(x,InputNum,HiddenNum,OutputNum,net,Inputn,Outputn);   
    end
    [newbestfitness,newbestindex]=min(Individuals.fitness);
    [worestfitness,worestindex]=max(Individuals.fitness);
    % 代替上一次进化中最好的染色体
    if BestFitness>newbestfitness
        BestFitness=newbestfitness;
        BestChrom=Individuals.chrom(newbestindex,:);
    end
    Individuals.chrom(worestindex,:)=BestChrom;
    Individuals.fitness(worestindex)=BestFitness;
    
    AvgFitness=mean(Individuals.fitness);
    
    tracee=[tracee;AvgFitness BestFitness];
end