function [Population_ns]=nondominant_sort(Population_decode,pop_size,m)
%����Pareto֧���������

%inputs
%Population_decode:����֮�����Ⱥ
% chrom_length:Ⱦɫ�峤��
% m��Ŀ�����

%outputs
%Population_ns:��֧������֮�����Ⱥ
%�������Ⱥ��chrom_length+7��Ϊ�ø��������ķ�֧��ǰ��

%֧���ϵ�Ķ��壻��С�����⣨DFSP��
%����������������a��b,���������Ŀ��ֵ����a<=b,�Ҵ���a<b����a֧��b;
%��a��֧��b,b��֧��a,��a��b�޲��
%���庯���� c=dominate(a,b)
Population_ns=Population_decode;
rank=1;
%����ṹ�����ڴ洢��ͬ�����ni��֧�����i�ĸ�������si���ܸ���i֧��ĸ��壩
person(1:pop_size)=struct('n',0,'s',[]);
%�洢��ͬ�ȼ�������Ϣ��.f��Ϊ�˱�֤�ýṹ����matlab������,����matlab����չ�Խṹ��
F(rank).f=[];
%��֧������
I=1:pop_size;
for i=1:pop_size
    object_i=Population_decode(i).objectives(1:m);
    I(1:i)=[];
    if ~isempty(I)
        for jj=1:length(I)
            j=I(jj);
            object_j=Population_decode(j).objectives(1:m);
            log_num_i=dominate(object_i,object_j);                               %��֧���ж�
            log_num_j=dominate(object_j,object_i); 

            if log_num_i
                person(i).s=[person(i).s,j];
                person(j).n=person(j).n+1;
            end
            if log_num_j
                person(j).s=[person(j).s,i];
                person(i).n=person(i).n+1;
            end
        end
    end
    I=1:pop_size;
end
[~,col]=find([person.n]==0);
F(rank).f=col;
%% ����ǰ������
while ~isempty(F(rank).f)
    Q=[];
    for i=1:length(F(rank).f)
        if ~isempty(person(F(rank).f(i)).s)
            for j=1:length(person(F(rank).f(i)).s)
                person(person(F(rank).f(i)).s(j)).n=person(person(F(rank).f(i)).s(j)).n-1;
                if person(person(F(rank).f(i)).s(j)).n==0
                    Q=[Q,person(F(rank).f(i)).s(j)];
                end
            end
        end
    end
    rank=rank+1;
    F(rank).f=Q;
end
for ii=1:rank
    if ~isempty(F(ii).f)
        [~,col]=size(F(ii).f);
        for jj=1:col
            Population_ns(F(ii).f(jj)).rank=ii;
        end
    end    
end
[~,index]=sort([Population_ns.rank]);
Population_ns=Population_ns(index);
end