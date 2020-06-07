#include <windows.h>
#include <collection.h>
#include <ppltasks.h>
#include <iostream>
#include <Synchapi.h>
#include <windowsnumerics.h>
#include <windows.foundation.collections.h>
#include <Windows.Gaming.Input.ForceFeedback.h>
#include <Windows.Gaming.Input.h>

using namespace Platform;
using namespace Windows::Foundation;
using namespace Windows::Foundation::Collections;
using namespace Windows::Gaming::Input;
using namespace Windows::Gaming::Input::ForceFeedback;
using namespace concurrency;

RacingWheel^ wheel = nullptr;
ForceFeedback::ConstantForceEffect^ effect_minus;
ForceFeedback::ConstantForceEffect^ effect_plus;
bool effectInitialized = false;

typedef struct wheelreadings {
    double throttle;
    double brake;
    double clutch;
    double angle;
    double mastergain;
} WheelReadings;

void onRacingWheelAdded(Platform::Object^ sender, RacingWheel^ args) {
    wheel = args;
}

void initRacingWheel()
{
    RacingWheel::RacingWheelAdded += ref new EventHandler<RacingWheel^>(&onRacingWheelAdded);

    while (true) {
        int size = RacingWheel::RacingWheels->Size;

        if (size == 0) {
            std::cout << "Connecting...\n";
        }
        else {
            std::cout << "Connected!\n";
            break;
        }

        Sleep(10);
    }
}

int initForceFeedback(int samplingTime) {
    TimeSpan time;
    time.Duration = samplingTime;

    effect_minus = ref new ForceFeedback::ConstantForceEffect();
    effect_plus = ref new ForceFeedback::ConstantForceEffect();

    effect_minus->SetParameters(Windows::Foundation::Numerics::float3(-1.0, 0.0f, 0.0f), time);
    effect_plus->SetParameters(Windows::Foundation::Numerics::float3(+1.0, 0.0f, 0.0f), time);

    IAsyncOperation<ForceFeedbackLoadEffectResult>^ request1 = wheel->WheelMotor->LoadEffectAsync(effect_minus);

    int error = 0;

    auto task1 = create_task(request1);
    task1.then([&error](ForceFeedbackLoadEffectResult result) {
        if (ForceFeedbackLoadEffectResult::Succeeded == result)
        {
            printf("Effect loaded! \n");
        }
        else
        {
            error = -1;
        }
        }).wait();

    IAsyncOperation<ForceFeedbackLoadEffectResult>^ request2 = wheel->WheelMotor->LoadEffectAsync(effect_plus);

    auto task2 = create_task(request2);
    task2.then([&error](ForceFeedbackLoadEffectResult result) {
        if (ForceFeedbackLoadEffectResult::Succeeded == result)
        {
            printf("Effect loaded! \n");
        }
        else
        {
            error = -1;
        }
        }).wait();

        return error;
}

void readWheelStatus(WheelReadings* wheelValues) {
    //get current reading
    RacingWheelReading reading = wheel->GetCurrentReading();
    ForceFeedback::ForceFeedbackMotor^ motor = wheel->WheelMotor;

    wheelValues->throttle = reading.Throttle;
    wheelValues->brake = reading.Brake;
    wheelValues->clutch = reading.Clutch;
    wheelValues->angle = reading.Wheel;
    wheelValues->mastergain = motor->MasterGain;
}

void FF_minus(double powerGain) {
    RacingWheelReading reading = wheel->GetCurrentReading();
    RacingWheelButtons buttonValues = reading.Buttons;

    effect_minus->Gain = powerGain;

    if (RacingWheelButtons::Button1 == (buttonValues & RacingWheelButtons::Button1)) {
        effect_minus->Start();
    }
}

int main(Platform::Array<Platform::String^>^ args)
{
    CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);

    initRacingWheel();
    initForceFeedback(3000000);

    WheelReadings readings;

    while (true) {
        readWheelStatus(&readings);

        printf("Angle: %lf ", readings.angle);
        printf("Brake: %lf ", readings.brake);
        printf("Throttle: %lf ", readings.throttle);

        FF_minus(1.0);

        printf("\n");
        Sleep(100);
    }

    return 0;
}

