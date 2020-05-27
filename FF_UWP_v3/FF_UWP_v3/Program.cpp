#include "pch.h"
#include <Windows.Gaming.Input.h>
#include <Synchapi.h>
#include <Windows.Gaming.Input.ForceFeedback.h>
#include <windowsnumerics.h>
#include <array>

using namespace Platform;
using namespace Windows::Foundation;
using namespace Windows::Foundation::Collections;
using namespace Windows::Gaming::Input;
using namespace Windows::Gaming::Input::ForceFeedback;
using namespace concurrency;

// Variable declaration
RacingWheel^ wheel = nullptr;
ForceFeedback::ConstantForceEffect^ effect_minus;
ForceFeedback::ConstantForceEffect^ effect_plus;
bool effectInitialized = false;

std::vector<double> Values1;
std::vector<double> Values2;

void onRacingWheelAdded(Platform::Object^ sender, RacingWheel^ args) {
    wheel = args;
}

void initRacingWheel() {
    RacingWheel::RacingWheelAdded += ref new EventHandler<RacingWheel^>(&onRacingWheelAdded);

    while (true) {
        int size = RacingWheel::RacingWheels->Size;

        if (size == 0) {
            printf("Connecting...\n");
        }
        else {
            printf("Connected!\n");
            break;
        }
    }
}

void initForceFeedback(RacingWheel^ args, int samplingTime) {
    wheel = args;

    TimeSpan time;
    time.Duration = samplingTime;

    effect_minus = ref new ForceFeedback::ConstantForceEffect();
    effect_plus = ref new ForceFeedback::ConstantForceEffect();

    effect_minus->SetParameters(Windows::Foundation::Numerics::float3(-1.0, 0.0f, 0.0f), time);
    effect_plus->SetParameters(Windows::Foundation::Numerics::float3(+1.0, 0.0f, 0.0f), time);
    
    IAsyncOperation<ForceFeedbackLoadEffectResult>^ request1 = wheel->WheelMotor->LoadEffectAsync(effect_minus);

    auto task1 = create_task(request1);
    task1.then([](ForceFeedbackLoadEffectResult result) {
        if (ForceFeedbackLoadEffectResult::Succeeded == result)
        {
            printf("Effect loaded! \n");
        }
        else
        {
            printf("Effect failed! \n");
        }
        }).wait();

    IAsyncOperation<ForceFeedbackLoadEffectResult>^ request2 = wheel->WheelMotor->LoadEffectAsync(effect_plus);

    auto task2 = create_task(request2);
    task2.then([](ForceFeedbackLoadEffectResult result) {
        if (ForceFeedbackLoadEffectResult::Succeeded == result)
        {
            printf("Effect loaded! \n");
        }
        else
        {
            printf("Effect failed! \n");
        }
        }).wait();
}

void FF_minus(RacingWheel^ args, double powerGain) {
    RacingWheelReading reading = args->GetCurrentReading();
    RacingWheelButtons buttonValues = reading.Buttons;

    effect_minus->Gain = powerGain;

    if (RacingWheelButtons::Button1 == (buttonValues & RacingWheelButtons::Button1)) {
        effect_minus->Start();
    }
}

void FF_plus(RacingWheel^ args, double powerGain) {
    RacingWheelReading reading = args->GetCurrentReading();
    RacingWheelButtons buttonValues = reading.Buttons;

    effect_plus->Gain = powerGain;

    if (RacingWheelButtons::Button2 == (buttonValues & RacingWheelButtons::Button2)) {
        effect_plus->Start();
    }
}

std::vector<double> readingWheel(RacingWheel^ args, std::vector<double> wheelValues) {
    //get current reading
    RacingWheelReading reading = args->GetCurrentReading();
    ForceFeedback::ForceFeedbackMotor^ motor = wheel->WheelMotor;

    // Doubles
    auto throttleValue = reading.Throttle;
    auto brakeValue = reading.Brake;
    auto clutchValue = reading.Clutch;
    //auto handBrakeValue = reading.Handbrake;
    //auto patternShifterGearValue = reading.PatternShifterGear;
    auto wheelAngleValue = reading.Wheel;
    auto masterGainValue = motor->MasterGain;

    // unsigned long long
    //auto timeStampValue = reading.Timestamp;
    
    // bool
    //auto effectPausedValue = motor->AreEffectsPaused;
    //auto motorOnValue = motor->IsEnabled;

    wheelValues = {throttleValue, brakeValue, clutchValue, wheelAngleValue};
    return wheelValues;
}

