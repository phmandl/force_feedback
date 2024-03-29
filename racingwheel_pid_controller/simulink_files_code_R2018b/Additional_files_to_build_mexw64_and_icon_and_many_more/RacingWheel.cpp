/*
 * File: RacingWheel.cpp
 *
 *
 *   --- THIS FILE GENERATED BY S-FUNCTION BUILDER: 3.0 ---
 *
 *   This file is an S-function produced by the S-Function
 *   Builder which only recognizes certain fields.  Changes made
 *   outside these fields will be lost the next time the block is
 *   used to load, edit, and resave this file. This file will be overwritten
 *   by the S-function Builder block. If you want to edit this file by hand, 
 *   you must change it only in the area defined as:  
 *
 *        %%%-SFUNWIZ_defines_Changes_BEGIN
 *        #define NAME 'replacement text' 
 *        %%% SFUNWIZ_defines_Changes_END
 *
 *   DO NOT change NAME--Change the 'replacement text' only.
 *
 *   For better compatibility with the Simulink Coder, the
 *   "wrapper" S-function technique is used.  This is discussed
 *   in the Simulink Coder's Manual in the Chapter titled,
 *   "Wrapper S-functions".
 *
 *  -------------------------------------------------------------------------
 * | See matlabroot/simulink/src/sfuntmpl_doc.c for a more detailed template |
 *  ------------------------------------------------------------------------- 
 *
 * Created: Tue Sep 15 18:45:59 2020
 */

#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME RacingWheel
/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
/* %%%-SFUNWIZ_defines_Changes_BEGIN --- EDIT HERE TO _END */
#define NUM_INPUTS            1
/* Input Port  0 */
#define IN_PORT_0_NAME        FF
#define INPUT_0_WIDTH         1
#define INPUT_DIMS_0_COL      1
#define INPUT_0_DTYPE         real_T
#define INPUT_0_COMPLEX       COMPLEX_NO
#define IN_0_FRAME_BASED      FRAME_NO
#define IN_0_BUS_BASED        0
#define IN_0_BUS_NAME         
#define IN_0_DIMS             1-D
#define INPUT_0_FEEDTHROUGH   1
#define IN_0_ISSIGNED         0
#define IN_0_WORDLENGTH       8
#define IN_0_FIXPOINTSCALING  1
#define IN_0_FRACTIONLENGTH   9
#define IN_0_BIAS             0
#define IN_0_SLOPE            0.125

