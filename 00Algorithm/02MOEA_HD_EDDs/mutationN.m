function [child1,flag]=mutationN(chrom1,job_num,stage_num,chrom_length,mutationRate)
%OS�����

%inputs
% chrom_os: ����OS��Ⱦɫ��
% chrom_length��Ⱦɫ�峤��
% mutationRate���������

%outputs
% child_os���Ӵ�OS��Ⱦɫ��
chrom1_os=chrom1(1,1:chrom_length/3);  %OS��
chrom1_ma=chrom1(1,chrom_length/3+1:2*chrom_length/3);  %MA��
chrom1_wa=chrom1(1,2*chrom_length/3+1:chrom_length);    %WA��
child1 = chrom1;
flag=false;
if rand<mutationRate
    %% OS�����
    stage_rank=unidrnd(stage_num);
    chrom_os_stage=chrom1_os(1,(stage_rank-1)*job_num+1:stage_rank*job_num);
    number11=unidrnd(job_num);
    number21=unidrnd(job_num);
    while number11==number21
        number21=unidrnd(job_num);
    end
    integer1=chrom_os_stage(1,number11);
    integer2=chrom_os_stage(1,number21);
    chrom_os_stage(1,number21)=integer1;
    chrom_os_stage(1,number11)=integer2;
    child1(1,0+(stage_rank-1)*job_num+1:0+stage_rank*job_num) = chrom_os_stage;
    
    %% MA�����
    stage_rank=unidrnd(stage_num);
    chrom_ma_stage=chrom1_ma(1,(stage_rank-1)*job_num+1:stage_rank*job_num);
    number12=unidrnd(job_num);
    number22=unidrnd(job_num);
    while number12==number22
        number22=unidrnd(job_num);
    end
    integer1=chrom_ma_stage(1,number12);
    integer2=chrom_ma_stage(1,number22);
    chrom_ma_stage(1,number22)=integer1;
    chrom_ma_stage(1,number12)=integer2;
    child1(1,chrom_length/3+(stage_rank-1)*job_num+1:chrom_length/3+stage_rank*job_num) = chrom_ma_stage;
    
    %% WA�����
    stage_rank=unidrnd(stage_num);
    chrom_wa_stage=chrom1_wa(1,(stage_rank-1)*job_num+1:stage_rank*job_num);
    number13=unidrnd(job_num);
    number23=unidrnd(job_num);
    while number13==number23
        number23=unidrnd(job_num);
    end
    integer1=chrom_wa_stage(1,number13);
    integer2=chrom_wa_stage(1,number23);
    chrom_wa_stage(1,number23)=integer1;
    chrom_wa_stage(1,number13)=integer2;
    child1(1,2*chrom_length/3+(stage_rank-1)*job_num+1:2*chrom_length/3+stage_rank*job_num) = chrom_wa_stage;
    flag=true;
end
end