syms a b x
A = [0 1; 0 -b];
B = [0; a];
C = [1 0];

T = 0.01;

G = expm(A*T)
h = int(expm(A*x),x)*B