#define NUM_OUTPUTS           20
/* Output Port  0 */
#define OUT_PORT_0_NAME       gearup
#define OUTPUT_0_WIDTH        1
#define OUTPUT_DIMS_0_COL     1
#define OUTPUT_0_DTYPE        boolean_T
#define OUTPUT_0_COMPLEX      COMPLEX_NO
#define OUT_0_FRAME_BASED     FRAME_NO
#define OUT_0_BUS_BASED       0
#define OUT_0_BUS_NAME        
#define OUT_0_DIMS            1-D
#define OUT_0_ISSIGNED        1
#define OUT_0_WORDLENGTH      8
#define OUT_0_FIXPOINTSCALING 1
#define OUT_0_FRACTIONLENGTH  3
#define OUT_0_BIAS            0
#define OUT_0_SLOPE           0.125
/* Output Port  1 */
#define OUT_PORT_1_NAME       geardown
#define OUTPUT_1_WIDTH        1
#define OUTPUT_DIMS_1_COL     1
#define OUTPUT_1_DTYPE        boolean_T
#define OUTPUT_1_COMPLEX      COMPLEX_NO
#define OUT_1_FRAME_BASED     FRAME_NO
#define OUT_1_BUS_BASED       0
#define OUT_1_BUS_NAME        
#define OUT_1_DIMS            1-D
#define OUT_1_ISSIGNED        1
#define OUT_1_WORDLENGTH      8
#define OUT_1_FIXPOINTSCALING 1
#define OUT_1_FRACTIONLENGTH  3
#define OUT_1_BIAS            0
#define OUT_1_SLOPE           0.125
/* Output Port  2 */
#define OUT_PORT_2_NAME       ST
#define OUTPUT_2_WIDTH        1
#define OUTPUT_DIMS_2_COL     1
#define OUTPUT_2_DTYPE        boolean_T
#define OUTPUT_2_COMPLEX      COMPLEX_NO
#define OUT_2_FRAME_BASED     FRAME_NO
#define OUT_2_BUS_BASED       0
#define OUT_2_BUS_NAME        
#define OUT_2_DIMS            1-D
#define OUT_2_ISSIGNED        1
#define OUT_2_WORDLENGTH      8
#define OUT_2_FIXPOINTSCALING 1
#define OUT_2_FRACTIONLENGTH  3
#define OUT_2_BIAS            0
#define OUT_2_SLOPE           0.125
/* Output Port  3 */
#define OUT_PORT_3_NAME       SE
#define OUTPUT_3_WIDTH        1
#define OUTPUT_DIMS_3_COL     1
#define OUTPUT_3_DTYPE        boolean_T
#define OUTPUT_3_COMPLEX      COMPLEX_NO
#define OUT_3_FRAME_BASED     FRAME_NO
#define OUT_3_BUS_BASED       0
#define OUT_3_BUS_NAME        
#define OUT_3_DIMS            1-D
#define OUT_3_ISSIGNED        1
#define OUT_3_WORDLENGTH      8
#define OUT_3_FIXPOINTSCALING 1
#define OUT_3_FRACTIONLENGTH  3
#define OUT_3_BIAS            0
#define OUT_3_SLOPE           0.125
/* Output Port  4 */
#define OUT_PORT_4_NAME       X
#define OUTPUT_4_WIDTH        1
#define OUTPUT_DIMS_4_COL     1
#define OUTPUT_4_DTYPE        boolean_T
#define OUTPUT_4_COMPLEX      COMPLEX_NO
#define OUT_4_FRAME_BASED     FRAME_NO
#define OUT_4_BUS_BASED       0
#define OUT_4_BUS_NAME        
#define OUT_4_DIMS            1-D
#define OUT_4_ISSIGNED        1
#define OUT_4_WORDLENGTH      8
#define OUT_4_FIXPOINTSCALING 1
#define OUT_4_FRACTIONLENGTH  3
#define OUT_4_BIAS            0
#define OUT_4_SLOPE           0.125
/* Output Port  5 */
#define OUT_PORT_5_NAME       O
#define OUTPUT_5_WIDTH        1
#define OUTPUT_DIMS_5_COL     1
#define OUTPUT_5_DTYPE        boolean_T
#define OUTPUT_5_COMPLEX      COMPLEX_NO
#define OUT_5_FRAME_BASED     FRAME_NO
#define OUT_5_BUS_BASED       0
#define OUT_5_BUS_NAME        
#define OUT_5_DIMS            1-D
#define OUT_5_ISSIGNED        1
#define OUT_5_WORDLENGTH      8
#define OUT_5_FIXPOINTSCALING 1
#define OUT_5_FRACTIONLENGTH  3
#define OUT_5_BIAS            0
#define OUT_5_SLOPE           0.125
/* Output Port  6 */
#define OUT_PORT_6_NAME       Square
#define OUTPUT_6_WIDTH        1
#define OUTPUT_DIMS_6_COL     1
#define OUTPUT_6_DTYPE        boolean_T
#define OUTPUT_6_COMPLEX      COMPLEX_NO
#define OUT_6_FRAME_BASED     FRAME_NO
#define OUT_6_BUS_BASED       0
#define OUT_6_BUS_NAME        
#define OUT_6_DIMS            1-D
#define OUT_6_ISSIGNED        1
#define OUT_6_WORDLENGTH      8
#define OUT_6_FIXPOINTSCALING 1
#define OUT_6_FRACTIONLENGTH  3
#define OUT_6_BIAS            0
#define OUT_6_SLOPE           0.125
/* Output Port  7 */
#define OUT_PORT_7_NAME       Triangle
#define OUTPUT_7_WIDTH        1
#define OUTPUT_DIMS_7_COL     1
#define OUTPUT_7_DTYPE        boolean_T
#define OUTPUT_7_COMPLEX      COMPLEX_NO
#define OUT_7_FRAME_BASED     FRAME_NO
#define OUT_7_BUS_BASED       0
#define OUT_7_BUS_NAME        
#define OUT_7_DIMS            1-D
#define OUT_7_ISSIGNED        1
#define OUT_7_WORDLENGTH      8
#define OUT_7_FIXPOINTSCALING 1
#define OUT_7_FRACTIONLENGTH  3
#define OUT_7_BIAS            0
#define OUT_7_SLOPE           0.125
/* Output Port  8 */
#define OUT_PORT_8_NAME       L2
#define OUTPUT_8_WIDTH        1
#define OUTPUT_DIMS_8_COL     1
#define OUTPUT_8_DTYPE        boolean_T
#define OUTPUT_8_COMPLEX      COMPLEX_NO
#define OUT_8_FRAME_BASED     FRAME_NO
#define OUT_8_BUS_BASED       0
#define OUT_8_BUS_NAME        
#define OUT_8_DIMS            1-D
#define OUT_8_ISSIGNED        1
#define OUT_8_WORDLENGTH      8
#define OUT_8_FIXPOINTSCALING 1
#define OUT_8_FRACTIONLENGTH  3
#define OUT_8_BIAS            0
#define OUT_8_SLOPE           0.125
/* Output Port  9 */
#define OUT_PORT_9_NAME       R2
#define OUTPUT_9_WIDTH        1
#define OUTPUT_DIMS_9_COL     1
#define OUTPUT_9_DTYPE        boolean_T
#define OUTPUT_9_COMPLEX      COMPLEX_NO
#define OUT_9_FRAME_BASED     FRAME_NO
#define OUT_9_BUS_BASED       0
#define OUT_9_BUS_NAME        
#define OUT_9_DIMS            1-D
#define OUT_9_ISSIGNED        1
#define OUT_9_WORDLENGTH      8
#define OUT_9_FIXPOINTSCALING 1
#define OUT_9_FRACTIONLENGTH  3
#define OUT_9_BIAS            0
#define OUT_9_SLOPE           0.125
/* Output Port  10 */
#define OUT_PORT_10_NAME       L3
#define OUTPUT_10_WIDTH        1
#define OUTPUT_DIMS_10_COL     1
#define OUTPUT_10_DTYPE        boolean_T
#define OUTPUT_10_COMPLEX      COMPLEX_NO
#define OUT_10_FRAME_BASED     FRAME_NO
#define OUT_10_BUS_BASED       0
#define OUT_10_BUS_NAME        
#define OUT_10_DIMS            1-D
#define OUT_10_ISSIGNED        1
#define OUT_10_WORDLENGTH      8
#define OUT_10_FIXPOINTSCALING 1
#define OUT_10_FRACTIONLENGTH  3
#define OUT_10_BIAS            0
#define OUT_10_SLOPE           0.125
/* Output Port  11 */
#define OUT_PORT_11_NAME       R3
#define OUTPUT_11_WIDTH        1
#define OUTPUT_DIMS_11_COL     1
#define OUTPUT_11_DTYPE        boolean_T
#define OUTPUT_11_COMPLEX      COMPLEX_NO
#define OUT_11_FRAME_BASED     FRAME_NO
#define OUT_11_BUS_BASED       0
#define OUT_11_BUS_NAME        
#define OUT_11_DIMS            1-D
#define OUT_11_ISSIGNED        1
#define OUT_11_WORDLENGTH      8
#define OUT_11_FIXPOINTSCALING 1
#define OUT_11_FRACTIONLENGTH  3
#define OUT_11_BIAS            0
#define OUT_11_SLOPE           0.125
/* Output Port  12 */
#define OUT_PORT_12_NAME       DPadDown
#define OUTPUT_12_WIDTH        1
#define OUTPUT_DIMS_12_COL     1
#define OUTPUT_12_DTYPE        boolean_T
#define OUTPUT_12_COMPLEX      COMPLEX_NO
#define OUT_12_FRAME_BASED     FRAME_NO
#define OUT_12_BUS_BASED       0
#define OUT_12_BUS_NAME        
#define OUT_12_DIMS            1-D
#define OUT_12_ISSIGNED        1
#define OUT_12_WORDLENGTH      8
#define OUT_12_FIXPOINTSCALING 1
#define OUT_12_FRACTIONLENGTH  3
#define OUT_12_BIAS            0
#define OUT_12_SLOPE           0.125
/* Output Port  13 */
#define OUT_PORT_13_NAME       DPadUp
#define OUTPUT_13_WIDTH        1
#define OUTPUT_DIMS_13_COL     1
#define OUTPUT_13_DTYPE        boolean_T
#define OUTPUT_13_COMPLEX      COMPLEX_NO
#define OUT_13_FRAME_BASED     FRAME_NO
#define OUT_13_BUS_BASED       0
#define OUT_13_BUS_NAME        
#define OUT_13_DIMS            1-D
#define OUT_13_ISSIGNED        1
#define OUT_13_WORDLENGTH      8
#define OUT_13_FIXPOINTSCALING 1
#define OUT_13_FRACTIONLENGTH  3
#define OUT_13_BIAS            0
#define OUT_13_SLOPE           0.125
/* Output Port  14 */
#define OUT_PORT_14_NAME       DPadLeft
#define OUTPUT_14_WIDTH        1
#define OUTPUT_DIMS_14_COL     1
#define OUTPUT_14_DTYPE        boolean_T
#define OUTPUT_14_COMPLEX      COMPLEX_NO
#define OUT_14_FRAME_BASED     FRAME_NO
#define OUT_14_BUS_BASED       0
#define OUT_14_BUS_NAME        
#define OUT_14_DIMS            1-D
#define OUT_14_ISSIGNED        1
#define OUT_14_WORDLENGTH      8
#define OUT_14_FIXPOINTSCALING 1
#define OUT_14_FRACTIONLENGTH  3
#define OUT_14_BIAS            0
#define OUT_14_SLOPE           0.125
/* Output Port  15 */
#define OUT_PORT_15_NAME       DPadRight
#define OUTPUT_15_WIDTH        1
#define OUTPUT_DIMS_15_COL     1
#define OUTPUT_15_DTYPE        boolean_T
#define OUTPUT_15_COMPLEX      COMPLEX_NO
#define OUT_15_FRAME_BASED     FRAME_NO
#define OUT_15_BUS_BASED       0
#define OUT_15_BUS_NAME        
#define OUT_15_DIMS            1-D
#define OUT_15_ISSIGNED        1
#define OUT_15_WORDLENGTH      8
#define OUT_15_FIXPOINTSCALING 1
#define OUT_15_FRACTIONLENGTH  3
#define OUT_15_BIAS            0
#define OUT_15_SLOPE           0.125
/* Output Port  16 */
#define OUT_PORT_16_NAME       throttle
#define OUTPUT_16_WIDTH        1
#define OUTPUT_DIMS_16_COL     1
#define OUTPUT_16_DTYPE        real_T
#define OUTPUT_16_COMPLEX      COMPLEX_NO
#define OUT_16_FRAME_BASED     FRAME_NO
#define OUT_16_BUS_BASED       0
#define OUT_16_BUS_NAME        
#define OUT_16_DIMS            1-D
#define OUT_16_ISSIGNED        1
#define OUT_16_WORDLENGTH      8
#define OUT_16_FIXPOINTSCALING 1
#define OUT_16_FRACTIONLENGTH  3
#define OUT_16_BIAS            0
#define OUT_16_SLOPE           0.125
/* Output Port  17 */
#define OUT_PORT_17_NAME       brake
#define OUTPUT_17_WIDTH        1
#define OUTPUT_DIMS_17_COL     1
#define OUTPUT_17_DTYPE        real_T
#define OUTPUT_17_COMPLEX      COMPLEX_NO
#define OUT_17_FRAME_BASED     FRAME_NO
#define OUT_17_BUS_BASED       0
#define OUT_17_BUS_NAME        
#define OUT_17_DIMS            1-D
#define OUT_17_ISSIGNED        1
#define OUT_17_WORDLENGTH      8
#define OUT_17_FIXPOINTSCALING 1
#define OUT_17_FRACTIONLENGTH  3
#define OUT_17_BIAS            0
#define OUT_17_SLOPE           0.125
/* Output Port  18 */
#define OUT_PORT_18_NAME       clutch
#define OUTPUT_18_WIDTH        1
#define OUTPUT_DIMS_18_COL     1
#define OUTPUT_18_DTYPE        real_T
#define OUTPUT_18_COMPLEX      COMPLEX_NO
#define OUT_18_FRAME_BASED     FRAME_NO
#define OUT_18_BUS_BASED       0
#define OUT_18_BUS_NAME        
#define OUT_18_DIMS            1-D
#define OUT_18_ISSIGNED        1
#define OUT_18_WORDLENGTH      8
#define OUT_18_FIXPOINTSCALING 1
#define OUT_18_FRACTIONLENGTH  3
#define OUT_18_BIAS            0
#define OUT_18_SLOPE           0.125
/* Output Port  19 */
#define OUT_PORT_19_NAME       angle
#define OUTPUT_19_WIDTH        1
#define OUTPUT_DIMS_19_COL     1
#define OUTPUT_19_DTYPE        real_T
#define OUTPUT_19_COMPLEX      COMPLEX_NO
#define OUT_19_FRAME_BASED     FRAME_NO
#define OUT_19_BUS_BASED       0
#define OUT_19_BUS_NAME        
#define OUT_19_DIMS            1-D
#define OUT_19_ISSIGNED        1
#define OUT_19_WORDLENGTH      8
#define OUT_19_FIXPOINTSCALING 1
#define OUT_19_FRACTIONLENGTH  3
#define OUT_19_BIAS            0
#define OUT_19_SLOPE           0.125

