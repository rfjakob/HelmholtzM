loadlibrary('C:\Program Files (x86)\Meilhaus Electronic\RedLab\cbw32.dll','cbw.h')

BoardNum=0;
PortNum=11;

% int cbDConfigPort(int BoardNum, int PortNum, int Direction)
calllib('cbw32','cbDConfigPort',BoardNum,PortNum,1)

%int int cbDOut(int BoardNum, int PortNum, unsigned short DataValue)
calllib('cbw32','cbDOut',BoardNum,PortNum,127)