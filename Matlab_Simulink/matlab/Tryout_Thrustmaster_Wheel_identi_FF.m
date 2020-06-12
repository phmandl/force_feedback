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

% DO SOME FIGURE STUFF TO SHOW DATA
figure(1)
angle_container = [];
FF_container = [];
p1 = plot(NaN); hold on;
p2 = plot(NaN); hold off;
title('Limits (Horizontal Lines),\newline FF-Minus (Vertical -- Line),\newline FF-Plus (Vertical - Line)');
ylim([-1.1,1.1]);
ylabel('Wheel Angle');
xlabel('Sample');
yline(-1,'r-');
yline(1,'r-');

% LOOP OVER EVERYTHING
counter = 1;
N = 1000;
Band = [0 0.5];
Range = [-1 1];
u = idinput(N,'prbs',Band,Range);

while true
    currentFF = u(counter);
    
    % REED WHEEL AND BUTTONS
    clib.FF_UWP_WIN32_dll.readingButton(buttonReadings);
    clib.FF_UWP_WIN32_dll.readWheelStatus(WheelReadings);
    
    % FIGURE STUFF - SAVE DATA
    FF_container = [FF_container;currentFF];
    angle_container = [angle_container;WheelReadings.angle];
        
    % FORCE-FEEDBACK STUFF -> DO SOMETHING ON BUTTON ACTION
    if currentFF >= 0
        clib.FF_UWP_WIN32_dll.FF_minus(currentFF);
    elseif currentFF < 0
        clib.FF_UWP_WIN32_dll.FF_plus(-currentFF);
    end
    
    % PAUSE
    pause(Ts);
    
    % UPDATE FIGURE
    set(p1,'YData',angle_container);
    set(p2,'YData',FF_container);

    counter = counter + 1;
    
    if counter == N
        break;
    end
end

save(['data_',datestr(now,'HH_MM_SS')],'FF_container','angle_container');