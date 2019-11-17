function [sys,x0,str,ts] = simple_adaptive_controller(t, x, u, flag)
switch flag,
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;  % ���ó�ʼ���Ӻ���
  case 1,
    sys=mdlDerivatives(t,x,u);   %���ü���΢���Ӻ���
  case 2,
    sys=mdlUpdate(t,x,u);   %������ɢ״̬���������Ӻ���
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
sizes.NumInputs      = 3;   %�����������
sizes.DirFeedthrough = 1;   %�����ź��Ƿ�������˳���
sizes.NumSampleTimes = 0;   % at least one sample time is needed

sys = simsizes(sizes);
x0  = [];   %��ʼֵ
str = [];   
ts  = [];   %[0 0]��������ϵͳ��[-1 0]��ʾ�̳���ǰ�Ĳ���ʱ������
simStateCompliance = 'UnknownSimState';

function sys = mdlDerivatives(t, x, u)    %����΢���Ӻ���

sys = [];   %��������sys��������

function sys=mdlUpdate(t,x,u)  %��ɢ״̬���������Ӻ���

sys = [];

function sys=mdlOutputs(t,x,u)   %��������Ӻ���

J = 2;
thd = u(1);
th = u(2);
dth = u(3);

e = th - thd;
de = dth;
c = 10;
s = c*e + de;
xite = 1.1;

k = 0;
ut = J*(-c*dth-1/J*(k*s+xite*sign(s)));
sys(1) = ut;


