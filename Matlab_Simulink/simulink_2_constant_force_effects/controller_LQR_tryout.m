clear; clc;
close all;

Var = 7.5924;
Ts = 0.02;

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

sys_close_fb = ss(sys_dis.A - sys_dis.B*K, Kw*sys_dis.B,sys_dis.C,0,Ts);
sys_open = ss(sys_dis.A,sys_dis.B,sys_dis.C,0);

% step(sys_close_fb);
% damp(sys_close);

%% Integration of error
Q_sys = [sys_dis.A zeros(2,1); -sys_dis.C*sys_dis.A 1];
h = [sys_dis.B; -sys_dis.C*sys_dis.B];

Q = diag([100,1,1]);
% R = 60;

R = 30;
[K_int,P,e] = dlqr(Q_sys,h,Q,R);
K_int
Q_close = [sys_dis.A - sys_dis.B*K_int(1:2) -K_int(end)*sys_dis.B;
    -sys_dis.C*sys_dis.A + sys_dis.C*sys_dis.B*K_int(1:2) 1+K_int(end)*sys_dis.C*sys_dis.B];

h_close = [zeros(2,1); 1];

C_close = [sys_dis.C 0];

sys_close_fb_int = ss(Q_close, h_close, C_close,0,Ts);

% --- place
% poles = [0.99, 0.8, 0.7];
% K_int = place(Q_sys,h,poles)

%% Build observer
poles_closed = pole(sys_close_fb_int);
poles_obsv = poles_closed(1:2)/12;
% poles_obsv = [0;0];
poles_obsv = [0.5;0.5];

P = sym('P',[2,1]);
syms z
F = sys_dis.A - P*sys_dis.C;
detF = det(z*eye(2) - F);
[C,T] = coeffs(detF,z,'all');
desirePoles = poly(poles_obsv);
SOL = solve(C == desirePoles);
P = double([SOL.P1;SOL.P2]);


 
