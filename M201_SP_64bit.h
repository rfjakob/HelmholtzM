
#define BYTE unsigned char
#define BOOLEAN unsigned char
#define USHORT unsigned short
#define DOUBLE double
#define UINT unsigned int
#define HANDLE unsigned int
#define INT int
#define DWORD unsigned int



	//8-11-08
	__declspec(dllexport)  BOOLEAN  
	DLL_SendPacket(UINT uiData1, UINT uiData2);
	
	//2-5-07 
	__declspec(dllexport)  BOOLEAN  
	EX_DoTimDbgNew(BOOLEAN fSetOn);

	//2-2-07 
	__declspec(dllexport)  BOOLEAN  
	SetDigOutPriorityOption(BYTE bSet);

	__declspec(dllexport)  BOOLEAN  
	EX_SendDigoutWScan(BYTE bDigOut, BYTE* pbIsPending);
	__declspec(dllexport)  BOOLEAN  
	EX_DoDebugNorm(BYTE bDebugLevel);


	__declspec(dllexport)  BOOLEAN  
	EX_SetModel(short* iVersion);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// INI RELATED    INI RELATED    INI RELATED    INI RELATED    INI RELATED +    
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	__declspec(dllexport)  BOOLEAN  
	EX_SetDevToDefaultSetup(void);
	__declspec(dllexport)  BOOLEAN  
	EX_SetDevToIniSetup(void);
	__declspec(dllexport)  BOOLEAN  
	EX_WriteCurrentConfigToIniFile(void);


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// MISC I/O    MISC I/O    MISC I/O    MISC I/O    MISC I/O    MISC I/O   ++    
	__declspec(dllexport)  BOOLEAN  
	EX_SendDigout(BYTE bDigOut);
	__declspec(dllexport)  BOOLEAN  
	EX_GetDigin(BYTE* bDigIn);

//	__declspec(dllexport)  BOOLEAN  
//	EX_SendChan(BYTE bPolledChan);

	__declspec(dllexport)  BOOLEAN  
	EX_GetOneConversion(double* dblMilliVolts);

	__declspec(dllexport)  BOOLEAN  
	EX_Standby(BYTE bStandby);
	__declspec(dllexport)  BOOLEAN  
	EX_Sleep(BYTE bSleep);

	__declspec(dllexport)  BOOLEAN  
	EX_SystemCalibration(void);
	__declspec(dllexport)  BOOLEAN  
	EX_FullScaleCalibration(void);
	__declspec(dllexport)  BOOLEAN  
	EX_OffsetCalibration(void);


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// SCAN RELATED   SCAN RELATED   SCAN RELATED   SCAN RELATED   SCAN RELATED      
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	//7-18-06
	__declspec(dllexport)  BOOLEAN  
	EX_SetDiginScan(BOOLEAN fDoDiginScan);
	__declspec(dllexport)  BOOLEAN  
	EX_GetDiginWScan(BYTE *pbDigin);

	__declspec(dllexport)  BOOLEAN  
	EX_GetScanDataDbl(double* pdblDataBuff, UINT uiNumScansToReturn, UINT* puiNumScansReturned, UINT* puiNumScansInBuff, BOOLEAN* pfStillScanning);
	__declspec(dllexport)  BOOLEAN  
	EX_GetScanDataInt(INT* piDataBuff, UINT uiNumScansToReturn, UINT* puiNumScansReturned, UINT* puiNumScansInBuff, BOOLEAN* pfStillScanning);

	__declspec(dllexport)  BOOLEAN  
	EX_GetMultiChanScanChanCodes(BYTE* bChan0, BYTE* bChan1, BYTE* bChan2, BYTE* bChan3, BYTE* bChan4, BYTE* bChan5, BYTE* bTotalChans);
	__declspec(dllexport)  BOOLEAN  
	EX_SetMultiChanScanChanCodes(BYTE bChan0, BYTE bChan1, BYTE bChan2, BYTE bChan3, BYTE bChan4, BYTE bChan5, BOOLEAN fUpdateIni);

	__declspec(dllexport)  BOOLEAN  
	EX_SetSingleChanScanChanCode(BYTE bChanCode);
	__declspec(dllexport)  BOOLEAN  
	EX_GetSingleChanScanChanCode(BYTE* bChanCode);

	__declspec(dllexport)  BOOLEAN  
	EX_SetScanType(BYTE bScanType);
	__declspec(dllexport)  BOOLEAN  
	EX_GetScanType(BYTE bScanType);

	__declspec(dllexport)  BOOLEAN  
	EX_GetScanInterval(double* dblCurrentInterval);
	// the following two aren't currently used. If I start to use them, I will have to do 
	//  some sort of averaging in the DLL which should actually be done in the application.
	__declspec(dllexport)  BOOLEAN  
	EX_SetToMinScanInterval(void);
	//mangled counterpart 8-11-08
	//__declspec(dllexport)  BOOLEAN  
	//_EX_SetToMinScanInterval@0(void);

	__declspec(dllexport)  BOOLEAN  
	EX_GetScanIntervalMinMax(double* dblMinInterval, double* dblMaxInterval);
	//mangled counterpart 8-11-08
	//__declspec(dllexport)  BOOLEAN  
	//_EX_GetScanIntervalMinMax@8(double* dblMinInterval, double* dblMaxInterval);


	__declspec(dllexport)  BOOLEAN  
	EX_SetToUserScanInterval(double* dblInterval);
	//mangled counterpart 8-11-08
	//__declspec(dllexport)  BOOLEAN  
	//_EX_SetToUserScanInterval@4(double* dblInterval);


	// maybe elimintate this one
	__declspec(dllexport)  BOOLEAN  
	EX_SetToMaxScanInterval(void);
	//mangled counterpart 8-11-08
	//__declspec(dllexport)  BOOLEAN  
	//_EX_SetToMaxScanInterval@0(void);




	__declspec(dllexport)  BOOLEAN  
	EX_GetDataLogOptions(UINT* uiDataLogMethod, UINT* uiLogFileMaxSize, UINT* uiMisc);
	__declspec(dllexport)  BOOLEAN  
	EX_SetDataLogOptions(UINT uiDataLogMethod, UINT uiLogFileMaxSize, UINT uiMisc);
	__declspec(dllexport)  BOOLEAN  
	EX_SetExperimentName(char* pszName);
	__declspec(dllexport)  BOOLEAN  
	EX_AddLogFileComment(char* pszComment);


