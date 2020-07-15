clear; clc;
close all;

Var = 7.5924;
Ts = 0.01;

%% Controller Script

A = [0 1; 0 0];
B = [0; Var];
C = [1 0];

sys_con = ss(A,B,C,0);

%% Discrete system
sys_dis = c2d(sys_con,Ts);

Q = diag([100,1]);
R = 10;
[K,P,e] = dlqr(sys_dis.A,sys_dis.B,Q,R);
Kw = 1/(sys_dis.C*inv(eye(2) - sys_dis.A + sys_dis.B*K)*sys_dis.B);

sys_close = ss(sys_dis.A - sys_dis.B*K, Kw*sys_dis.B,sys_dis.C,0,Ts);
sys_open = ss(sys_dis.A,sys_dis.B,sys_dis.C,0);

% step(sys_close);
% damp(sys_close);

%% Integration of error
Q_sys = [sys_dis.A zeros(2,1); -sys_dis.C*sys_dis.A 1];
h = [sys_dis.B; -sys_dis.C*sys_dis.B];

Q = diag([100,1,1]);
R = 60;
[K_int,P,e] = dlqr(Q_sys,h,Q,R);

% --- place
% poles = [0.99, 0.8, 0.7];
% K_int = place(Q_sys,h,poles)

%% Build observer
poles_obsv = real(pole(sys_close))/12;
% poles_obsv = [0;0];
% poles_obsv = [0.5;0.5];

P = sym('P',[2,1]);
syms z
F = sys_dis.A - P*sys_dis.C;
detF = det(z*eye(2) - F);
[C,T] = coeffs(detF,z,'all');
desirePoles = poly(poles_obsv);
SOL = solve(C == desirePoles);
P = double([SOL.P1;SOL.P2]);


 
