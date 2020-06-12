% ADD PATH OF .DLL
addpath('FF_UWP_WIN32_dll');

% INIT RACING WHEEL WITH .DLL and set FORCE FEEDBACK
Ts = 0.01; % in s
fprintf('Looking for a Racing Wheel! \n');
assert(clib.FF_UWP_WIN32_dll.initRacingWheel == true,...
    'No Racing Wheel found! Connect one!')
fprintf('Racing Wheel found! \n')
assert(clib.FF_UWP_WIN32_dll.initForceFeedback(Ts*1e9) == 0,...
    'Problem with Force Feedback');
fprintf('Force Feedback initialized! \n');

% INIT STURCTS FOR BUTTON AND WHEELREADINGS
buttonReadings = clib.FF_UWP_WIN32_dll.buttonReadings;
WheelReadings = clib.FF_UWP_WIN32_dll.WheelReadings;

figure(1)
angle_container = [];
FF_container = [];
p1 = plot(NaN); hold on;
ylim([-1.1,1.1]);
ylabel('Wheel Angle');
xlabel('Sample');

Kp = C1.Kp;
Ki = C1.Ki;
Kd = C1.Kd;

w = 0;
e_km1 = 0;
e_km2 = 0;
u_km1 = 0;

%% LOOPING
counter = 0;
while true
    % REED WHEEL AND BUTTONS
    clib.FF_UWP_WIN32_dll.readingButton(buttonReadings);
    clib.FF_UWP_WIN32_dll.readWheelStatus(WheelReadings);
    
    e = w - WheelReadings.angle;
    u_k = u_km1 + (Kp + Ki*Ts + Kd/Ts)*e - 2*Kd/Ts*e_km1 + Kd/Ts*e_km2;
   
    if u_k > 1
        u_k = 1;
    elseif u_k < -1
        u_k = -1;
    end
    
    % FORCE-FEEDBACK STUFF -> DO SOMETHING ON BUTTON ACTION
    if u_k >= 0
        clib.FF_UWP_WIN32_dll.FF_plus(u_k);
    elseif u_k < 0
        clib.FF_UWP_WIN32_dll.FF_minus(-u_k);
    end
    
    if counter == 0
        e_km1 = e;
        u_km1 = u_k;
    else
        e_km2 = e_km1;
        e_km1 = e;
        u_km1 = u_k;
    end
    counter = counter + 1;
    
    angle_container = [angle_container;WheelReadings.angle];
    % UPDATE FIGURE
    set(p1,'YData',angle_container);
    
    if buttonReadings.X == true
        close all;
        break
    end
    
    % PAUSE
    pause(Ts);
end
