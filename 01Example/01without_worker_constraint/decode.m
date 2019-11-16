function [Population_decode]=decode(pop_size,job_num,stage_num,mach_set_stage,Basic_infor,Population_home)
%Ⱦɫ�����
%inputs
% pop_size:��Ⱥ������
%stage_num���ӹ��׶���
%Worker_stage��ÿ�׶ι�����
% total_ope_num��ÿ������Ĺ�������
%chrom_length��Ⱦɫ�峤��
% Basic_infor:������Ϣ���������ӹ�ʱ������
%Population_home����Ⱥ

%outputs
%chrom_decode�����ȷ���(cell)
%ÿ����total_ope_num��Ԫ����ÿ��Ԫ��ÿ������
%%��һ�У���¼������
%%�ڶ��У���¼�ӹ��׶�
%%�����У���¼����ѡ��
%%�����У���¼����ѡ��
%%�����У���¼�ӹ�ʱ��
%%�����У����Դ洢�ӹ���ʼʱ��S_ij
%%�����У����Դ洢�ӹ���ʼʱ��E_ij

%Population_decode.objectives:���ȷ���Ŀ��ֵ�ļ�¼������6����
%��һ�У�makespan
%�ڶ��У�total tardiness of all jobs

Population_decode=Population_home;
total_ope_num=size(Population_decode(1).chromesome,2)/3;
chrom_decode=cell(pop_size,total_ope_num);
max_mach_rank=max(mach_set_stage{1,stage_num});
%% ��ȡ����O_ij�ļӹ�����M_m�Ͳ�������W_w�Լ��ӹ�ʱ��
for i=1:pop_size
    
    chromesome=Population_home(i).chromesome;                    %ȡ��Ⱥ�е�һ��Ⱦɫ�����
    chrom_os=chromesome(1,1:total_ope_num);                     %Ⱦɫ���OS��
    chrom_ma=chromesome(1,total_ope_num+1:2*total_ope_num);     %Ⱦɫ���MA��
    
    for ii=1:stage_num
        chrom_os_stage=chrom_os((ii-1)*job_num+1:ii*job_num);
        chrom_ma_stage=chrom_ma((ii-1)*job_num+1:ii*job_num);
        for jj=1:job_num
            job_rank=chrom_os_stage(jj);
            chrom_decode{i,(ii-1)*job_num+jj}(1,1)=job_rank;
            chrom_decode{i,(ii-1)*job_num+jj}(1,2)=ii;
            chrom_decode{i,(ii-1)*job_num+jj}(1,3)=chrom_ma_stage(job_rank);
            chrom_decode{i,(ii-1)*job_num+jj}(1,4)=Basic_infor.pro_time(job_rank,chrom_ma_stage(job_rank));
            chrom_decode{i,(ii-1)*job_num+jj}(1,5)=0;                               %���Դ洢�ӹ���ʼʱ��S_ij
            chrom_decode{i,(ii-1)*job_num+jj}(1,6)=0;                               %���Դ洢�ӹ�����ʱ��C_ij
        end
        
    end
    pro_time_ma=cell(max_mach_rank,4);                                     %������¼���������˵Ĺ���ʱ�䡪����ʼʱ�䣨��һ�У��ͽ���ʱ�䣨�ڶ��У�������Ӧ�Ĺ����ţ������У��͹���ţ������У�
    pro_time_oper=zeros(2,total_ope_num);                                  %���ڴ洢ÿ������Ŀ�ʼ�ͽ����ӹ�ʱ��
   
    
    %% �ҵ�������ļӹ���ʼʱ��ͼӹ�����ʱ��
    for j=1:total_ope_num
        job_rank=chrom_decode{i,j}(1,1);                                   %��ȡ�����ţ�job rank��
        ope_rank=chrom_decode{i,j}(1,2);                                   %��ȡ����ţ�operation rank��
        ma_rank=chrom_decode{i,j}(1,3);                                    %��ȡ�����ţ�machine rank��
        
        pro_time=chrom_decode{i,j}(1,4);                                   %��ȡ����ļӹ�ʱ��
        if ope_rank==1                                                     %��ȡ��һ������Ľ���ʱ�䣨completed time of prevent process��
            CT_pre=0;
        else
            [~,IP]=find(chrom_os==job_rank,ope_rank-1);
            CT_pre=chrom_decode{i,IP(ope_rank-1)}(1,6);
        end
        if isempty(pro_time_ma{ma_rank,1})%��ȡ����/�����ϵĿ���ʱ�䣨start idle time in machine/worker & completed idle time in machine/worker��
            ST_ma=CT_pre;
            CT_ma=inf;
            chrom_decode{i,j}(1,5)=ST_ma;                                 %�洢����ʼ�ӹ�ʱ��
            pro_time_oper(1,j)=ST_ma;
            chrom_decode{i,j}(1,6)=ST_ma+pro_time;                        %�洢������ɼӹ�ʱ��
            pro_time_oper(2,j)=ST_ma+pro_time;
            pro_time_ma{ma_rank,1}(1,1)=ST_ma;                             %���»��������˼ӹ���ʼʱ��
            pro_time_ma{ma_rank,2}(1,1)=ST_ma+pro_time;
            pro_time_ma{ma_rank,3}(1,1)=job_rank;
            pro_time_ma{ma_rank,4}(1,1)=ope_rank;
        else
            ST_ma=[];
            CT_ma=[];
            
            col_ma=size(pro_time_ma{ma_rank,1},2);
            if col_ma<2
                ST_ma(1,1)=0;
                if col_ma==0
                    CT_ma(1,1)=inf;
                else
                    CT_ma(1,1)=pro_time_ma{ma_rank,1}(1,1);
                    ST_ma(1,2)=pro_time_ma{ma_rank,2}(1,1);
                    CT_ma(1,2)=inf;
                end
            elseif col_ma>=2
                ST_ma(1,1)=0;
                ST_ma(1,2:col_ma+1)=pro_time_ma{ma_rank,2}(1,1:col_ma);
                CT_ma(1,1:col_ma)=pro_time_ma{ma_rank,1}(1,1:col_ma);
                CT_ma(1,col_ma+1)=inf;
            end
            col1=size(ST_ma,2);
            flag=1;
            array_ST=[];
            array_CT=[];
            for k=1:col1
                
                ET_oper=max([CT_pre,ST_ma(1,k)]);          %��ȡ���������ӹ�ʱ��
                CT=min([CT_ma(1,k)]);                      %��ȡ������������ʱ��
                if ET_oper+pro_time<=CT
                    array_ST(1,flag)=ET_oper;
                    array_CT(1,flag)=ET_oper+pro_time;
                    flag=flag+1;
                end
                
            end
            ET_oper=min(array_ST);
            chrom_decode{i,j}(1,5)=ET_oper;
            pro_time_oper(1,j)=ET_oper;
            chrom_decode{i,j}(1,6)=ET_oper+pro_time;                      %�洢������ɼӹ�ʱ��
            pro_time_oper(2,j)=ET_oper+pro_time;
            pro_time_ma{ma_rank,1}(1,col_ma+1)=ET_oper;                    %���»��������˼ӹ���ʼʱ��
            pro_time_ma{ma_rank,2}(1,col_ma+1)=ET_oper+pro_time;
            pro_time_ma{ma_rank,3}(1,col_ma+1)=job_rank;
            pro_time_ma{ma_rank,4}(1,col_ma+1)=ope_rank;
            [pro_time_ma{ma_rank,1},index]=sort(pro_time_ma{ma_rank,1});
            pro_time_ma{ma_rank,2}=pro_time_ma{ma_rank,2}(index);
            pro_time_ma{ma_rank,3}=pro_time_ma{ma_rank,3}(index);
            pro_time_ma{ma_rank,4}=pro_time_ma{ma_rank,4}(index);
            
        end
    end
    Population_decode(i).pro_time=pro_time_oper;
    %% �������Ŀ��ֵ��makespan��total tardiness of all jobs
    makespan_mat=pro_time_ma(:,2);
    makespan=max(cell2mat(makespan_mat.'));                                %ȡ����깤ʱ��
    Population_decode(i).objectives(1)=roundn(makespan,-4);                %����깤ʱ��Ŀ��
    
    tardiness_cell=pro_time_ma(mach_set_stage{1,stage_num},2:3);
    A=cellfun(@(x) x.',tardiness_cell, 'UniformOutput', false);
    tardiness_mat=cell2mat(A);
    tardiness_mat1=zeros(job_num,4);
    tardiness_mat1(:,1:2)=tardiness_mat;
    tardiness_mat1(:,3)=Basic_infor.due_time(tardiness_mat(:,2),1);
    tardiness_mat1(:,4)=tardiness_mat1(:,1)-tardiness_mat1(:,3);
    [IP,~,~]=find(tardiness_mat1(:,4)<0);
    tardiness_mat1(IP,4)=0;
    total_tardiness=sum(tardiness_mat1(:,4));
    Population_decode(i).objectives(2)=roundn(total_tardiness,-4);                %������ʱ��
    
    
    
    %% ��������ƽ�⡢���˸���ƽ��
    %workload_balance_array
    %��һ�У���������
    workload_balance_array=zeros(2,stage_num);
    for ss=1:stage_num
        %����
        mach_set=mach_set_stage{1,ss};
        num_machine=size(mach_set,2);
        workload_mach=zeros(1,num_machine);
        for mm=1:num_machine
            CT_ma=pro_time_ma{mach_set(1,mm),2};
            ST_ma=pro_time_ma{mach_set(1,mm),1};
            pro_ma=CT_ma-ST_ma;
            workload_mach(1,mm)=sum(pro_ma);
        end
        sumload_ma=sum(workload_mach);
        meanload_ma=sumload_ma/num_machine;
        squload_ma=(workload_mach-meanload_ma).^2;
        workload_balance_array(1,ss)=sum(squload_ma);
        
    end
    workload_balance_ma=sum(workload_balance_array(1,:));
    Population_decode(i).load_inbalance_ma=workload_balance_ma^(1/2);                %��������ƽ��
    
    %% ����������Ϣ�洢
    Population_decode(i).decode=chrom_decode(i,:).';
    %% �����͹��˼ӹ���Ϣ�Ĵ洢
    Population_decode(i).load_machine=pro_time_ma;
    
    Population_decode(i).crossover_mutation=1;
end
end

