function [sys,x0,str,ts] = homework_plant(t, x, u, flag)
switch flag,
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;  % 调用初始化子函数
  case 1,
    sys=mdlDerivatives(t,x,u);   %调用计算微分子函数
  case 2,
    sys=[];
  case 3,
    sys=mdlOutputs(t,x,u);    %计算输出子函数
  case 4,
    sys=[];   %计算下一仿真时刻子函数
  case 9,
    sys=[];    %终止仿真子函数
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end

function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes   %初始化子函数

sizes = simsizes;

sizes.NumContStates  = 2;  %连续状态变量个数
sizes.NumDiscStates  = 0;  %离散状态变量个数
sizes.NumOutputs     = 2;  %输出变量个数
sizes.NumInputs      = 2;   %输入变量个数
sizes.DirFeedthrough = 0;   %输入信号是否在输出端出现
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);
x0  = [0.5, 0];   %初始值
str = [];   
ts  = [0 0];   %[0 0]用于连续系统，[-1 0]表示继承其前的采样时间设置
simStateCompliance = 'UnknownSimState';

function sys = mdlDerivatives(t, x, u)    %计算微分子函数
ut = u(1);
x2 = u(2);
f = x(1)^5-x(1)^6;
sys(1) = f + x2;
sys(2) = ut;

function sys=mdlOutputs(t,x,u)   %计算输出子函数
sys(1) = x(1);
sys(2) = x(2);