#define NPARAMS               1
/* Parameter 0 */
#define PARAMETER_0_NAME      Ts_FF
#define PARAMETER_0_DTYPE     real_T
#define PARAMETER_0_COMPLEX   COMPLEX_NO

#define SAMPLE_TIME_0         Ts_FF
#define NUM_DISC_STATES       0
#define DISC_STATES_IC        [0]
#define NUM_CONT_STATES       0
#define CONT_STATES_IC        [0]

#define SFUNWIZ_GENERATE_TLC  1
#define SOURCEFILES           "__SFB__FF_UWP_WIN32_dll.lib"
#define PANELINDEX            8
#define USE_SIMSTRUCT         0
#define SHOW_COMPILE_STEPS    0
#define CREATE_DEBUG_MEXFILE  1
#define SAVE_CODE_ONLY        0
#define SFUNWIZ_REVISION      3.0
/* %%%-SFUNWIZ_defines_Changes_END --- EDIT HERE TO _BEGIN */
/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
#include "simstruc.h"

#define PARAM_DEF0(S) ssGetSFcnParam(S, 0)

#define IS_PARAM_DOUBLE(pVal) (mxIsNumeric(pVal) && !mxIsLogical(pVal) &&\
!mxIsEmpty(pVal) && !mxIsSparse(pVal) && !mxIsComplex(pVal) && mxIsDouble(pVal))