//	__declspec(dllexport)  BOOLEAN  
//	EX_GetMaxDataBufferSize(UINT* uiDataBufferSize);
//	__declspec(dllexport)  BOOLEAN  
//	EX_SetDataBufferSize(UINT* uiDataBufferSize);

	__declspec(dllexport)  BOOLEAN  
	EX_SetLengthOfRunMs(UINT uiMilliseconds);
	__declspec(dllexport)  BOOLEAN  
	EX_SetLengthOfRunSec(UINT uiSeconds);
	__declspec(dllexport)  BOOLEAN  
	EX_SetRunEndBeepOptions(BOOLEAN _fUseBeep, UINT uiBeepFreqMs, UINT uiBeepDurationMs, UINT uiBeepIntervalSec, UINT uiBeepTimeoutSec);
	__declspec(dllexport)  BOOLEAN  
	EX_StopRunEndBeep(void);

//	__declspec(dllexport)  BOOLEAN  
//	EX_GetDevScanSetupErrors(UINT* puiErrors);
	__declspec(dllexport)  BOOLEAN  
	EX_StartScan(void);

	//4-21-10
	__declspec(dllexport)  BOOLEAN  
	EX_StartScan_NoSysCal(void);


	__declspec(dllexport)  BOOLEAN  
	EX_EndScan(void);

	__declspec(dllexport)  BOOLEAN  
	EX_DoScanDebug(BYTE bLevel);
	


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// INIT & SETUP RELATED    INIT & SETUP RELATED    INIT & SETUP RELATED  +++     
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	__declspec(dllexport)  BOOLEAN  
	EX_InitDev(void);
	__declspec(dllexport)  BOOLEAN  
	EX_SetDevToIniSetup(void);
	__declspec(dllexport)  BOOLEAN  
	EX_ShowDevSetupInfo_MsgBox(void);
	__declspec(dllexport)  BOOLEAN  
	EX_ShowDevSetupInfo_WriteToFile(void);
