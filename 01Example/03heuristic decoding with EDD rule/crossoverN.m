function [child1,child2,flag] = crossoverN(chrom1,chrom2,job_num,stage_num,chrom_length,crossRate)
%crossover operators

%inputs
% chrom1:��������1
% chrom2:��������2
% job_num:the number of jobs(integer)
% chrom_length=3*total_ope_num;     %the length of chromosome
% stage_num=job_ope_num(1,1);       %stage_num:the number of stages,��Ϊÿ�������Ĺ��������Ϊ�׶���
% crossRate:the rate of crossover

%outputs
%child1:get offspring1 by crossover operators
%child2:get offspring2 by crossover operators

child1=chrom1;
child2=chrom2;

chrom1_os=chrom1(1,1:chrom_length/3);  %OS��
chrom1_ma=chrom1(1,chrom_length/3+1:2*chrom_length/3);  %MA��
chrom1_wa=chrom1(1,2*chrom_length/3+1:chrom_length);    %WA��
chrom2_os=chrom2(1,1:chrom_length/3);  %OS��
chrom2_ma=chrom2(1,chrom_length/3+1:2*chrom_length/3);  %MA��
chrom2_wa=chrom2(1,2*chrom_length/3+1:chrom_length);    %WA��
flag=false;
if rand<crossRate;
    %% OS�㽻��
    stage_rank=unidrnd(stage_num);
    chrom1_os_stage=chrom1_os(1,(stage_rank-1)*job_num+1:stage_rank*job_num);                   %OS��
    chrom2_os_stage=chrom2_os(1,(stage_rank-1)*job_num+1:stage_rank*job_num);                   %OS��
      
    ii=randperm(job_num,2);   %���ȡһ�θ����������Ƭ��
    max_pos=max(ii);
    min_pos=min(ii);
    chrom1_os_vector=chrom1_os_stage;
    chrom2_os_vector=chrom2_os_stage;
    for i=min_pos:max_pos
        chrom1_os_vector(find(chrom1_os_vector==chrom2_os_stage(i),1))=0;   %����������1��Ӹ�������2��ȡ�Ļ���Ƭ����ͬ��λ����0
        chrom2_os_vector(find(chrom2_os_vector==chrom1_os_stage(i),1))=0;
    end
    for i=min_pos:max_pos
        chrom1_os_vector(find(chrom1_os_vector==0,1))=chrom2_os_stage(i);   %����˳�򽫴Ӹ���2��ȡ�Ļ���Ƭ�η��븸��1��0λ��
        chrom2_os_vector(find(chrom2_os_vector==0,1))=chrom1_os_stage(i);
    end
    chrom1_os(1,(stage_rank-1)*job_num+1:stage_rank*job_num)=chrom1_os_vector;
    chrom2_os(1,(stage_rank-1)*job_num+1:stage_rank*job_num)=chrom2_os_vector;
    child1(1,1:chrom_length/3)=chrom1_os;   %�����Ӵ�����
    child2(1,1:chrom_length/3)=chrom2_os;
    
    
    %% MA�㽻��
    stage_rank_ma=unidrnd(stage_num);
    chrom1_ma_stage=chrom1_ma(1,(stage_rank_ma-1)*job_num+1:stage_rank_ma*job_num);                   %MA��
    chrom2_ma_stage=chrom2_ma(1,(stage_rank_ma-1)*job_num+1:stage_rank_ma*job_num);
    chrom1_ma_vector=chrom1_ma_stage;
    chrom2_ma_vector=chrom2_ma_stage;
    ii=randperm(job_num,2);   %���ȡһ�θ����������Ƭ��
    max_pos=max(ii);
    min_pos=min(ii);
    chrom1_ma_vector(min_pos:max_pos)=chrom2_ma_stage(min_pos:max_pos);
    chrom2_ma_vector(min_pos:max_pos)=chrom1_ma_stage(min_pos:max_pos);
    if min_pos~=1 && max_pos~=job_num
        chrom1_ma_vector(1:min_pos-1)=chrom1_ma_stage(1:min_pos-1);
        chrom1_ma_vector(min_pos+1:end)=chrom1_ma_stage(min_pos+1:end);
        chrom2_ma_vector(1:min_pos-1)=chrom2_ma_stage(1:min_pos-1);
        chrom2_ma_vector(min_pos+1:end)=chrom2_ma_stage(min_pos+1:end);
    elseif min_pos~=1 && max_pos==job_num
        chrom1_ma_vector(1:min_pos-1)=chrom1_ma_stage(1:min_pos-1);
        chrom2_ma_vector(1:min_pos-1)=chrom2_ma_stage(1:min_pos-1);
    elseif min_pos==1 && max_pos~=job_num
        chrom1_ma_vector(min_pos+1:end)=chrom1_ma_stage(min_pos+1:end);
        chrom2_ma_vector(min_pos+1:end)=chrom2_ma_stage(min_pos+1:end);
    end
    chrom1_ma(1,(stage_rank_ma-1)*job_num+1:stage_rank_ma*job_num)=chrom1_ma_vector;
    chrom2_ma(1,(stage_rank_ma-1)*job_num+1:stage_rank_ma*job_num)=chrom2_ma_vector;
    child1(1,chrom_length/3+1:2*chrom_length/3)=chrom1_ma;   %�����Ӵ�����
    child2(1,chrom_length/3+1:2*chrom_length/3)=chrom2_ma;
    %% WA�㽻��
    stage_rank_wa=unidrnd(stage_num);
    chrom1_wa_stage=chrom1_wa(1,(stage_rank_wa-1)*job_num+1:stage_rank_wa*job_num);                   %WA��
    chrom2_wa_stage=chrom2_wa(1,(stage_rank_wa-1)*job_num+1:stage_rank_wa*job_num);
    chrom1_wa_vector=chrom1_wa_stage;
    chrom2_wa_vector=chrom2_wa_stage;
    iii=randperm(job_num,2);   %���ȡһ�θ����������Ƭ��
    max_pos1=max(iii);
    min_pos1=min(iii);
    chrom1_wa_vector(min_pos1:max_pos1)=chrom2_wa_stage(min_pos1:max_pos1);
    chrom2_wa_vector(min_pos1:max_pos1)=chrom1_wa_stage(min_pos1:max_pos1);
    if min_pos1~=1 && max_pos1~=job_num
        chrom1_wa_vector(1:min_pos1-1)=chrom1_wa_stage(1:min_pos1-1);
        chrom1_wa_vector(min_pos1+1:end)=chrom1_wa_stage(min_pos1+1:end);
        chrom2_wa_vector(1:min_pos1-1)=chrom2_wa_stage(1:min_pos1-1);
        chrom2_wa_vector(min_pos1+1:end)=chrom2_wa_stage(min_pos1+1:end);
    elseif min_pos1~=1 && max_pos1==job_num
        chrom1_wa_vector(1:min_pos1-1)=chrom1_wa_stage(1:min_pos1-1);
        chrom2_wa_vector(1:min_pos1-1)=chrom2_wa_stage(1:min_pos1-1);
    elseif min_pos1==1 && max_pos1~=job_num
        chrom1_wa_vector(min_pos1+1:end)=chrom1_wa_stage(min_pos1+1:end);
        chrom2_wa_vector(min_pos1+1:end)=chrom2_wa_stage(min_pos1+1:end);
    end
    chrom1_wa(1,(stage_rank_wa-1)*job_num+1:stage_rank_wa*job_num)=chrom1_wa_vector;
    chrom2_wa(1,(stage_rank_wa-1)*job_num+1:stage_rank_wa*job_num)=chrom2_wa_vector;
    child1(1,2*chrom_length/3+1:chrom_length)=chrom1_wa;   %�����Ӵ�����
    child2(1,2*chrom_length/3+1:chrom_length)=chrom2_wa;

    flag=true;
end
end