std::vector<double> readingButton(RacingWheel^ args, std::vector<double> buttonOut) {
    //get current reading
    RacingWheelReading reading = args->GetCurrentReading();
    
    RacingWheelButtons buttonValues = reading.Buttons;

    // Bit Magic --> 0000010 for example means one button pressed...
    // and so on.

    // -------------------------------GEAR STUFF------------------------------------------------
    // -----------------------------------------------------------------------------------------
    if (RacingWheelButtons::NextGear == (buttonValues & RacingWheelButtons::NextGear)) {
        printf("gearup ");
    }

    if (RacingWheelButtons::PreviousGear == (buttonValues & RacingWheelButtons::PreviousGear)) {
        printf("geardown ");
    }

    // -----------------------------BUTTON STUFF------------------------------------------------
    // -----------------------------------------------------------------------------------------
    // BUTTON 1 == ST 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button1 == (buttonValues & RacingWheelButtons::Button1)) {
        printf("ST ");
    }

    // BUTTON 3 == SE
    // on Thrustmaster T300
    if (RacingWheelButtons::Button2 == (buttonValues & RacingWheelButtons::Button2)) {
        printf("SE ");
    }

    // BUTTON 3 == X 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button3 == (buttonValues & RacingWheelButtons::Button3)) {
        printf("X ");
    }

    // BUTTON 4 == O 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button4 == (buttonValues & RacingWheelButtons::Button4)) {
        printf("O ");
    }

    // BUTTON 5 == Square 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button5 == (buttonValues & RacingWheelButtons::Button5)) {
        printf("Square ");
    }

    // BUTTON 6 == Triangle 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button6 == (buttonValues & RacingWheelButtons::Button6)) {
        printf("Triangle ");
    }

    // BUTTON 7 == L2 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button7 == (buttonValues & RacingWheelButtons::Button7)) {
        printf("L2 ");
    }

    // BUTTON 8 == R2 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button8 == (buttonValues & RacingWheelButtons::Button8)) {
        printf("R2 ");
    }

    // BUTTON 9 == L3 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button9 == (buttonValues & RacingWheelButtons::Button9)) {
        printf("L3 ");
    }

    // BUTTON 10 == R3 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button10 == (buttonValues & RacingWheelButtons::Button10)) {
        printf("R3 ");
    }

    // ---------------------------------DPAD STUFF----------------------------------------------
    // -----------------------------------------------------------------------------------------
    if (RacingWheelButtons::DPadDown == (buttonValues & RacingWheelButtons::DPadDown)) {
        printf("DPadDown ");
    }

    if (RacingWheelButtons::DPadUp == (buttonValues & RacingWheelButtons::DPadUp)) {
        printf("DPadUp ");
    }

    if (RacingWheelButtons::DPadLeft == (buttonValues & RacingWheelButtons::DPadLeft)) {
        printf("DPadLeft ");
    }

    if (RacingWheelButtons::DPadRight == (buttonValues & RacingWheelButtons::DPadRight)) {
        printf("DPadRight ");
    }

    return buttonOut;
}

int main(Platform::Array<Platform::String^>^ args)
{   
    CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);

    initRacingWheel();
    initForceFeedback(wheel, 3000000);

    while (true) {
        if (wheel != nullptr) {

            Values1 = readingWheel(wheel, Values1);

            for (int i = 0; i < Values1.size(); i++) {
                printf("%f ", Values1[i]);
            }

            Values2 = readingButton(wheel, Values2);


            FF_minus(wheel, 1);
            FF_plus(wheel, 1);

            printf("\n");
        }
        Sleep(100);
    }

    return 0;
}