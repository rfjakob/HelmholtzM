/* digCode.c ****************************************************************

Sends a 16-bit digital code to a measurement computing board, specifically the PCIM-DAS1602.
Uses FIRSTPORTA and FIRSTPORTB for the 16 bits, and sends a strobe on the first bit of FIRSTPORTC.
 
Derived from ULDO01.C in the Measurement Computing Corp. example code.

Compile this in Matlab with:
> mex digCode.c cbw32.lib 
 
NOTE: You must first install the MCC DAQ CD (Universal Library) from Measurement Computing's website.  
cbw32.lib, cbw.lib must be in the working directory.  It is installed with the Universal Library.
 
Ryan Kelly, 2011
 
***************************************************************************/


/* Include files */
#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include "cbw.h"
#include "mex.h"


void waitMS(float ms,LARGE_INTEGER frequency)
{
    LARGE_INTEGER t1, t2;           // ticks

    QueryPerformanceCounter(&t1);
    do
    {
        QueryPerformanceCounter(&t2);            
    }
    while ((t2.QuadPart - t1.QuadPart) * 1000.0 / frequency.QuadPart < ms);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int i;
    int boardNum = 0;
    int ULStat;
    int lowPort,highPort,strobePort;
    LARGE_INTEGER frequency;        // ticks per second
    double* doubleData;
    mxChar * charData;
    double waitTimeMS;
    
    waitTimeMS = .01;
    
    // get ticks per second
    QueryPerformanceFrequency(&frequency);

    lowPort = FIRSTPORTA;
    highPort = FIRSTPORTB;
    strobePort = FIRSTPORTC;
    
    ULStat = cbDConfigPort (boardNum, lowPort, DIGITALOUT);
    ULStat = cbDConfigPort (boardNum, highPort, DIGITALOUT);
    ULStat = cbDConfigPort (boardNum, strobePort, DIGITALOUT);

    if (nrhs > 0)
    {
        switch (mxGetClassID(prhs[0]))
        {
            case mxDOUBLE_CLASS:
                doubleData = mxGetPr(prhs[0]);

                for (i = 0; i < mxGetNumberOfElements(prhs[0]); i++)
                {
                    ULStat = cbDOut(boardNum, lowPort, ((int)doubleData[i]) % 256);
                    ULStat = cbDOut(boardNum, highPort, ((int)doubleData[i]) / 256);
                    waitMS(waitTimeMS,frequency);
                    ULStat = cbDOut(boardNum, strobePort,1);
                    waitMS(waitTimeMS,frequency);
                    ULStat = cbDOut(boardNum, strobePort,0);
                    waitMS(waitTimeMS,frequency); 
                }
                break;
            case mxCHAR_CLASS:
                charData = (mxChar*)mxGetData(prhs[0]);    
                
                for (i = 0; i < mxGetNumberOfElements(prhs[0]); i++)
                {
                    ULStat = cbDOut(boardNum, lowPort, charData[i]);
                    waitMS(waitTimeMS,frequency); 
                    ULStat = cbDOut(boardNum, strobePort, 1);
                    waitMS(waitTimeMS,frequency);    
                    ULStat = cbDOut(boardNum, strobePort, 0);
                    waitMS(waitTimeMS,frequency);
                }
                break;
            default:
                mexPrintf("Sorry, this data type cannot be transmitted.\n");
                mexEvalString("drawnow;");
                
        }        
    }

    return;
}
        



