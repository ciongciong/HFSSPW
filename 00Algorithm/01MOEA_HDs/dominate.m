function c=dominate(a,b)
%֧���ϵ�Ķ��壻��С�����⣨DFSP��
%����������������a��b,���������Ŀ��ֵ����a<=b,�Ҵ���a<b����a֧��b;
%��a��֧��b,b��֧��a,��a��b�޲��
c=all(a<=b)&&any(a<b);
end