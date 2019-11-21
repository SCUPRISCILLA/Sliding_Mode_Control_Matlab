function [sys,x0,str,ts] = approach_robustness_controller(t, x, u, flag)
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
sizes.NumOutputs     = 3;  %�����������
sizes.NumInputs      = 3;   %�����������
sizes.DirFeedthrough = 1;   %�����ź��Ƿ�������Ӻ����г���
sizes.NumSampleTimes = 0;   % at least one sample time is needed

sys = simsizes(sizes);
x0  = [];   %��ʼֵ
str = [];   
ts  = [];   %[0 0]��������ϵͳ��[-1 0]��ʾ�̳���ǰ�Ĳ���ʱ������
simStateCompliance = 'UnknownSimState';

function sys=mdlOutputs(t,x,u)   %��������Ӻ���
thd = u(1);
dthd = cos(t);
ddthd = -sin(t);
th = u(2);
dth = u(3);

e = thd - th;
de = dthd - dth;
c = 15;
s = c*e + de;

fx = 25*dth;
dU = 10;
dL = -10;

epc = 0.5;
k = 10;
b = 133;

ut = 1/b*(epc*sign(s) + k*s + c*(dthd - dth) + ddthd + fx - (dU + dL)/2 + (dU - dL)/2*sign(s));

sys(1) = ut;
sys(2) = e;
sys(3) = de;

