function [Population_st,child_size]=elimi_initial1(Population_ch,pop_size,job_num,chrom_length,last_rank,Population_first,m)
%ȥ����Ⱥ���ظ��ĸ��壬����ʼ�����������¸���

%inputs
% Population_st:ѡ��õ��ĸ���

%outputs
% Population_st��ȥ�غͳ�ʼ���ĸ���
if last_rank==1
    [Population_child]=elimination(Population_first,pop_size,m);
else
    [Population_child]=elimination(Population_ch,pop_size,m);
end
[~,index1]=find([Population_child.rank]==0);
[~,col1]=size(index1);
child_size=col1;

if child_size~=0
    %% ��ʼ����Ⱥ����ȥ�صĸ���
    [Population_child1]=initialize_population7(child_size,job_num,chrom_length);
    
    Population_child(pop_size-col1+1:pop_size)=Population_child1;
    Population_st=Population_child;
    [Population_st(1:pop_size).crowded_distance]=deal(0);
else
    Population_st=Population_child(1:pop_size);
end
end