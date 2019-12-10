clear all
clc
%��Ҫ������λ����Ϣ
mdl_puma560;   %���ڼ����õ�����ģ��

%ʹ�÷��ź�������ʵ��ģ�ͣ�������
syms d1 d2 d3 d4 d5 d6;   %��е������ƫ��
syms a1 a2 a3 a4 a5 a6;     %��е�����˳���
syms q1 q2 q3 q4 q5 q6;    %ת���Ƕ�

qa = [0.1, 0.1, 0.1, 0.1, 0.1, 0.1];
qb = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5];
qc = [0.7, 0.7, 0.7, 0.7, 0.7, 0.7];
qd = [0.9, 0.9, 0.9, 0.4, 0.4, 0.4];
qe = [1.5, 1.5, 1.5, 1.5, 1.5, 1.5];

p560_real(1) = Link([0, d1, a1, 1.5708, 0]);
p560_real(2) = Link([0, d2, a2, 0, 0]);
p560_real(3) = Link([0, d3, a3, -1.5708, 0]);
p560_real(4) = Link([0, d4, a4, 1.5708, 0]);
p560_real(5) = Link([0, d5, a5, -1.5708, 0]);
p560_real(6) = Link([0, d6, a6, 0, 0]);
p560_real = SerialLink(p560_real, 'name', 'p560_real');    %������ʵ��puma560ģ�ͣ����������۲�����0.01
disp('�������')

F = p560_real.fkine([q1, q2, q3, q4, q5, q6]).t   %F����ֻҪ���˶�ѧ��xyz���֣���Ҫ�ǶȲ���

A = [
diff(F, a1), diff(F, a2), diff(F, a3), diff(F, a4), diff(F, a5), diff(F, a6), diff(F, d1), diff(F, d2), diff(F, d3), diff(F, d4), diff(F, d5), diff(F, d6)
]    %����������Ծ���

