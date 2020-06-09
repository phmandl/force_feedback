% clibgen.generateLibraryDefinition("FF_UWP_WIN32_dll.h","Libraries","FF_UWP_WIN32_dll.lib")
% build(defineFF_UWP_WIN32_dll)
% 

figure(1)
angle_container = [];
p1 = plot(NaN);
title('Wheel Angle');
ylabel('Angle');
xlabel('Sample');

addpath('FF_UWP_WIN32_dll');

clib.FF_UWP_WIN32_dll.initRacingWheel
clib.FF_UWP_WIN32_dll.initForceFeedback(3000000)

buttonReadings = clib.FF_UWP_WIN32_dll.buttonReadings;
WheelReadings = clib.FF_UWP_WIN32_dll.WheelReadings;

while true
    clib.FF_UWP_WIN32_dll.readingButton(buttonReadings);
    clib.FF_UWP_WIN32_dll.readWheelStatus(WheelReadings);
    angle_container = [angle_container,WheelReadings.angle];
    
    if buttonReadings.X == true
        clib.FF_UWP_WIN32_dll.FF_minus(0.5)
    elseif buttonReadings.O == true
        clib.FF_UWP_WIN32_dll.FF_plus(0.5)
    end
    
    set(p1,'YData',angle_container);
    pause(0.01);
end