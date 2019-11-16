function [Population_decode]=heuristic_decode(Population_decode,filenames,Disp1,Disp2)
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
load (filenames)

pop_size=size([Population_decode.rank],2);
total_ope_num=job_num*stage_num;


max_mach_rank=max(mach_set_stage{1,stage_num});
max_worker_rank=max(worker_set_stage(stage_num,:));
%% ��ȡ����O_ij�ļӹ�����M_m�Ͳ�������W_w�Լ��ӹ�ʱ��
for i=1:pop_size
    chromosome=Population_decode(i).chromesome;
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
            if strcmp(Disp1,'LB')&&strcmp(Disp2,'EDD')
                [chrom_os_stage,chrom_ma_stage,chrom_wa_stage,pro_time_array,load_machine_cell,load_worker_cell,chrom_decode]=load_balancing_EDD(j,job_num,chrom_os_stage1,pro_time_array,load_machine_cell,load_worker_cell,chrom_decode,mach_set_stage,worker_set_stage,Basic_infor);
            elseif strcmp(Disp1,'FIMW')&&strcmp(Disp2,'EDD')
                [chrom_os_stage,chrom_ma_stage,chrom_wa_stage,pro_time_array,load_machine_cell,load_worker_cell,chrom_decode]=first_idle_mw_EDD(j,job_num,chrom_os_stage1,pro_time_array,load_machine_cell,load_worker_cell,chrom_decode,mach_set_stage,worker_set_stage,Basic_infor);
            elseif strcmp(Disp1,'LFMW')&&strcmp(Disp2,'EDD')
                [chrom_os_stage,chrom_ma_stage,chrom_wa_stage,pro_time_array,load_machine_cell,load_worker_cell,chrom_decode] = lastest_free_mw_EDD(j,job_num,chrom_os_stage1,pro_time_array,load_machine_cell,load_worker_cell,chrom_decode,mach_set_stage,worker_set_stage,Basic_infor);
            end
            if j ~= 1
                chrom_os((j-1)*job_num+1:j*job_num)=chrom_os_stage;
            end
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
        %% ����������Ϣ�洢
        Population_decode(i).decode=chrom_decode.';
        %% �����͹��˼ӹ���Ϣ�Ĵ洢
        Population_decode(i).load_machine=load_machine_cell;
        Population_decode(i).load_worker=load_worker_cell;
    elseif Population_decode(i).cross_f
        chrom_os=chromosome(1,1:total_ope_num);                     %Ⱦɫ���OS��
        chrom_ma=chromosome(1,total_ope_num+1:2*total_ope_num);     %Ⱦɫ���MA��
        chrom_wa=chromosome(1,2*total_ope_num+1:3*total_ope_num);   %Ⱦɫ���WA��
        load_machine_cell=cell(max_mach_rank,3);
        load_worker_cell=cell(max_worker_rank,3);
        chrom_decode=cell(1,total_ope_num);
        pro_time_array=zeros(3,total_ope_num);
        for j=1:stage_num
            chrom_os_stage=chrom_os((j-1)*job_num+1:j*job_num);
            chrom_ma_stage=chrom_ma((j-1)*job_num+1:j*job_num);
            chrom_wa_stage=chrom_wa((j-1)*job_num+1:j*job_num);
            [pro_time_array,load_machine_cell,load_worker_cell,chrom_decode]=decodef(j,job_num,chrom_os_stage,pro_time_array,load_machine_cell,load_worker_cell,chrom_decode,mach_set_stage,worker_set_stage,chrom_ma_stage,chrom_wa_stage,Basic_infor);
        end
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
        %% ����������Ϣ�洢
        Population_decode(i).decode=chrom_decode.';
        %% �����͹��˼ӹ���Ϣ�Ĵ洢
        Population_decode(i).load_machine=load_machine_cell;
        Population_decode(i).load_worker=load_worker_cell;
        
        Population_decode(i).cross_f=false;
    end
end
end