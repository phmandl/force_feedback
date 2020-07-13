clear; clc;
close all;

J = 7.5924;
Ts = 0.03;

%% Controller Script

A = [0 1; 0 0];
B = [0; 1/J];
C = [1 0];

sys_con = ss(A,B,C,0);

%% Discrete system
sys_dis = c2d(sys_con,Ts);

Q = diag([1e3,1]);
R = 1e-3;
[K,P,e] = dlqr(sys_dis.A,sys_dis.B,Q,R);
Kw = 1/(sys_dis.C*inv(eye(2) - sys_dis.A + sys_dis.B*K)*sys_dis.B);

sys_close = ss(sys_dis.A - sys_dis.B*K, Kw*sys_dis.B,sys_dis.C,0,Ts);
sys_open = ss(sys_dis.A,sys_dis.B,sys_dis.C,0);

figure;
step(sys_close);
damp(sys_close);

% place poles with ackermann
% poles = [0.99999,0.99];
% K = acker(sys_dis.A,sys_dis.B,poles)
% Kw = 1/(sys_dis.C*inv(eye(2) - sys_dis.A + sys_dis.B*K)*sys_dis.B);

%% Build observer
poles_obsv = real(pole(sys_close))/10000;
poles_obsv = [0;0];
% poles_obsv = [0.9;0.9];

P = sym('P',[2,1]);
syms z
F = sys_dis.A - P*sys_dis.C;
detF = det(z*eye(2) - F);
[C,T] = coeffs(detF,z,'all');
desirePoles = poly(poles_obsv);
SOL = solve(C == desirePoles);
P = double([SOL.P1;SOL.P2]);


 
