counter = 1;
N = 1000;
Ts = 0.01;
Band = [0 1];
Range = [-1 1];

% u = idinput(N,'sine',Band,Range);
% u = idinput(N,'prbs',Band,Range);
% u = idinput(N,'rgs',Band,Range);
u = iddata([],u,Ts);

% save(['data_',datestr(now,'HH_MM_SS')],'out');
% plot(out.saveData.Data(:,2)) %OUTÜUT
% plot(out.saveData.Data(:,1)) %INPUT