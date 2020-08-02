#pragma once

#ifdef FF_UWP_EXPORTS
#define FF_UWP_API __declspec(dllexport)
#else
#define FF_UWP_API __declspec(dllimport)
#endif

#ifdef __cplusplus
extern "C" {
    typedef struct wheelreadings {
        double throttle;
        double brake;
        double clutch;
        double angle;
        double mastergain;
        unsigned long long timestamp;
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

	// Initialize the racing wheel
	FF_UWP_API bool initRacingWheel();
	FF_UWP_API int initForceFeedback(int64 samplingTime);
	FF_UWP_API void readWheelStatus(WheelReadings* wheelValues);
	FF_UWP_API void FF_minus(double gain);
    FF_UWP_API void FF_plus(double gain);
	FF_UWP_API void FF_zero();
    FF_UWP_API void readingButton(buttonReadings* bValues);
	FF_UWP_API void kill_FF();
}
#else
    typedef struct wheelreadings {
        double throttle;
        double brake;
        double clutch;
        double angle;
        double mastergain;
        unsigned long long timestamp;
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

    // Initialize the racing wheel
    FF_UWP_API bool initRacingWheel();
    FF_UWP_API int initForceFeedback(int64 samplingTime);
    FF_UWP_API void readWheelStatus(WheelReadings* wheelValues);
    FF_UWP_API void FF_minus(double gain);
    FF_UWP_API void FF_plus(double gain);
	FF_UWP_API void FF_zero();
    FF_UWP_API void readingButton(buttonReadings* bValues);
	FF_UWP_API void kill_FF();
#endif