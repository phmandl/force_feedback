
load('Experiment_U_step.mat');

y = out.Data.Data(:,2)';
u = out.Data.Data(:,1)';
t = out.tout';
dt = 0.01;

udot_num_noisy = [diff(y)/dt 0];

kernel_smoothing = [1 1 1 1] / norm([1 1 1 1])^2;
u_smoothened = conv(y,kernel_smoothing,'same');

udot_smoothing_num_noisy = [diff(u_smoothened)/dt 0];

figure; plot(t,y); grid on
hold on; plot(t,u_smoothened,'r-','LineWidth',2);
xlabel('time');
ylabel('u, u noisy, u smoothened');

figure;
plot(t,udot_num_noisy,'k-','DisplayName', 'udot num noisy'); hold on; grid on;
plot(t,udot_smoothing_num_noisy,'r-','LineWidth',2,'DisplayName','udot num smoothened');
plot(t,u,'DisplayName','u');
xlabel('time');
ylabel('udot, udot num noisy, udot num smoothened');
legend('show')
