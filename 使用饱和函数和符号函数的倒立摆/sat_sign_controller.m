function [sys,x0,str,ts] = sat_sign_controller(t, x, u, flag)
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
dthd = 0.1*cos(t);
ddthd = -0.1*sin(t);

x1 = u(2);
x2 = u(3);

mc = 1;
m = 0.1;
l = 0.5;
g = 9.8;

T = l*(4/3-m*cos(x1)*cos(x1)/(mc+m));
fx = g*sin(x1)-m*l*x2*x2*cos(x1)*sin(x1)/(mc+m);
fx = fx/T;
gx = cos(x1)/(mc+m);
gx = gx/T;

c = 1.5;
e = thd - x1;
de = dthd - x2;
s = c*e + de;

%ʹ��sign�������������Ϊ������sat�ȽϺ�
flag = 1;
ita = 20;

if flag == 0
    ut = 1/gx*(-fx+ddthd+c*de+ita*sign(s));
elseif flag == 1
    delta = 0.05;
    if abs(s) > delta
        ut = 1/gx*(-fx+ddthd+c*de+ita*sign(s));
    else
        ut = 1/gx*(-fx+ddthd+c*de+ita*1/delta*s);
    end
end

sys(1) = ut;


