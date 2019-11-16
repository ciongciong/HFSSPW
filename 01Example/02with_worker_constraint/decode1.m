function [Population_decode]=decode1(pop_size,job_num,stage_num,mach_set_stage,worker_set_stage,Basic_infor,Population_home)
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
%�ڶ��У���������ƽ��
%�����У����˸���ƽ��

Population_decode=Population_home;
total_ope_num=size(Population_decode(1).chromesome,2)/3;

max_mach_rank=max(mach_set_stage{1,stage_num});
max_worker_rank=max(worker_set_stage(stage_num,:));
%% ��ȡ����O_ij�ļӹ�����M_m�Ͳ�������W_w�Լ��ӹ�ʱ��
for i=1:pop_size
    chromosome=Population_home(i).chromesome;
    if chromosome(job_num+1)==0
        chrom_os=chromosome(1:total_ope_num);
        chrom_ma=chromosome(total_ope_num+1:2*total_ope_num);
        chrom_wa=chromosome(2*total_ope_num+1:3*total_ope_num);
        load_machine_cell=cell(max_mach_rank,3);
        load_worker_cell=cell(max_worker_rank,3);
        chrom_decode=cell(1,total_ope_num);
        pro_time_array=zeros(3,total_ope_num);
        for j=1:stage_num
            if j==1
                chrom_os_stage1=chrom_os(1:j*job_num);
            end
            [chrom_ma_stage,chrom_wa_stage,pro_time_array,load_machine_cell,load_worker_cell,chrom_decode]=heuristic_decode1(j,job_num,chrom_os_stage1,pro_time_array,load_machine_cell,load_worker_cell,chrom_decode,mach_set_stage,worker_set_stage,Basic_infor);  %����ʽ����Ϊ��ȷ�������͹���ѡ��
            [~,index1]=sort(pro_time_array(2,(j-1)*job_num+1:j*job_num));%���ս������Ⱥ����
            %�൱�������׼����ͬʱΪ�����׶εĽ�����׼��
            pro_time_array(1,(j-1)*job_num+1:j*job_num)=pro_time_array(1,(j-1)*job_num+index1);
            pro_time_array(2,(j-1)*job_num+1:j*job_num)=pro_time_array(2,(j-1)*job_num+index1);
            pro_time_array(3,(j-1)*job_num+1:j*job_num)=pro_time_array(3,(j-1)*job_num+index1);
            chrom_os_stage1=pro_time_array(3,(j-1)*job_num+1:j*job_num);
            chrom_os((j-1)*job_num+1:j*job_num)=chrom_os_stage1;
            chrom_ma((j-1)*job_num+1:j*job_num)=chrom_ma_stage;
            chrom_wa((j-1)*job_num+1:j*job_num)=chrom_wa_stage;
        end
        
        Population_decode(i).chromesome(1:total_ope_num)=chrom_os;
        Population_decode(i).chromesome(total_ope_num+1:2*total_ope_num)=chrom_ma;
        Population_decode(i).chromesome(2*total_ope_num+1:3*total_ope_num)=chrom_wa;
        Population_decode(i).pro_time=pro_time_array;
       %% �������Ŀ��ֵ��makespan��total tardiness of all jobs
        makespan_mat=load_machine_cell(:,2);
        makespan=max(cell2mat(makespan_mat.'));                                %ȡ����깤ʱ��
        Population_decode(i).objectives(1)=roundn(makespan,-4);                %����깤ʱ��Ŀ��
        
        tardiness_cell=load_machine_cell(mach_set_stage{1,stage_num},2:3);
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
        %�ڶ��У����˸���
        workload_balance_array=zeros(2,stage_num);
        for ss=1:stage_num
            %����
            mach_set=mach_set_stage{1,ss};
            num_machine=size(mach_set,2);
            workload_mach=zeros(1,num_machine);
            for mm=1:num_machine
                CT_ma=load_machine_cell{mach_set(1,mm),2};
                ST_ma=load_machine_cell{mach_set(1,mm),1};
                pro_ma=CT_ma-ST_ma;
                workload_mach(1,mm)=sum(pro_ma);
            end
            sumload_ma=sum(workload_mach);
            meanload_ma=sumload_ma/num_machine;
            squload_ma=(workload_mach-meanload_ma).^2;
            workload_balance_array(1,ss)=sum(squload_ma);
            %����
            worker_set=worker_set_stage(ss,:);
            num_worker=size(worker_set,2);
            workload_wo=zeros(1,num_worker);
            for ww=1:num_worker
                CT_wo=load_worker_cell{worker_set(1,ww),2};
                ST_wo=load_worker_cell{worker_set(1,ww),1};
                pro_wo=CT_wo-ST_wo;
                workload_wo(1,ww)=sum(pro_wo);
            end
            sumload_wo=sum(workload_wo);
            meanload_wo=sumload_wo/num_worker;
            squload_wo=(workload_wo-meanload_wo).^2;
            workload_balance_array(2,ss)=sum(squload_wo);
            
        end
        workload_balance_ma=sum(workload_balance_array(1,:));
        Population_decode(i).load_inbalance_ma=workload_balance_ma^(1/2);                %��������ƽ��
        workload_balance_wo=sum(workload_balance_array(2,:));
        Population_decode(i).load_inbalance_wo=workload_balance_wo^(1/2);                %���˸���ƽ��
        
        %% ����������Ϣ�洢
        Population_decode(i).decode=chrom_decode.';
        %% �����͹��˼ӹ���Ϣ�Ĵ洢
        Population_decode(i).load_machine=load_machine_cell;
        Population_decode(i).load_worker=load_worker_cell;
    end
end
end