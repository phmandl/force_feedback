function [dx, y] = FF_wheel(t, x, u, J, d, steepness, e, varargin)
%DCMOTOR_M  ODE file representing the dynamics of a motor.
% The same DC-motor that was modeled by IDGREY; see IDDEMO7.

%   Copyright 2005-2014 The MathWorks, Inc.

% Output equations.
% y = [x(1);
%      x(2)];% Angular position
 
% y = [x(2)];% Angular position

y = [x(1)];% Angular position

% State equations.
dx = [x(2);                        ... % Angular velocity.
%       (1/J)*( u(1) - d*x(2) )    ... % Angular acceleration.
      (1/J)*( u(1) - d*(2/(1 + exp(-steepness*x(2)) ) - 1) - e*x(2) )
     ];
  