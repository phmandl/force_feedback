% ADD PATH OF .DLL
addpath('FF_UWP_WIN32_dll');

% INIT RACING WHEEL WITH .DLL and set FORCE FEEDBACK
Ts = 3000000;
clib.FF_UWP_WIN32_dll.initRacingWheel
clib.FF_UWP_WIN32_dll.initForceFeedback(Ts)

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

% LOOP OVER EVERYTHING
while true
    % REED WHEEL AND BUTTONS
    clib.FF_UWP_WIN32_dll.readingButton(buttonReadings);
    clib.FF_UWP_WIN32_dll.readWheelStatus(WheelReadings);
    
    % FIGURE STUFF - SAVE DATA
    angle_container = [angle_container,WheelReadings.angle];
    
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
    
    % PAUSE
    pause(0.01);
end