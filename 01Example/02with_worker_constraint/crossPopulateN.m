function [crossPopulation]=crossPopulateN(Population_st,pop_size,job_num,chrom_length,crossRate)
%new population by crossover operators

%inputs
%Population_st:initialized population
%pop_size:population size (integer)
%job_num:the number of jobs(integer)
%chrom_length=3*total_ope_num;     %the length of chromosome
% stage_num=job_ope_num(1,1);       %stage_num:the number of stages,��Ϊÿ�������Ĺ��������Ϊ�׶���
%crossRate:the rate of crossover

%outputs
%crossPopulation:new population by crossover operators

crossPopulation=Population_st; 
for i=1:pop_size
    number1=unidrnd(pop_size);
    number2=unidrnd(pop_size);
    while number1==number2
        number2=unidrnd(pop_size);
    end
    chrom1=crossPopulation(number1).chromesome(1:chrom_length);     %���ȡ������������
    chrom2=crossPopulation(number2).chromesome(1:chrom_length);
    [child1,child2]=crossoverN(chrom1,chrom2,job_num,chrom_length,crossRate);
    crossPopulation(number1).chromesome(1:chrom_length)=child1;
    crossPopulation(number2).chromesome(1:chrom_length)=child2;
end
end