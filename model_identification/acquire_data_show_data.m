%% Addpath for simulink-files
addpath('Racing_Wheel_Simulink_Files');

%% Load Data
load('data_run1');
% load('data_run2');
% load('data_with_bounce_back');

%% Pre-Processing
y = data.output;
u = data.input;
t = data.time;
dt = t(2) - t(1);

%% Calculate velocity
udot_num_noisy = [diff(y)/dt;0];
kernel_smoothing = [1 1 1 1] / norm([1 1 1 1])^2;

u_smoothened = conv(y,kernel_smoothing,'same');

udot_smoothing_num_noisy = [diff(u_smoothened)/dt;0];
udot_smoothing_num_noisy(1) = 0;
udot_smoothing_num_noisy(end-10:end) = 0;

%% Plot data
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
