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

bool* p;

typedef struct wheelreadings {
    double throttle;
    double brake;
    double clutch;
    double angle;
    double mastergain;
} WheelReadings;

typedef struct buttonReadings {
    bool gearup;
    bool geardown;
    bool ST;
    bool SE;
    bool X;
    bool O;
    bool Square;
    bool Triangle;
    bool L2;
    bool R2;
    bool L3;
    bool R3;
    bool DPadDown;
    bool DPadUp;
    bool DPadLeft;
    bool DPadRight;
} buttonReadings;

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
    effect_minus->Start();

}

void FF_plus(double powerGain) {
    RacingWheelReading reading = wheel->GetCurrentReading();
    RacingWheelButtons buttonValues = reading.Buttons;

    effect_plus->Gain = powerGain;
    effect_plus->Start();
}

void readingButton(buttonReadings* bValues) {
    //get current reading
    RacingWheelReading reading = wheel->GetCurrentReading();
    RacingWheelButtons buttonValues = reading.Buttons;

    // Bit Magic --> 0000010 for example means one button pressed...
    // and so on.

    // -------------------------------GEAR STUFF------------------------------------------------
    // -----------------------------------------------------------------------------------------
    if (RacingWheelButtons::NextGear == (buttonValues & RacingWheelButtons::NextGear)) {
        //printf("gearup ");
        bValues->gearup = true;
    }
    else {
        bValues->gearup = false;
    }

    if (RacingWheelButtons::PreviousGear == (buttonValues & RacingWheelButtons::PreviousGear)) {
        //printf("geardown ");
        bValues->geardown = true;
    }
    else {
        bValues->geardown = false;
    }

    // -----------------------------BUTTON STUFF------------------------------------------------
    // -----------------------------------------------------------------------------------------
    // BUTTON 1 == ST 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button1 == (buttonValues & RacingWheelButtons::Button1)) {
        //printf("ST ");
        bValues->ST = true;
    }
    else {
        bValues->ST = false;
    }

    // BUTTON 3 == SE
    // on Thrustmaster T300
    if (RacingWheelButtons::Button2 == (buttonValues & RacingWheelButtons::Button2)) {
        //printf("SE ");
        bValues->SE = true;
    }
    else {
        bValues->SE = false;
    }

    // BUTTON 3 == X 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button3 == (buttonValues & RacingWheelButtons::Button3)) {
        //printf("X ");
        bValues->X = true;
    }
    else {
        bValues->X = false;
    }

    // BUTTON 4 == O 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button4 == (buttonValues & RacingWheelButtons::Button4)) {
        //printf("O ");
        bValues->O = true;
    }
    else {
        bValues->O = false;
    }

    // BUTTON 5 == Square 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button5 == (buttonValues & RacingWheelButtons::Button5)) {
        //printf("Square ");
        bValues->Square = true;
    }
    else {
        bValues->Square = false;
    }

    // BUTTON 6 == Triangle 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button6 == (buttonValues & RacingWheelButtons::Button6)) {
        //printf("Triangle ");
        bValues->Triangle = true;
    }
    else {
        bValues->Triangle = false;
    }

    // BUTTON 7 == L2 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button7 == (buttonValues & RacingWheelButtons::Button7)) {
        //printf("L2 ");
        bValues->L2 = true;
    }
    else {
        bValues->L2 = false;
    }

    // BUTTON 8 == R2 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button8 == (buttonValues & RacingWheelButtons::Button8)) {
        //printf("R2 ");
        bValues->R2 = true;
    }
    else {
        bValues->R2 = false;
    }

    // BUTTON 9 == L3 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button9 == (buttonValues & RacingWheelButtons::Button9)) {
        //printf("L3 ");
        bValues->L3 = true;
    }
    else {
        bValues->L3 = false;
    }

    // BUTTON 10 == R3 
    // on Thrustmaster T300
    if (RacingWheelButtons::Button10 == (buttonValues & RacingWheelButtons::Button10)) {
        //printf("R3 ");
        bValues->R3 = true;
    }
    else {
        bValues->R3 = false;
    }

    // ---------------------------------DPAD STUFF----------------------------------------------
    // -----------------------------------------------------------------------------------------
    if (RacingWheelButtons::DPadDown == (buttonValues & RacingWheelButtons::DPadDown)) {
        //printf("DPadDown ");
        bValues->DPadDown = true;
    }
    else {
        bValues->DPadDown = false;
    }

    if (RacingWheelButtons::DPadUp == (buttonValues & RacingWheelButtons::DPadUp)) {
        //printf("DPadUp ");
        bValues->DPadUp = true;
    }
    else {
        bValues->DPadUp = false;
    }

    if (RacingWheelButtons::DPadLeft == (buttonValues & RacingWheelButtons::DPadLeft)) {
        //printf("DPadLeft ");
        bValues->DPadLeft = true;
    }
    else {
        bValues->DPadLeft = false;
    }

    if (RacingWheelButtons::DPadRight == (buttonValues & RacingWheelButtons::DPadRight)) {
        //printf("DPadRight ");
        bValues->DPadRight = true;
    }
    else {
        bValues->DPadRight = false;
    }
}

int main(Platform::Array<Platform::String^>^ args)
{
    CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);

    initRacingWheel();
    initForceFeedback(3000000);

    WheelReadings readings;
    buttonReadings bReadings;

    while (true) {
        readWheelStatus(&readings);
        readingButton(&bReadings);
        
        printf("Angle: %lf ", readings.angle);
        printf("Brake: %lf ", readings.brake);
        printf("Throttle: %lf \n", readings.throttle);

        if (bReadings.X == true) {
            FF_minus(1.0);
        }

        if (bReadings.O == true) {
            FF_plus(1.0);
        }

        // Read the whole struct with pointers and print it
        p = (bool*)&bReadings;
        int i;
        for (i = 0; i < 16; i = i + 1) {
            printf("Button Nr. %d: %d\n", i+1, *(p + i));
        }

        printf("\n");
        Sleep(100);
    }

    return 0;
}

