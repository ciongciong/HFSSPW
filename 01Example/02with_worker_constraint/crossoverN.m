function [child1,child2] = crossoverN(chrom1,chrom2,job_num,chrom_length,crossRate)
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

child1=zeros(1,chrom_length);    %generate two offsetings
child2=zeros(1,chrom_length);
child1_ma=child1(1,chrom_length/3+1:chrom_length/3+job_num);
child1_wa=child1(1,2*chrom_length/3+1:2*chrom_length/3+job_num);
child2_ma=child1(1,chrom_length/3+1:chrom_length/3+job_num);
child2_wa=child1(1,2*chrom_length/3+1:2*chrom_length/3+job_num);

chrom1_os=chrom1(1,1:job_num);                   %OS��
chrom1_ma=chrom1(1,chrom_length/3+1:chrom_length/3+job_num);  %MA��
chrom1_wa=chrom1(1,2*chrom_length/3+1:2*chrom_length/3+job_num);    %WA��
chrom2_os=chrom2(1,1:job_num);                   %OS��
chrom2_ma=chrom2(1,chrom_length/3+1:chrom_length/3+job_num);  %MA��
chrom2_wa=chrom2(1,2*chrom_length/3+1:2*chrom_length/3+job_num);    %WA��

if rand<crossRate;
    %% OS�㽻��
    ii=randperm(job_num,2);   %���ȡһ�θ����������Ƭ��
    max_pos=max(ii);
    min_pos=min(ii);
    chrom1_os_vector=chrom1_os;
    chrom2_os_vector=chrom2_os;
    for i=min_pos:max_pos
        chrom1_os_vector(find(chrom1_os_vector==chrom2_os(i),1))=0;   %����������1��Ӹ�������2��ȡ�Ļ���Ƭ����ͬ��λ����0
        chrom2_os_vector(find(chrom2_os_vector==chrom1_os(i),1))=0;
    end
    chrom1_os_vector1=chrom1_os;
    chrom2_os_vector1=chrom2_os;
    for i=min_pos:max_pos
        chrom1_os_vector(find(chrom1_os_vector==0,1))=chrom2_os_vector1(i);   %����˳�򽫴Ӹ���2��ȡ�Ļ���Ƭ�η��븸��1��0λ��
        chrom2_os_vector(find(chrom2_os_vector==0,1))=chrom1_os_vector1(i);
    end
    child1(1,1:job_num)=chrom1_os_vector;   %�����Ӵ�����
    child2(1,1:job_num)=chrom2_os_vector;
    
    %% MA�㽻��  WA�㽻�������ͬ�ķ�ʽ
    ii=randperm(job_num,2);   %���ȡһ�θ����������Ƭ��
    max_pos=max(ii);
    min_pos=min(ii);
    child1_ma(min_pos:max_pos)=chrom2_ma(min_pos:max_pos);
    child2_ma(min_pos:max_pos)=chrom1_ma(min_pos:max_pos);
    
    child1_wa(min_pos:max_pos)=chrom2_wa(min_pos:max_pos);
    child2_wa(min_pos:max_pos)=chrom1_wa(min_pos:max_pos);
    if min_pos~=1 && max_pos~=job_num
        child1_ma(1:min_pos-1)=chrom1_ma(1:min_pos-1);
        child1_ma(min_pos+1:end)=chrom1_ma(min_pos+1:end);
        child2_ma(1:min_pos-1)=chrom2_ma(1:min_pos-1);
        child2_ma(min_pos+1:end)=chrom2_ma(min_pos+1:end);
        
        child1_wa(1:min_pos-1)=chrom1_wa(1:min_pos-1);
        child1_wa(min_pos+1:end)=chrom1_wa(min_pos+1:end);
        child2_wa(1:min_pos-1)=chrom2_wa(1:min_pos-1);
        child2_wa(min_pos+1:end)=chrom2_wa(min_pos+1:end);
    elseif min_pos~=1 && max_pos==job_num
        child1_ma(1:min_pos-1)=chrom1_ma(1:min_pos-1);
        child2_ma(1:min_pos-1)=chrom2_ma(1:min_pos-1);
        
        child1_wa(1:min_pos-1)=chrom1_wa(1:min_pos-1);
        child2_wa(1:min_pos-1)=chrom2_wa(1:min_pos-1);
    elseif min_pos==1 && max_pos~=job_num
        child1_ma(min_pos+1:end)=chrom1_ma(min_pos+1:end);
        child2_ma(min_pos+1:end)=chrom2_ma(min_pos+1:end);
        
        child1_wa(min_pos+1:end)=chrom1_wa(min_pos+1:end);
        child2_wa(min_pos+1:end)=chrom2_wa(min_pos+1:end);
    end
    
    child1(1,chrom_length/3+1:chrom_length/3+job_num)=child1_ma;
    child1(1,2*chrom_length/3+1:2*chrom_length/3+job_num)=child1_wa;
    child2(1,chrom_length/3+1:chrom_length/3+job_num)=child2_ma;
    child2(1,2*chrom_length/3+1:2*chrom_length/3+job_num)=child2_wa;
else
    child1=chrom1;
    child2=chrom2;
end
end


