%���Ƹ���ͼ
solution=1;
load resultt01100��2I_all.mat
load AAA_t01100��2.mat
chrom_decode_one=Population_child_all(solution).decode;
total_ope_num=size(chrom_decode_one,1);
%% ������ͼ
col=jet(job_num);                                                          %������ɫ���趨
rec=zeros(1,4);
for i=1:total_ope_num
    job_rank=chrom_decode_one{i,1}(1,1);                                   %ȡ��������
    ope_rank=chrom_decode_one{i,1}(1,2);                                   %ȡ�������
    ma_rank=chrom_decode_one{i,1}(1,3);                                    %ȡ��������
    wo_rank=chrom_decode_one{i,1}(1,4);                                    %ȡ�����˺�
    ST_ope=chrom_decode_one{i,1}(1,6);                                    %ȡ���ù���ʼ�ӹ�ʱ��
    CT_ope=chrom_decode_one{i,1}(1,7);                                    %ȡ���ù�������ӹ�ʱ��
    rec(1)=ST_ope;                                                         %���εĺ�����
    rec(2)=ma_rank-0.5;                                                    %���ε�������
    rec(3)=CT_ope-ST_ope;                                                  %���ε�x�᷽��ĳ���
    rec(4)=0.9;
    rectangle('Position',rec,'LineWidth',1.5,'LineStyle','-','FaceColor',col(job_rank,:)); %draw every rectangle
    text(rec(1)+rec(3)*0.5-2,ma_rank+rec(4)/4,strcat('O',num2str(job_rank),',',strcat(num2str(ope_rank))),'fontsize',10);
    text(rec(1)+rec(3)*0.5-2,ma_rank-rec(4)/4,strcat('(','W',num2str(wo_rank),')'),'fontsize',10);
end
makespan=Population_child_all(solution).objectives(1);
chrom_ma=Population_child_all(solution).chromesome(total_ope_num+1:2*total_ope_num);
Machine_number=max(mach_set_stage{1,stage_num});
mach_info=cell(1,Machine_number);                                          %�洢�ַ�������������
for i=1:Machine_number
    num=i;
    str1='M';
    str=sprintf('%s%d',str1,num);
    mach_info{1,i}=str;
end
y=1:Machine_number;
x=0:0.1*makespan:makespan*1.001;
set(gca,'YTick',y);                                                       %����y������ķ�Χ
set(gca,'XTick',x);
set(gca,'YTickLabel',mach_info);
set(gca,'FontName','Times New Roman','FontSize',10);
%% ����makespan������
hold on
x1=makespan;
y=0:0.1:Machine_number;
plot(x1,y,'k.-');
hold on
x2=0:3:makespan;
y=zeros(1,stage_num);
for i=1:stage_num
    num=size(mach_set_stage{1,i},2);
    y(1,i)=mach_set_stage{1,i}(1,num)+0.5;
    plot(x2,y(1,i),'b.-');
end
