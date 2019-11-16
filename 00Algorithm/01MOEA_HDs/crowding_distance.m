function [Population_cd]=crowding_distance(Population_ns,m,last_rank)
%������ӵ������

% inputs
% Pop_ns����֧������֮�����Ⱥ
% chrom_length:Ⱦɫ�峤��
% m��Ŀ����

% outputs
% Pop_nscd:ĳһǰ�ؼ����ӵ���������Ⱥ
Population_cd=Population_ns;
rank=last_rank;              %����ӵ�������ǰ��
array=[Population_ns.rank];
[~,vol]=find(array==rank);
Pop_array1=Population_ns(vol);
s=size(vol,2);
obj_array=zeros(s,m);
Pop_struct(1:s)=struct('chromesome',[],'decode',[],'pro_time',[],'objectives',[],'load_machine',[],'load_worker',[],'rank',0,'crowded_distance',0,'cross_f',false); 
for j=1:s
    obj_array(j,:)=Pop_array1(j).objectives;                               %ȡ����Ӧ�����Ŀ��ֵ
end
for i=1:m                                                                  % �ֱ���m��Ŀ��ֵ����ӵ�����룬���������һ��
%% ��ѡ���ķ�֧��ǰ�صĸ����������
    [~,index]=sort(obj_array(:,i));                                        
    obj_array=obj_array(index,:);
    for jj=1:s
        Pop_struct(jj)=Pop_array1(index(jj));
    end
%% ���ӵ������
    Pop_struct(1).crowded_distance=Pop_struct(1).crowded_distance+inf;
    Pop_struct(s).crowded_distance=Pop_struct(s).crowded_distance+inf;
    for ii=2:s-1
        max_obj=max(obj_array(:,i));
        min_obj=min(obj_array(:,i));
        if max_obj~=min_obj
            distance=(obj_array(ii+1,i)-obj_array(ii-1,i))/(max_obj-min_obj);
            Pop_struct(ii).crowded_distance=Pop_struct(ii).crowded_distance+distance;
        else
            distance=1;
            Pop_struct(ii).crowded_distance=Pop_struct(ii).crowded_distance+distance;
        end
    end
    Pop_array1=Pop_struct;
end
Population_cd(vol)=Pop_struct;
end