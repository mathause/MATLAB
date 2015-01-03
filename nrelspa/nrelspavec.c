

/////////////////////////////////////////////
//          SPA TESTER for SPA.C           //
//                                         //
//      Solar Position Algorithm (SPA)     //
//                   for                   //
//        Solar Radiation Application      //
//                                         //
//             August 12, 2004             //
//                                         //
//   Filename: SPA_TESTER.C                //
//                                         //
//   Afshin Michael Andreas                //
//   afshin_andreas@nrel.gov (303)384-6383 //
//                                         //
//   Measurement & Instrumentation Team    //
//   Solar Radiation Research Laboratory   //
//   National Renewable Energy Laboratory  //
//   1617 Cole Blvd, Golden, CO 80401      //
/////////////////////////////////////////////

/////////////////////////////////////////////
// This sample program shows how to use    //
//    the SPA.C code.                      //
/////////////////////////////////////////////
// 3 6 2010 JG adapt for matlab
// 3 6 2010 JG vectorize code

//#include <stdio.h>
#include "spa.h"  //include the SPA header file
#include "mex.h"

void mexFunction (int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
    spa_data spa;  //declare the SPA structure
    int result,i;
    float min, sec;
    mxArray *rhs[1], *lhs[6];
    mxArray *data1;
    double *data, *lat, *lng, *pr, *alt, *t;
    mwSize mrows,ncols,colM,N,colN;
    double *outdata;
    
      /* Check for proper number of arguments. */
  if(nrhs<6) {
    mexErrMsgTxt("6 input parameters required (matlab time, lat,long,alt,pr,T).");
  } else if(nlhs>1) {
    mexErrMsgTxt("Too many output arguments.");
  }
    
    
    N = mxGetNumberOfElements(prhs[0]);
    // 3 6 2010 JG returns 8 params
    plhs[0] = mxCreateDoubleMatrix(N,8, mxREAL);

    //enter required input values into SPA structure
    mexCallMATLAB(1,lhs,1,prhs,"datevec");
    data=mxGetPr(lhs[0]);
    colM=mxGetM(lhs[0]);
     colN=mxGetN(lhs[0]);
   
//     mexPrintf("%d\n",colM);
//      mexPrintf("%d\n",colN);
   
    lat=mxGetPr(prhs[1]);
    lng=mxGetPr(prhs[2]);
    alt=mxGetPr(prhs[3]);
    pr=mxGetPr(prhs[4]);
    t=mxGetPr(prhs[5]);
    
    
    spa.timezone      = 0.0;
    spa.delta_t       = 67;
    spa.longitude     = lng[0];
    spa.latitude      = lat[0];
    spa.elevation     = alt[0];
    spa.pressure      = pr[0];
    spa.temperature   = t[0];
    spa.slope         = 00;
    spa.azm_rotation  = 0;
    spa.atmos_refract = 0.5667;
    spa.function      = SPA_ALL;

    for(i=0;i<colM;i++)
    {
      //  mexPrintf("%d",i);
    spa.year          = (int )data[(0*colM)+i];
    spa.month         = (int )data[(1*colM)+i];
    spa.day           = (int )data[(2*colM)+i];
    spa.hour          = (int )data[(3*colM)+i];
    spa.minute        = (int )data[(4*colM)+i];
    spa.second        = (int )data[(5*colM)+i];
//         mexPrintf("year    %d\n",spa.year);
//         mexPrintf("month             %d\n",spa.month);
//         mexPrintf("day           %d\n",spa.day);
//         mexPrintf("hour            %d\n",spa.hour);
//         mexPrintf("min          %d\n",spa.minute);
//         mexPrintf("sec    %d\n",spa.second);

    //call the SPA calculate function and pass the SPA structure

   result = spa_calculate(&spa);
   
    if (result == 0)  //check for SPA errors
    {
//         mexPrintf("Julian Day:    %.6f\n",spa.jd);
//         mexPrintf("L:             %.6e degrees\n",spa.l);
//         mexPrintf("B:             %.6e degrees\n",spa.b);
//         mexPrintf("R:             %.6f AU\n",spa.r);
//         mexPrintf("H:             %.6f degrees\n",spa.h);
//         mexPrintf("Delta Psi:     %.6e degrees\n",spa.del_psi);
//         mexPrintf("Delta Epsilon: %.6e degrees\n",spa.del_epsilon);
//         mexPrintf("Epsilon:       %.6f degrees\n",spa.epsilon);
//         mexPrintf("Zenith:        %.6f degrees\n",spa.zenith);
//         mexPrintf("Azimuth:       %.6f degrees\n",spa.azimuth);
//         mexPrintf("Incidence:     %.6f degrees\n",spa.incidence);

      outdata=mxGetPr(plhs[0]);
      outdata[(0*colM)+i]=spa.zenith;
      outdata[(1*colM)+i]=spa.azimuth;
      outdata[(2*colM)+i]=spa.azimuth180;
      outdata[(3*colM)+i]=spa.suntransit;
      outdata[(4*colM)+i]=spa.sunrise;
      outdata[(5*colM)+i]=spa.sunset;
      outdata[(6*colM)+i]=spa.e0;
      outdata[(7*colM)+i]=spa.del_e;
      
    } else mexPrintf("SPA Error Code: %d\n", result);
    }
   
}

/////////////////////////////////////////////
// The output of this program should be:
//
//Julian Day:    2452930.312847
//L:             2.401826e+01 degrees
//B:             -1.011219e-04 degrees
//R:             0.996542 AU
//H:             11.105902 degrees
//Delta Psi:     -3.998404e-03 degrees
//Delta Epsilon: 1.666568e-03 degrees
//Epsilon:       23.440465 degrees
//Zenith:        50.111622 degrees
//Azimuth:       194.340241 degrees
//Incidence:     25.187000 degrees
//Sunrise:       06:12:43 Local Time
//Sunset:        17:20:19 Local Time
//
/////////////////////////////////////////////