extern void RacingWheel_Start_wrapper(const real_T *Ts_FF, const int_T p_width0);
extern void RacingWheel_Outputs_wrapper(const real_T *FF,
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
			const real_T *Ts_FF, const int_T p_width0);
extern void RacingWheel_Terminate_wrapper(const real_T *Ts_FF, const int_T p_width0);
/*====================*
 * S-function methods *
 *====================*/
#define MDL_CHECK_PARAMETERS
#if defined(MDL_CHECK_PARAMETERS) && defined(MATLAB_MEX_FILE)
/* Function: mdlCheckParameters =============================================
 * Abstract:
 *     Verify parameter definitions and types.
 */
static void mdlCheckParameters(SimStruct *S)
{
    int paramIndex  = 0;
    bool invalidParam = false;
    /* All parameters must match the S-function Builder Dialog */

    {
        const mxArray *pVal0 = ssGetSFcnParam(S, 0);
        if (!mxIsDouble(pVal0)) {
            ssSetErrorStatus(S, "Sample time parameter Ts_FF must be of type double");
            return;
        }
    }

    {
        const mxArray *pVal0 = ssGetSFcnParam(S, 0);
        if (!IS_PARAM_DOUBLE(pVal0)) {
            invalidParam = true;
            paramIndex = 0;
            goto EXIT_POINT;
        }
    }


    EXIT_POINT:
    if (invalidParam) {
        char parameterErrorMsg[1024];
        sprintf(parameterErrorMsg, "The data type and or complexity of parameter %d does not match the "
                "information specified in the S-function Builder dialog. "
                "For non-double parameters you will need to cast them using int8, int16, "
                "int32, uint8, uint16, uint32 or boolean.", paramIndex + 1);
        ssSetErrorStatus(S, parameterErrorMsg);
    }
    return;
}
#endif /* MDL_CHECK_PARAMETERS */
/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *   Setup sizes of the various vectors.
 */
