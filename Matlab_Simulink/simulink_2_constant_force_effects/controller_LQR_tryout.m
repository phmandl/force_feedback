clear; clc;

%% Controller Script
J = 1/8;
A = [0 1; 0 0];
B = [0; 1/J];
C = [1 0];

Q = diag([5,5]);
R = 10;

[K,P,e] = lqr(A,B,Q,R);
Kw = 1/(C*inv(eye(2) - A + B*K)*B);

ss_close = ss(A-B*K,Kw*B,C,0);
ss_open = ss(A,B,C,0);

damp(ss_close)
