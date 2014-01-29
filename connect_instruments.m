function [ ] = connect_instruments( )
%CONNECT_INSTRUMENTS Open the handles to the instruments (power supply, magnetometer)

global config;

try
    fclose(instrfind);
end

s=coilcontrol_settings();

[config.instruments.psu(1) idn] = open_psu(s.psucom.x);
[config.instruments.psu(2) idn] = open_psu(s.psucom.y);
[config.instruments.psu(3) idn] = open_psu(s.psucom.z);
set_psu_range(1);
set_psu_output([1 2 3], 1);

[BoardNum, PortNum]=redlab_conf();

if config.dryrun==1
    r=0;
else
    % http://www.mathworks.com/matlabcentral/answers/259-warnings-returned-by-loadlibrary
    warning off MATLAB:loadlibrary:TypeNotFound
    [notfound,warnings]=loadlibrary('cbw32.dll','cbw32.h');
    % int cbDConfigPort(int BoardNum, int PortNum, int Direction)
    r=calllib('cbw32','cbDConfigPort',BoardNum,PortNum,1);
end

if r~=0
    error('Could not initialize redlab relay switching board: Error %d',r)
end

connect_mag03dam();
    
end