static void mdlInitializeSizes(SimStruct *S)
{

    DECL_AND_INIT_DIMSINFO(inputDimsInfo);
    DECL_AND_INIT_DIMSINFO(outputDimsInfo);
    ssSetNumSFcnParams(S, NPARAMS); /* Number of expected parameters */
    #if defined(MATLAB_MEX_FILE)
    if (ssGetNumSFcnParams(S) == ssGetSFcnParamsCount(S)) {
        mdlCheckParameters(S);
        if (ssGetErrorStatus(S) != NULL) {
            return;
        }
    } else {
        return; /* Parameter mismatch will be reported by Simulink */
    }
    #endif

    ssSetArrayLayoutForCodeGen(S, SS_COLUMN_MAJOR);

    ssSetSimStateCompliance(S, USE_DEFAULT_SIM_STATE);

    ssSetNumContStates(S, NUM_CONT_STATES);
    ssSetNumDiscStates(S, NUM_DISC_STATES);


    if (!ssSetNumInputPorts(S, NUM_INPUTS)) return;
    ssSetInputPortWidth(S, 0, INPUT_0_WIDTH);
    ssSetInputPortDataType(S, 0, SS_DOUBLE);
    ssSetInputPortComplexSignal(S, 0, INPUT_0_COMPLEX);
    ssSetInputPortDirectFeedThrough(S, 0, INPUT_0_FEEDTHROUGH);
    ssSetInputPortRequiredContiguous(S, 0, 1); /*direct input signal access*/

    if (!ssSetNumOutputPorts(S, NUM_OUTPUTS)) return;
    /* Output Port 0 */
    ssSetOutputPortWidth(S, 0, OUTPUT_0_WIDTH);
    ssSetOutputPortDataType(S, 0, SS_BOOLEAN);
    ssSetOutputPortComplexSignal(S, 0, OUTPUT_0_COMPLEX);
    /* Output Port 1 */
    ssSetOutputPortWidth(S, 1, OUTPUT_1_WIDTH);
    ssSetOutputPortDataType(S, 1, SS_BOOLEAN);
    ssSetOutputPortComplexSignal(S, 1, OUTPUT_1_COMPLEX);
    /* Output Port 2 */
    ssSetOutputPortWidth(S, 2, OUTPUT_2_WIDTH);
    ssSetOutputPortDataType(S, 2, SS_BOOLEAN);
    ssSetOutputPortComplexSignal(S, 2, OUTPUT_2_COMPLEX);
    /* Output Port 3 */
    ssSetOutputPortWidth(S, 3, OUTPUT_3_WIDTH);
    ssSetOutputPortDataType(S, 3, SS_BOOLEAN);
    ssSetOutputPortComplexSignal(S, 3, OUTPUT_3_COMPLEX);
    /* Output Port 4 */
    ssSetOutputPortWidth(S, 4, OUTPUT_4_WIDTH);
    ssSetOutputPortDataType(S, 4, SS_BOOLEAN);
    ssSetOutputPortComplexSignal(S, 4, OUTPUT_4_COMPLEX);
    /* Output Port 5 */
    ssSetOutputPortWidth(S, 5, OUTPUT_5_WIDTH);
    ssSetOutputPortDataType(S, 5, SS_BOOLEAN);
    ssSetOutputPortComplexSignal(S, 5, OUTPUT_5_COMPLEX);
    /* Output Port 6 */
    ssSetOutputPortWidth(S, 6, OUTPUT_6_WIDTH);
    ssSetOutputPortDataType(S, 6, SS_BOOLEAN);
    ssSetOutputPortComplexSignal(S, 6, OUTPUT_6_COMPLEX);
    /* Output Port 7 */
    ssSetOutputPortWidth(S, 7, OUTPUT_7_WIDTH);
    ssSetOutputPortDataType(S, 7, SS_BOOLEAN);
    ssSetOutputPortComplexSignal(S, 7, OUTPUT_7_COMPLEX);
    /* Output Port 8 */
    ssSetOutputPortWidth(S, 8, OUTPUT_8_WIDTH);
    ssSetOutputPortDataType(S, 8, SS_BOOLEAN);
    ssSetOutputPortComplexSignal(S, 8, OUTPUT_8_COMPLEX);
    /* Output Port 9 */
    ssSetOutputPortWidth(S, 9, OUTPUT_9_WIDTH);
    ssSetOutputPortDataType(S, 9, SS_BOOLEAN);
    ssSetOutputPortComplexSignal(S, 9, OUTPUT_9_COMPLEX);
    /* Output Port 10 */
    ssSetOutputPortWidth(S, 10, OUTPUT_10_WIDTH);
    ssSetOutputPortDataType(S, 10, SS_BOOLEAN);
    ssSetOutputPortComplexSignal(S, 10, OUTPUT_10_COMPLEX);
    /* Output Port 11 */
    ssSetOutputPortWidth(S, 11, OUTPUT_11_WIDTH);
    ssSetOutputPortDataType(S, 11, SS_BOOLEAN);
    ssSetOutputPortComplexSignal(S, 11, OUTPUT_11_COMPLEX);
    /* Output Port 12 */
    ssSetOutputPortWidth(S, 12, OUTPUT_12_WIDTH);
    ssSetOutputPortDataType(S, 12, SS_BOOLEAN);
    ssSetOutputPortComplexSignal(S, 12, OUTPUT_12_COMPLEX);
    /* Output Port 13 */
    ssSetOutputPortWidth(S, 13, OUTPUT_13_WIDTH);
    ssSetOutputPortDataType(S, 13, SS_BOOLEAN);
    ssSetOutputPortComplexSignal(S, 13, OUTPUT_13_COMPLEX);
    /* Output Port 14 */
    ssSetOutputPortWidth(S, 14, OUTPUT_14_WIDTH);
    ssSetOutputPortDataType(S, 14, SS_BOOLEAN);
    ssSetOutputPortComplexSignal(S, 14, OUTPUT_14_COMPLEX);
    /* Output Port 15 */
    ssSetOutputPortWidth(S, 15, OUTPUT_15_WIDTH);
    ssSetOutputPortDataType(S, 15, SS_BOOLEAN);
    ssSetOutputPortComplexSignal(S, 15, OUTPUT_15_COMPLEX);
    /* Output Port 16 */
    ssSetOutputPortWidth(S, 16, OUTPUT_16_WIDTH);
    ssSetOutputPortDataType(S, 16, SS_DOUBLE);
    ssSetOutputPortComplexSignal(S, 16, OUTPUT_16_COMPLEX);
    /* Output Port 17 */
    ssSetOutputPortWidth(S, 17, OUTPUT_17_WIDTH);
    ssSetOutputPortDataType(S, 17, SS_DOUBLE);
    ssSetOutputPortComplexSignal(S, 17, OUTPUT_17_COMPLEX);
    /* Output Port 18 */
    ssSetOutputPortWidth(S, 18, OUTPUT_18_WIDTH);
    ssSetOutputPortDataType(S, 18, SS_DOUBLE);
    ssSetOutputPortComplexSignal(S, 18, OUTPUT_18_COMPLEX);
    /* Output Port 19 */
    ssSetOutputPortWidth(S, 19, OUTPUT_19_WIDTH);
    ssSetOutputPortDataType(S, 19, SS_DOUBLE);
    ssSetOutputPortComplexSignal(S, 19, OUTPUT_19_COMPLEX);
    ssSetNumPWork(S, 0);

    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 0);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);

    ssSetSimulinkVersionGeneratedIn(S, "9.2");

    /* Take care when specifying exception free code - see sfuntmpl_doc.c */
    ssSetOptions(S, (SS_OPTION_EXCEPTION_FREE_CODE |
                     SS_OPTION_USE_TLC_WITH_ACCELERATOR |
                     SS_OPTION_WORKS_WITH_CODE_REUSE));
}

