[A,B,C,D] = tf2ss(amx2221.B,amx2221.A);

Q = diag([1,1]);
R = 1e6;

[K,P,E] = dlqr(A,B,Q,R,0);
Kw = 1/(C*(eye(2)-(A-B*K))^(-1)*B);

step(ss(A-B*K,Kw*B,C,0,amx2221.Ts))
