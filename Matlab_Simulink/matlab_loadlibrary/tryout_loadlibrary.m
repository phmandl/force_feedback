% ADD PATH OF .DLL
addpath('FF_UWP_Visual_Studio');

% load library
if not(libisloaded('FF_UWP_WIN32_dll'))
    loadlibrary('FF_UWP_WIN32_dll','FF_UWP_WIN32_dll.h');
end
libfunctions('FF_UWP_WIN32_dll')

% INIT RACING WHEEL WITH .DLL and set FORCE FEEDBACK
fprintf('Looking for a Racing Wheel! \n');

assert(calllib('FF_UWP_WIN32_dll','initRacingWheel') == true,...
    'No Racing Wheel found! Connect one!')
fprintf('Racing Wheel found! \n')

assert(calllib('FF_UWP_WIN32_dll','initForceFeedback') == 0,...
    'Problem with Force Feedback');
fprintf('Forece Feedback initialized! \n');

% INIT STURCTS FOR BUTTON AND WHEELREADINGS
WheelReadings = struct();
WheelReadings.throttle = 0;
WheelReadings.brake = 0;
WheelReadings.clutch = 0;
WheelReadings.angle = 0;
WheelReadings.mastergain = 0;
WheelReadings.timestamp = 0;

buttonReadings = struct();
buttonReadings.gearup = 0;
buttonReadings.geardown = 0;
buttonReadings.ST = 0;
buttonReadings.SE = 0;
buttonReadings.X = 0;
buttonReadings.O = 0;
buttonReadings.Square = 0;
buttonReadings.Triangle = 0;
buttonReadings.L2 = 0;
buttonReadings.R2 = 0;
buttonReadings.L3 = 0;
buttonReadings.R3 = 0;
buttonReadings.DPadDown = 0;
buttonReadings.DPadUp = 0;
buttonReadings.DPadLeft = 0;
buttonReadings.DPadRight = 0;

%% Lets plot the tryout
figure(1)
angle_container = [];
p1 = plot(NaN);
title('Limits (Horizontal Lines),\newline FF-Minus (Vertical -- Line),\newline FF-Plus (Vertical - Line)');
ylim([-1.1,1.1]);
ylabel('Wheel Angle');
xlabel('Sample');
yline(-1,'r-');
yline(1,'r-');

%% Create a loop
while true
    % REED WHEEL AND BUTTONS
    buttonReadings = calllib('FF_UWP_WIN32_dll','readingButton',buttonReadings);
    WheelReadings = calllib('FF_UWP_WIN32_dll','readWheelStatus',WheelReadings);
    
    % FIGURE STUFF - SAVE DATA
    angle_container = [angle_container,WheelReadings.angle];
        
    % FORCE-FEEDBACK STUFF -> DO SOMETHING ON BUTTON ACTION
    calllib('FF_UWP_WIN32_dll','FF_zero')
    if buttonReadings.X == true
        calllib('FF_UWP_WIN32_dll','FF_minus',0.5)
        xline(length(angle_container),'--');
    elseif buttonReadings.O == true
        calllib('FF_UWP_WIN32_dll','FF_plus',0.5)
        xline(length(angle_container),'-');
    end
    
    % UPDATE FIGURE
    set(p1,'YData',angle_container);
    
    % PAUSE
    pause(0.01);
end
