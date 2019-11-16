function [Population_st]=initialize_population7(pop_size,job_num,chrom_length)
%GLR��ʼ����Ⱥ(��������)
%��GS�ķ�ʽ����60%�ĸ���,��RS�ķ�ʽ����40%�ĸ���
%inputs
%pop_size:population size (integer)
%job_ope_num:vector of job operations number (veator)
%job_num:the number of jobs(integer)
%chrom_length=3*total_ope_num;     %the length of chromosome
%mach_set_stage:vector of machine set in each stage (matrix,row:machin set,column:stage)
%worker_set_stage:vector of worker set in each stage (matrix,row:worker set,column:stage)
%stage_num=job_ope_num(1,1);       %stage_num:the number of stages,��Ϊÿ�������Ĺ��������Ϊ�׶���

%outputs
%chrom_os:chromosome of operation sequence(OS) (vector)
%chrom_ma:chromosome of machine assignment(MA) (vector)
%chrom_wa:chromosome of worker assignment(WA) (vector)
%Population_st:�ṹ���飬�ֱ������Ⱦɫ�塢������Ϣ��Ŀ��ֵ����֧��ǰ�غ�ӵ������

%%
Population_RS=zeros(1,chrom_length);   %�洢��ȺȾɫ��
Population_st(1:pop_size)=struct('chromesome',[],'decode',[],'pro_time',[],'objectives',[],'load_machine',[],'load_inbalance_ma',0,'load_worker',[],'load_inbalance_wo',0,'rank',0,'critical_path',[],'crowded_distance',0);

%% random vector for chromosome of OS
ii=(1:job_num);
chrom_os_initial= ii;
for i=1:pop_size
    R1=(randperm(job_num));
    chrom_os=chrom_os_initial(1,R1);
    Population_RS(1,1:job_num)=chrom_os;
    Population_st(i).chromesome=Population_RS;
end
end