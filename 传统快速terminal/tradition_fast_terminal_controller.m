function [sys,x0,str,ts] = tradition_fast_terminal_controller(t, x, u, flag)
switch flag,
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;  % ���ó�ʼ���Ӻ���
  case 1,
    sys=[];
  case 2,
    sys=[];
  case 3,
    sys=mdlOutputs(t,x,u);    %��������Ӻ���
  case 4,
    sys=[];   %������һ����ʱ���Ӻ���
  case 9,
    sys=[];    %��ֹ�����Ӻ���
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end

function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes   %��ʼ���Ӻ���

sizes = simsizes;

sizes.NumContStates  = 0;  %����״̬��������
sizes.NumDiscStates  = 0;  %��ɢ״̬��������
sizes.NumOutputs     = 1;  %�����������
sizes.NumInputs      = 2;   %�����������
sizes.DirFeedthrough = 1;   %�����ź��Ƿ�������Ӻ����г���
sizes.NumSampleTimes = 0;   % at least one sample time is needed

sys = simsizes(sizes);
x0  = [];   %��ʼֵ
str = [];   
ts  = [];   %[0 0]��������ϵͳ��[-1 0]��ʾ�̳���ǰ�Ĳ���ʱ������
simStateCompliance = 'UnknownSimState';

function sys=mdlOutputs(t,x,u)   %��������Ӻ���
x1 = u(1);
x2 = u(2);

mc = 1;
m = 0.1;
l = 0.5;
g = 9.8;
D = 2;

T = l*(4/3-m*cos(x1)*cos(x1)/(mc+m));
fx = g*sin(x1)-m*l*x2*x2*cos(x1)*sin(x1)/(mc+m);
fx = fx/T;
gx = cos(x1)/(mc+m);
gx = gx/T;

q = 3;
p = 5;
beta = 1;
xite = 2;

flag = 1;

if flag == 0    %�������⣬��x1 = 0��ʱ��ᱨ��
    T1 = abs(x1)^(q/p)*sign(x1);
    T2 = abs(x1)^(q/p-1)*sign(x1);   %��ֱ����x2^(2-p/q)�����ּ��������Ϊ2-p/q����Ϊ������x2����С��0
    s = x2 + beta*T1;
    ut = -(1/gx)*(fx + (beta*q/p)*T2*x2 + (D+xite)*sign(s));
else
    T1 = abs(x2)^(p/q)*sign(x2);
    T2 = abs(x2)^(2-p/q)*sign(x2);   %��ֱ����x2^(2-p/q)�����ּ��������Ϊ2-p/q����Ϊ������x2����С��0
    s = x1 + 1/beta*T1;
    ut = -(1/gx)*(fx + (beta*q/p)*T2 + (D+xite)*sign(s));
end

sys(1) = ut;