%Ϊ���ź�����ֵ
d1_idea = 0;
d2_idea = 0;
d3_idea = 0.15005;
d4_idea = 0.4318;
d5_idea = 0;
d6_idea = 0;
a1_idea = 0;
a2_idea = 0.4318;
a3_idea = 0.0203;
a4_idea = 0;
a5_idea = 0;
a6_idea = 0;
delta_x = [0.012; 0.021; 0.013; 0.01; 0.01; -0.01; 0.01; 0.01; 0.01; 0.012; -0.01; -0.01]; 
for i = 1:10
    disp(i)
    %Ϊ���ź�����ֵ
    d1 = d1_idea + delta_x(1)
    d2 = d2_idea + delta_x(2)
    d3 = d3_idea + delta_x(3)
    d4 = d4_idea + delta_x(4)
    d5 = d5_idea + delta_x(5)
    d6 = d6_idea + delta_x(6)
    a1 = a1_idea + delta_x(7)
    a2 = a2_idea + delta_x(8)
    a3 = a3_idea + delta_x(9)
    a4 = a4_idea + delta_x(10)
    a5 = a5_idea + delta_x(11)
    a6 = a6_idea + delta_x(12)

    %��һ��Ƕ�ֵ����qn
    q1 = 0;
    q2 = 0.7854;
    q3 = 3.1416;
    q4 = 0;
    q5 = 0.7854;
    q6 = 0;

    F1 = double(subs(F));   %����������F��A��������xyzλ�����dP
    A1 = double(subs(A));
    dP = p560.fkine(qn).t - F1;
    B1 = dP;

    %�ڶ���Ƕ�ֵ����qr
    q1 = 0;
    q2 = 1.5708;
    q3 = -1.5708;
    q4 = 0;
    q5 = 0;
    q6 = 0;

    F2 = double(subs(F));   %����������F��A��������xyzλ�����dP
    A2 = double(subs(A));
    dP = p560.fkine(qr).t - F2;
    B2 = dP;

    %������Ƕ�ֵ����qs
    q1 = 0;
    q2 = 0;
    q3 = -1.5708;
    q4 = 0;
    q5 = 0;
    q6 = 0;

    F3 = double(subs(F));   %����������F��A��������xyzλ�����dP
    A3 = double(subs(A));
    dP = p560.fkine(qs).t - F3;
    B3 = dP;

    %������Ƕ�ֵ����qz
    q1 = 0;
    q2 = 0;
    q3 = 0;
    q4 = 0;
    q5 = 0;
    q6 = 0;

    F4 = double(subs(F));  %����������F��A��������xyzλ�����dP
    A4 = double(subs(A));
    dP = p560.fkine(qz).t - F4;
    B4 = dP;

    %��5��Ƕ�ֵ����qa
    q1 = qa(1);
    q2 = qa(2);
    q3 = qa(3);
    q4 = qa(4);
    q5 = qa(5);
    q6 = qa(6);

    F5 = double(subs(F));   %����������F��A��������xyzλ�����dP
    A5 = double(subs(A));
    dP = p560.fkine(qa).t - F5;
    B5 = dP;

    %��6��Ƕ�ֵ����qb
    q1 = qb(1);
    q2 = qb(2);
    q3 = qb(3);
    q4 = qb(4);
    q5 = qb(5);
    q6 = qb(6);

    F6 = double(subs(F));   %����������F��A��������xyzλ�����dP
    A6 = double(subs(A));
    dP = p560.fkine(qb).t - F6;
    B6 = dP;

    %��7��Ƕ�ֵ����qc
    q1 = qc(1);
    q2 = qc(2);
    q3 = qc(3);
    q4 = qc(4);
    q5 = qc(5);
    q6 = qc(6);

    F7 = double(subs(F));   %����������F��A��������xyzλ�����dP
    A7 = double(subs(A));
    dP = p560.fkine(qc).t - F7;
    B7 = dP;

    %��8��Ƕ�ֵ����qd
    q1 = qd(1);
    q2 = qd(2);
    q3 = qd(3);
    q4 = qd(4);
    q5 = qd(5);
    q6 = qd(6);

    F8 = double(subs(F));   %����������F��A��������xyzλ�����dP
    A8 = double(subs(A));
    dP = p560.fkine(qd).t - F8;
    B8 = dP;

    %��9��Ƕ�ֵ����qe
    q1 = qe(1);
    q2 = qe(2);
    q3 = qe(3);
    q4 = qe(4);
    q5 = qe(5);
    q6 = qe(6);

    F9 = double(subs(F));   %����������F��A��������xyzλ�����dP
    A9 = double(subs(A));
    dP = p560.fkine(qe).t - F9;
    B9 = dP;

    Ao = [A1; A2; A3; A4; A5; A6; A7; A8; A9];
    Bo = [B1; B2; B3; B4; B5; B6; B7; B8; B9];

    delta_x = pinv(Ao'*Ao)*Ao'*Bo;    %���ϵ��
end
disp('������Ϊ��')
delta_x

disp('����qn������ǰ���Ϊ��')
delta_x_origin = [0.012; 0.021; 0.013; 0.01; 0.01; -0.01; 0.01; 0.01; 0.01; 0.012; -0.01; -0.01]; 
d1 = d1_idea + delta_x_origin(1);
d2 = d2_idea + delta_x_origin(2);
d3 = d3_idea + delta_x_origin(3);
d4 = d4_idea + delta_x_origin(4);
d5 = d5_idea + delta_x_origin(5);
d6 = d6_idea + delta_x_origin(6);
a1 = a1_idea + delta_x_origin(7);
a2 = a2_idea + delta_x_origin(8);
a3 = a3_idea + delta_x_origin(9);
a4 = a4_idea + delta_x_origin(10);
a5 = a5_idea + delta_x_origin(11);
a6 = a6_idea + delta_x_origin(12);
%��һ��Ƕ�ֵ����qn
q1 = 0;
q2 = 0.7854;
q3 = 3.1416;
q4 = 0;
q5 = 0.7854;
q6 = 0;

F1 = double(subs(F));   %����������F��A��������xyzλ�����dP
dP = p560.fkine(qn).t - F1

disp('����qn�����������Ϊ��')
d1 = d1_idea + delta_x(1);
d2 = d2_idea + delta_x(2);
d3 = d3_idea + delta_x(3);
d4 = d4_idea + delta_x(4);
d5 = d5_idea + delta_x(5);
d6 = d6_idea + delta_x(6);
a1 = a1_idea + delta_x(7);
a2 = a2_idea + delta_x(8);
a3 = a3_idea + delta_x(9);
a4 = a4_idea + delta_x(10);
a5 = a5_idea + delta_x(11);
a6 = a6_idea + delta_x(12);
%��һ��Ƕ�ֵ����qn
q1 = 0;
q2 = 0.7854;
q3 = 3.1416;
q4 = 0;
q5 = 0.7854;
q6 = 0;

F1_after = double(subs(F));   %����������F��A��������xyzλ�����dP
dP = F1_after - F1







