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
	} WheelReadings;

	// Initialize the racing wheel
	FF_UWP_API void initRacingWheel();
	//FF_UWP_API int initForceFeedback(int samplingTime);
	//FF_UWP_API void readWheelStatus(WheelReadings* wheelValues);
	//FF_UWP_API void FF_minus(double gain);
}
#else
typedef struct wheelreadings {
	double throttle;
	double brake;
	double clutch;
	double angle;
	double mastergain;
} WheelReadings;

// Initialize the racing wheel
FF_UWP_API void initRacingWheel();
//FF_UWP_API int initForceFeedback(int samplingTime);
//FF_UWP_API void readWheelStatus(WheelReadings* wheelValues);
//FF_UWP_API void FF_minus(double gain);
#endif