//	__declspec(dllexport)  BOOLEAN  
//	EX_GetDevInitSetupErrors(UINT* puiErrors);
//	__declspec(dllexport)  BOOLEAN  
//	EX_GetDevInitErrors(UINT* puiErrors);
	__declspec(dllexport)  BOOLEAN  
	EX_GetRate(double* dblRate);
	__declspec(dllexport)  BOOLEAN  
	EX_SetRate(double dblRate);

	__declspec(dllexport)  BOOLEAN  
	EX_GetPolledModeChan(BYTE* bMainChan, BYTE* bSubChan);
	__declspec(dllexport)  BOOLEAN  
	EX_SetPolledModeChan(BYTE bMainChan, BYTE bSubChan);



//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// NO-BRAINER  NO-BRAINER  NO-BRAINER  NO-BRAINER  NO-BRAINER  NO-BRAINER  +   
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	//__declspec(dllexport)  BOOLEAN  
	//fSetLogFile(char* pszName, BYTE bNameLength);
	__declspec(dllexport)  BOOLEAN  
	EX_Reset(void);
	__declspec(dllexport)  BOOLEAN  
	EX_Run(void);
	__declspec(dllexport)  BOOLEAN  
	EX_CheckRun(void);
	__declspec(dllexport)  BOOLEAN  
	EX_Stop(void);
	__declspec(dllexport)  BOOLEAN  
	EX_GetCOMport(BYTE* bPort);
	__declspec(dllexport)  BOOLEAN  
	EX_SetCOMport(BYTE bPort);


	__declspec(dllexport)  BOOLEAN  
	EX_SetGain(BYTE bGain);
	__declspec(dllexport)  BOOLEAN  
	EX_GetGain(BYTE* pbGain);
	__declspec(dllexport)  BOOLEAN  
	EX_SetRemoteAverage(USHORT usAvg);
	__declspec(dllexport)  BOOLEAN  
	EX_GetRemoteAverage(USHORT* pusAvg);
	__declspec(dllexport)  BOOLEAN  
	EX_SetPolarity (BYTE bPolarity);
	__declspec(dllexport)  BOOLEAN  
	EX_GetPolarity (BYTE bPolarity);
	__declspec(dllexport)  BOOLEAN  
	EX_SetFilter (BYTE bFilter);
	__declspec(dllexport)  BOOLEAN  
	EX_GetFilter(BYTE* pbFilter);



/*
	BOOLEAN  
	SP_SetProcessPriorityBoost(BYTE bProcessPriority);


	//__declspec(dllexport)  short  
	//SignOn();

	BOOLEAN
	DLL_SendPacket(UINT uiData1, UINT uiData2);

	short  
	RemoteAvg(void);

	short  
	FullScaleCal(void);

	short  
	OffsetCal(void);

	short  
	SysCal(void);

	double 
	Counts2Volts(void);

	short  
	GetDigIn(void);

	short  
	SetDigOut(int digOutWord);

	short  
	GetVer(void);

	//6-22-04 __declspec(dllexport)  short  
	//GetConversion(void);

	short  
	SetChanCode(void);

	short  
	StartScanning(void);

	//12-18-00
	UINT  
	GetNumBytesInBuffer(void);

	//12-28-00 new function added
	UINT  
	GetNumScansInSerialBuffer(void);

	short  
	GetOneScan(void);

	short  
	StopScanning(void);

	void   
	Gconv(void);

	void   
	RemFromBuffer(short size);

	void   
	SetFilter(short filter);

	short  
	SendADMode(void);

	short  
	GetCheckSum(void);

	short  
	CloseDevice(void);

	short  
	GotoSleep(void);

	void   
	WriteCntr(int cntPort, int cntrCount);

	void   
	FilterDelay(short filter);

	short  
	CheckScanTime(double *maxTime, double *minTime);

	void   
	FilterDelay(short filter);

	void   
	GetComHandle(HANDLE *idComDev);

	void   
	SetComHandle(HANDLE idComDev);


	//1-9-01
	BOOLEAN 
	GetOneScanWithDigin(BOOLEAN* bNewDigin, BOOLEAN bGetDigin);

	BOOLEAN 
	DoDebug(BYTE bDebugLevel);
*/

