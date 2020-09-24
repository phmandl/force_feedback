#include <iostream>
#include <FF_WIN32_dll.h>
#include <Windows.h>

bool* p;

int main(Platform::Array<Platform::String^>^ args)
{
    CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);

    initRacingWheel();
    initForceFeedback();

    WheelReadings readings;
    buttonReadings bReadings;

    while (true) {
        readWheelStatus(&readings);
        readingButton(&bReadings);

        printf("Angle: %lf ", readings.angle);
        printf("Brake: %lf ", readings.brake);
        printf("Throttle: %lf \n", readings.throttle);

        FF_zero();

        if (bReadings.X == true) {
            FF_minus(0.5);
        }

        if (bReadings.O == true) {
            FF_plus(0.5);
        }

        // Read the whole struct with pointers and print it
        p = (bool*)&bReadings;
        int i;
        for (i = 0; i < 16; i = i + 1) {
            printf("Button Nr. %d: %d\n", i + 1, *(p + i));
        }

        printf("\n");
        Sleep(100);
    }

    return 0;
}