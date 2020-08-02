% ADD PATH OF .DLL
addpath('FF_UWP_WIN32_dll');

% INIT RACING WHEEL WITH .DLL and set FORCE FEEDBACK
Ts = 0.1*1e7; % in 100ns Ticks
fprintf('Looking for a Racing Wheel! \n');
assert(clib.FF_UWP_WIN32_dll.initRacingWheel == true,...
    'No Racing Wheel found! Connect one!')
fprintf('Racing Wheel found! \n')
assert(clib.FF_UWP_WIN32_dll.initForceFeedback(Ts) == 0,...
    'Problem with Force Feedback');
fprintf('Forece Feedback initialized! \n');

% INIT STURCTS FOR BUTTON AND WHEELREADINGS
buttonReadings = clib.FF_UWP_WIN32_dll.buttonReadings;
WheelReadings = clib.FF_UWP_WIN32_dll.WheelReadings;

% DO SOME FIGURE STUFF TO SHOW DATA
figure(1)
angle_container = [];
p1 = plot(NaN);
title('Limits (Horizontal Lines),\newline FF-Minus (Vertical -- Line),\newline FF-Plus (Vertical - Line)');
ylim([-1.1,1.1]);
ylabel('Wheel Angle');
xlabel('Sample');
yline(-1,'r-');
yline(1,'r-');

figure(2)
time_container = [];
p2 = plot(NaN);

% LOOP OVER EVERYTHING
while true
    % REED WHEEL AND BUTTONS
    clib.FF_UWP_WIN32_dll.readingButton(buttonReadings);
    clib.FF_UWP_WIN32_dll.readWheelStatus(WheelReadings);
    
    % FIGURE STUFF - SAVE DATA
    angle_container = [angle_container,WheelReadings.angle];
    time_container = [time_container, WheelReadings.timestamp]; 
    
    % FORCE-FEEDBACK STUFF -> DO SOMETHING ON BUTTON ACTION
    if buttonReadings.X == true
        clib.FF_UWP_WIN32_dll.FF_minus(0.5)
        xline(length(angle_container),'--');
    elseif buttonReadings.O == true
        clib.FF_UWP_WIN32_dll.FF_plus(0.5)
        xline(length(angle_container),'-');
    end
    
    % UPDATE FIGURE
    set(p1,'YData',angle_container);
    set(p2,'YData',time_container);  
    
    % PAUSE
    pause(0.01);
end