function [ ] = connect_instruments( )
%CONNECT_INSTRUMENTS Open the handles to the instruments (power supply, magnetometer)

global config;

if config.dryrun==1
    return
end

try
    fclose(instrfind);
end

[config.instruments.psux idn] = open_psu(3);
[config.instruments.psuy idn] = open_psu(4);
[config.instruments.psuz idn] = open_psu(5);
set_psu_output(1);

[notfound,warnings]=loadlibrary('C:\Program Files (x86)\Meilhaus Electronic\RedLab\cbw32.dll','cbw.h');

% int cbDConfigPort(int BoardNum, int PortNum, int Direction)
[BoardNum, PortNum]=redlab_conf();
r=calllib('cbw32','cbDConfigPort',BoardNum,PortNum,1);
if r~=0
    error('Could not initialize redlab relay switching board: Error %d',r)
end
    
end

