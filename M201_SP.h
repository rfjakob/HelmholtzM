/*
Call this function to set the ZERO BASED COM Port number. Be aware that passing
the parameter as 0 means COM1, 1 means COM2, etc.
*/
unsigned char EX_SetCOMport ( unsigned char COM_Num);

/*
A call to this function is required if you plan on changing any configuration 
parameters prior to the first call to the EX_Run function.

Unless this call has been preceeded by either a call to  EX_SetDevToIniSetup,  
or any other API call that changes configuration parameters, it will attempt to 
connect to the device using COM1, and setup the device with default settings 
stored within the DLL  ( discussed elsewhere within the available M201 
documentation ).  Any, or all, configuration parameters can be changed at 
anytime either prior to, or after a call to this function.

Using this rather than going directly to the EX_Run() allows you to setup a lot 
of custom configuration parameters prior to starting a scan, and also leaves 
you in  polled mode where you can read single voltages using  
EX_GetOneConversion,  or perform other I/O functions. For example, you could 
use our  IniTool.exe  ( available at our website )  to create a custom 
configuration, followed by a call to  EX_SetDevToIniSetup,  or any other API 
call that changes configuration parameters.

This call is made implicitly by the DLL when the EX_Run() function is called if 
a prior call to this function hasn't been made.

Arguments 

Return type: 
8-bit. 1 (true) = success,    0 (false) = failed
*/
unsigned char  EX_InitDev ( void );

/*
Call this function to set Polled Mode main and sub channel. Analog input chan 0 
to 5. Channel 6 is +5 volts reference for full scale calibration, Chan 7 is 0 
volts and used for offset calibration 

Arguments 

1st parameter: 
Point to an 8-bit value that DLL will set the Polled Mode main channel to.

2nd parameter: 
Point to an 8-bit value that DLL will set the Polled Mode sub channel to.

Return type: 
8-bit. 1 (true) = success,    0 (false) = failed
*/
unsigned char   EX_SetPolledModeChan ( unsigned char bMainChan, unsigned char bSubChan );

/*
Call this function to get a conversion in Polled Mode. If you are currently
running (scanning), be sure to call   EX_Stop	  prior to doing this. Failure
to do so will result in loss of scan data, and improper closing of any log files
which might currently be opened. If not currently signed on, the DLL will
attempt to perform a signon before reading the analog input. If it cannot signon
or read, it will return FALSE. 

Arguments 

1st parameter: 
Point to floating point variable that DLL will set equal to the current
conversion as millivolts.

Return type: 
8-bit. 1 (true) = success,    0 (false) = failed
*/
unsigned char EX_GetOneConversion ( double* dblMilliVolts );
