function [sys,x0,str,ts] = global_terminal_controller(t, x, u, flag)
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

alpha0 = 2;
beta0 = 1;
p0 = 7;
q0 = 5;
phi = 10;
gamma = 10;
p = 3;
q = 1;

fx = cos(x1);
gx = x1^2+1;

s0 = x1;
ds0 = x2;
s1 = ds0 + alpha0*s0 + beta0*abs(s0)^(q0/p0)*sign(s0);

T1 = abs(x1)^((q0-p0)/p0)*sign(x1);
T2 = abs(s1)^(q/p)*sign(s1);
ut = -(1/gx)*(fx + alpha0*x2 + beta0*q/p*T1*x2 + phi*s1 + gamma*T2);
sys(1) = ut;


