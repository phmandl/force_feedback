clear; clc;
close all;

addpath('Steering_Wheel_Simulink_Files');

%% FOR PID AND IMPEDANZ-CONTROL
K_angle = deg2rad(1080); % Angle gain from [-1,1]
K_Moment = 4.45; %Gainf for motor_moment_input [-1,1]
N = 3; %Filter for xdot, xddot
Ts = 0.05;
% Ts = 0.01;

% Var = 7.5924; %1/J
J = 0.1317/K_angle;


