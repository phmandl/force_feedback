if libisloaded('FF_UWP_WIN32_dll')
    calllib('FF_UWP_WIN32_dll','kill_FF');
    unloadlibrary('FF_UWP_WIN32_dll');
end

% load the library
loadlibrary('FF_UWP_WIN32_dll','FF_UWP_WIN32_dll.h')

libfunctions('FF_UWP_WIN32_dll')

% Init Wheel
calllib('FF_UWP_WIN32_dll','initRacingWheel')
calllib('FF_UWP_WIN32_dll','initForceFeedback')

% Get Wheelreadings
wheelreadings.throttle = 0;
wheelreadings.brake = 0;
wheelreadings.clutch = 0;
wheelreadings.angle = 0;
wheelreadings.mastergain = 0;
wheelreadings.timestamp = 0;

wheelreadings = calllib('FF_UWP_WIN32_dll','readWheelStatus',wheelreadings)

% Get ButtonReadings
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

buttonReadings = calllib('FF_UWP_WIN32_dll','readingButton',buttonReadings)

% FORCE-FEEDBACK
calllib('FF_UWP_WIN32_dll','FF_minus',0.2)
calllib('FF_UWP_WIN32_dll','FF_plus',0.2)
calllib('FF_UWP_WIN32_dll','FF_zero')

% KILL FORCEFEEDBACK
calllib('FF_UWP_WIN32_dll','kill_FF')