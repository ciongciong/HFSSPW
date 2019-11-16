function [mutationPopulation]=mutationPopulateN(Population_st,pop_size,job_num,stage_num,chrom_length,mutationRate)
% ����������¸���

%inputs
% Population_st;c��ʼ������Ⱥ
% pop_size����Ⱥ��ģ
% job_num;������
% chrom_length;Ⱦɫ�峤��
% stage_num;�ӹ��׶���
% mutationRate;�������

%outputs
% mutationPopulation:��������Ⱥ

mutationPopulation=Population_st;
for i=1:pop_size                             %��֤����ĸ��嶼�������²���
    chrom1=mutationPopulation(i).chromesome;
    %% OS����
    [child1,flag]=mutationN(chrom1,job_num,stage_num,chrom_length,mutationRate);
    mutationPopulation(i).chromesome=child1;
    mutationPopulation(i).cross_f = flag;
end
end