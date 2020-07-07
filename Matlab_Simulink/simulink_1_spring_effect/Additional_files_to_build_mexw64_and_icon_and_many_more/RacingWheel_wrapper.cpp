
/*
 * Include Files
 *
 */
#if defined(MATLAB_MEX_FILE)
#include "tmwtypes.h"
#include "simstruc_types.h"
#else
#include "rtwtypes.h"
#endif



/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include <FF_UWP_WIN32_dll.h>

struct wheelreadings wheelValues;
struct buttonReadings buttonValues;
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 1
#define y_width 1

/*
 * Create external references here.  
 *
 */
/* %%%-SFUNWIZ_wrapper_externs_Changes_BEGIN --- EDIT HERE TO _END */
/* extern double func(double a); */
/* %%%-SFUNWIZ_wrapper_externs_Changes_END --- EDIT HERE TO _BEGIN */

/*
 * Start function
 *
 */
void RacingWheel_Start_wrapper(const real_T *Ts_Block, const int_T p_width0)
{
/* %%%-SFUNWIZ_wrapper_Start_Changes_BEGIN --- EDIT HERE TO _END */
/*
 * Custom Start code goes here.
 */

initRacingWheel();
initForceFeedback(); // Ts are ticks, 1 Tick are 100 ns
/* %%%-SFUNWIZ_wrapper_Start_Changes_END --- EDIT HERE TO _BEGIN */
}
/*
 * Output function
 *
 */
void RacingWheel_Outputs_wrapper(const real_T *FF_bias,
			boolean_T *gearup,
			boolean_T *geardown,
			boolean_T *ST,
			boolean_T *SE,
			boolean_T *X,
			boolean_T *O,
			boolean_T *Square,
			boolean_T *Triangle,
			boolean_T *L2,
			boolean_T *R2,
			boolean_T *L3,
			boolean_T *R3,
			boolean_T *DPadDown,
			boolean_T *DPadUp,
			boolean_T *DPadLeft,
			boolean_T *DPadRight,
			real_T *throttle,
			real_T *brake,
			real_T *clutch,
			real_T *angle,
			const real_T *Ts_Block, const int_T p_width0)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
/* This sample sets the output equal to the input
      y0[0] = u0[0]; 
 For complex signals use: y0[0].re = u0[0].re; 
      y0[0].im = u0[0].im;
      y1[0].re = u1[0].re;
      y1[0].im = u1[0].im;
 */
readWheelStatus(&wheelValues);
readingButton(&buttonValues);

throttle[0] = wheelValues.throttle;
brake[0] = wheelValues.brake;
clutch[0] = wheelValues.clutch;
angle[0] = wheelValues.angle;

gearup[0] = buttonValues.gearup;
geardown[0] = buttonValues.geardown;
ST[0] = buttonValues.ST;
SE[0] = buttonValues.SE;
X[0] = buttonValues.X;
O[0] = buttonValues.O;
Square[0] = buttonValues.Square;
Triangle[0] = buttonValues.Triangle;
L2[0] = buttonValues.L2;
R2[0] = buttonValues.R2;
L3[0] = buttonValues.L3;
R3[0] = buttonValues.R3;
DPadDown[0] = buttonValues.DPadDown;
DPadUp[0] = buttonValues.DPadUp;
DPadLeft[0] = buttonValues.DPadLeft;
DPadRight[0] = buttonValues.DPadRight;

//set bias for spring
effect_spring_bias(FF_bias[0]);


/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}


