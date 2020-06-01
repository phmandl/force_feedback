#include "pch.h"

int main(Platform::Array<Platform::String^>^ args)
{   
    CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);

    initRacingWheel();
    initForceFeedback(3000000);

    WheelReadings readings;

    while (true) {
        readWheelStatus(&readings);

        printf("Angle: %lf", readings.angle);

        FF_minus(1.0);

        printf("\n");
        Sleep(100);
    }

    return 0;
}