#include "pch.h"

#include <winrt/Windows.Foundation.h>
#include <winrt/Windows.Foundation.Collections.h>

#include <winrt/Windows.Gaming.Input.h>
#include <winrt/Windows.Gaming.Input.ForceFeedback.h>

// imported from previous uwp app
//#include <windowsnumerics.h>

using namespace winrt;
using namespace Windows::Foundation;
using namespace Windows::Gaming::Input;
using namespace Windows::Gaming::Input::ForceFeedback;
//using namespace concurrency;


// Do some variable declaration
RacingWheel wheel = nullptr;

ForceFeedback::ConstantForceEffect effect;
bool effectInitialized = false;

void onRacingWheelAdded(IInspectable const& sender, RacingWheel const& args) {
    printf("Hello");
}

int main()
{
    init_apartment();

    bool condition = true;
    while (condition) {
        int size = RacingWheel::RacingWheels().Size();

        if (size > 0) {
            printf("Connected!\n");
            break;
        }
        else {
            printf("Connecting...\n");
        }
    }

    //RacingWheel::RacingWheelAdded(onRacingWheelAdded);
    //RacingWheel::RacingWheelAdded();

    RacingWheel::RacingWheelAdded()

    //racingwheel::RacingWheelAdded = EventHandler<RacingWheel>(&onRacingWheelAdded);

    //RacingWheel::RacingWheelAdded(IInspectable const& sender, RacingWheel const& args)
    //{
    //
        //cingWheel::RacingWheelAdded += ref new EventHandler<RacingWheel^>(&onRacingWheelAdded);

        //RacingWheelReading reading = args->GetCurrentReading();

}