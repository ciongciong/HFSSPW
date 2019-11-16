function [mutationPopulation]=mutationPopulateN(Population_st,pop_size,job_num,chrom_length,mutationRate,filenames)
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
    chromesome=mutationPopulation(i).chromesome;
    child=zeros(1,chrom_length);
    %% OS��MA��WA�����
    chrom_os=chromesome(1,1:chrom_length/3);
    chrom_ma=chromesome(1,chrom_length/3+1:2*chrom_length/3);
    chrom_wa=chromesome(1,2*chrom_length/3+1:chrom_length);
    [child_os,child_ma,child_wa]=mutationN(chrom_os,chrom_ma,chrom_wa,job_num,chrom_length,mutationRate,filenames);
    child(1,1:chrom_length/3)=child_os;
    child(1,chrom_length/3+1:2*chrom_length/3)=child_ma;
    child(1,2*chrom_length/3+1:chrom_length)=child_wa;
    mutationPopulation(i).chromesome=child;
end
end