/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    Specifiy  the sample time.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, *mxGetPr(ssGetSFcnParam(S, 0)));
    ssSetModelReferenceSampleTimeDefaultInheritance(S);
    ssSetOffsetTime(S, 0, 0.0);
}

#define MDL_SET_INPUT_PORT_DATA_TYPE
static void mdlSetInputPortDataType(SimStruct *S, int port, DTypeId dType)
{
    ssSetInputPortDataType(S, 0, dType);
}

#define MDL_SET_OUTPUT_PORT_DATA_TYPE
static void mdlSetOutputPortDataType(SimStruct *S, int port, DTypeId dType)
{
    ssSetOutputPortDataType(S, 0, dType);
}

#define MDL_SET_DEFAULT_PORT_DATA_TYPES
static void mdlSetDefaultPortDataTypes(SimStruct *S)
{
    ssSetInputPortDataType(S, 0, SS_DOUBLE);
    ssSetOutputPortDataType(S, 0, SS_DOUBLE);
}

#define MDL_SET_WORK_WIDTHS
#if defined(MDL_SET_WORK_WIDTHS) && defined(MATLAB_MEX_FILE)

static void mdlSetWorkWidths(SimStruct *S)
{

    const char_T *rtParamNames[] = {"P1"};
    ssRegAllTunableParamsAsRunTimeParams(S, rtParamNames);

}

