//
// MainPage.xaml.cpp
// Implementation of the MainPage class.
//

#include "pch.h"
#include "MainPage.xaml.h"
#include <Windows.Gaming.Input.h>
#include <ppltasks.h>
#include <Synchapi.h>
#include <Windows.Gaming.Input.ForceFeedback.h>
#include <windowsnumerics.h>

using namespace FF_App_UWP_TU_Wien;

using namespace Platform;
using namespace Windows::Foundation;
using namespace Windows::Foundation::Collections;
using namespace Windows::UI::Xaml;
using namespace Windows::UI::Xaml::Controls;
using namespace Windows::UI::Xaml::Controls::Primitives;
using namespace Windows::UI::Xaml::Data;
using namespace Windows::UI::Xaml::Input;
using namespace Windows::UI::Xaml::Media;
using namespace Windows::UI::Xaml::Navigation;
using namespace Windows::Gaming::Input;
using namespace Windows::Gaming::Input::ForceFeedback;

using namespace concurrency;


// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=402352&clcid=0x409

// Variable declaration
TextBlock^ output;
TextBlock^ wheelPropertiesText;

RacingWheel^ wheel = nullptr;

ForceFeedback::ConstantForceEffect^ effect;
bool effectInitialized = false;

// Appends text in Mainpage
void append(String^ text) {
	output->Dispatcher->RunAsync(Windows::UI::Core::CoreDispatcherPriority::Normal,
		ref new Windows::UI::Core::DispatchedHandler([text]
			{
				output->Text = output->Text + "\n";
				output->Text = output->Text + text;
			}));
}

void updateWheelProp(RacingWheel^ args) {
	wheelPropertiesText->Dispatcher->RunAsync(Windows::UI::Core::CoreDispatcherPriority::Normal,
		ref new Windows::UI::Core::DispatchedHandler([args]
			{
				RacingWheelReading reading = args->GetCurrentReading();
				ForceFeedback::ForceFeedbackMotor^ motor = wheel->WheelMotor;
				wheelPropertiesText->Text = "";
				wheelPropertiesText->Text = "Brake: " + reading.Brake
					+ "\n" + "Clutch: " + reading.Clutch
					+ "\n" + "Handbrake: " + reading.Handbrake
					+ "\n" + "PatternShifterGear: " + reading.PatternShifterGear
					+ "\n" + "Throttle: " + reading.Throttle
					+ "\n" + "Wheel-angle: " + reading.Wheel
					+ "\n" + "State was retrieved at: " + reading.Timestamp
					+ "\n" + "Feedback motor status: " + motor->IsEnabled
					+ "\n" + "Feedback effects paused: " + motor->AreEffectsPaused
					+ "\n" + "Feedback master gain: " + motor->MasterGain
					+ "\n" + "Supported axes: " + motor->SupportedAxes.ToString();

			}));
}

void onRacingWheelAdded(Platform::Object^ sender, RacingWheel^ args) {
	wheel = args;

	effect = ref new ForceFeedback::ConstantForceEffect();
	TimeSpan time;
	time.Duration = 3000000;

	effect->SetParameters(Windows::Foundation::Numerics::float3(-1.0f, 0.0f, 0.0f), time);
	IAsyncOperation<ForceFeedbackLoadEffectResult>^ request = wheel->WheelMotor->LoadEffectAsync(effect);

	auto task = create_task(request);
	task.then(
		[](ForceFeedbackLoadEffectResult result) {
			append("Result of force feedback request: " + result.ToString());
			effectInitialized = true;
		}
	);
}

void FF_App_UWP_TU_Wien::MainPage::voigasbutton_Click(Platform::Object^ sender, Windows::UI::Xaml::RoutedEventArgs^ e)
{
	append("Voigas!");
	if (effectInitialized) {
		effect->Start();
	}

}

MainPage::MainPage()
{
	InitializeComponent();
	wheelPropertiesText = wheelprop;
	output = asdf;
	output->Text = "";

	int size = RacingWheel::RacingWheels->Size;
	append(size + "");

	RacingWheel::RacingWheelAdded += ref new EventHandler<RacingWheel^>(&onRacingWheelAdded);

	task<void> wheelquery = create_task(
		[] {
			append("Starting update loop");
			while (true) {
				if (wheel != nullptr) {
					updateWheelProp(wheel);
				}
				Sleep(100);
			}
		}
	);

	//printf("Size: %d \n", RacingWheel::RacingWheels().Size());
	//RacingWheel::RacingWheels().Count
	//sprintf(msgbuf, "My variable is %d\n", integerVariable);
	//Windows::System::Diagnostics::DE
	//OutputDebugString(L"asdfasdf");
}
