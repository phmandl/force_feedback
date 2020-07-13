clear; clc;
close all;

J = 7.5924;
Ts = 0.01;

%% Controller Script

A = [0 1; 0 0];
B = [0; 1/J];
C = [1 0];

sys_con = ss(A,B,C,0);

%% Discrete system
sys_dis = c2d(sys_con,Ts);

Q = diag([10,5]);
R = 1;
[K,P,e] = dlqr(sys_dis.A,sys_dis.B,Q,R);
Kw = 1/(sys_dis.C*inv(eye(2) - sys_dis.A + sys_dis.B*K)*sys_dis.B);

sys_close = ss(sys_dis.A - sys_dis.B*K, Kw*sys_dis.B,sys_dis.C,0,Ts);
sys_open = ss(sys_dis.A,sys_dis.B,sys_dis.C,0);

figure;
step(sys_close);
damp(sys_close);

%% Buidl observer
poles_obsv = real(pole(sys_close))/100;

P = sym('P',[2,1]);
syms z
F = sys_dis.A - P*sys_dis.C;
detF = det(z*eye(2) - F);
[C,T] = coeffs(detF,z,'all');
desirePoles = poly(poles_obsv);
SOL = solve(C == desirePoles);
P = double([SOL.P1;SOL.P2]);


 