#endif

#define MDL_START  /* Change to #undef to remove function */
#if defined(MDL_START)
/* Function: mdlStart =======================================================
 * Abstract:
 *    This function is called once at start of model execution. If you
 *    have states that should be initialized once, this is the place
 *    to do it.
 */
static void mdlStart(SimStruct *S)
{
    const int_T   p_width0  = mxGetNumberOfElements(PARAM_DEF0(S));
    const real_T *Ts_FF = (const real_T *) mxGetData(PARAM_DEF0(S));
    
    RacingWheel_Start_wrapper(Ts_FF, p_width0);
}
#endif /*  MDL_START */

/* Function: mdlOutputs =======================================================
 *
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    const real_T *FF = (real_T *) ssGetInputPortRealSignal(S, 0);
    boolean_T *gearup = (boolean_T *) ssGetOutputPortRealSignal(S, 0);
    boolean_T *geardown = (boolean_T *) ssGetOutputPortRealSignal(S, 1);
    boolean_T *ST = (boolean_T *) ssGetOutputPortRealSignal(S, 2);
    boolean_T *SE = (boolean_T *) ssGetOutputPortRealSignal(S, 3);
    boolean_T *X = (boolean_T *) ssGetOutputPortRealSignal(S, 4);
    boolean_T *O = (boolean_T *) ssGetOutputPortRealSignal(S, 5);
    boolean_T *Square = (boolean_T *) ssGetOutputPortRealSignal(S, 6);
    boolean_T *Triangle = (boolean_T *) ssGetOutputPortRealSignal(S, 7);
    boolean_T *L2 = (boolean_T *) ssGetOutputPortRealSignal(S, 8);
    boolean_T *R2 = (boolean_T *) ssGetOutputPortRealSignal(S, 9);
    boolean_T *L3 = (boolean_T *) ssGetOutputPortRealSignal(S, 10);
    boolean_T *R3 = (boolean_T *) ssGetOutputPortRealSignal(S, 11);
    boolean_T *DPadDown = (boolean_T *) ssGetOutputPortRealSignal(S, 12);
    boolean_T *DPadUp = (boolean_T *) ssGetOutputPortRealSignal(S, 13);
    boolean_T *DPadLeft = (boolean_T *) ssGetOutputPortRealSignal(S, 14);
    boolean_T *DPadRight = (boolean_T *) ssGetOutputPortRealSignal(S, 15);
    real_T *throttle = (real_T *) ssGetOutputPortRealSignal(S, 16);
    real_T *brake = (real_T *) ssGetOutputPortRealSignal(S, 17);
    real_T *clutch = (real_T *) ssGetOutputPortRealSignal(S, 18);
    real_T *angle = (real_T *) ssGetOutputPortRealSignal(S, 19);
    const int_T   p_width0  = mxGetNumberOfElements(PARAM_DEF0(S));
    const real_T *Ts_FF = (const real_T *) mxGetData(PARAM_DEF0(S));
    
    RacingWheel_Outputs_wrapper(FF, gearup, geardown, ST, SE, X, O, Square, Triangle, L2, R2, L3, R3, DPadDown, DPadUp, DPadLeft, DPadRight, throttle, brake, clutch, angle, Ts_FF, p_width0);

}

/* Function: mdlTerminate =====================================================
 * Abstract:
 *    In this function, you should perform any actions that are necessary
 *    at the termination of a simulation.  For example, if memory was
 *    allocated in mdlStart, this is the place to free it.
 */
static void mdlTerminate(SimStruct *S)
{
    const int_T   p_width0  = mxGetNumberOfElements(PARAM_DEF0(S));
    const real_T *Ts_FF = (const real_T *) mxGetData(PARAM_DEF0(S));
    
    RacingWheel_Terminate_wrapper(Ts_FF, p_width0);

}


#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif



