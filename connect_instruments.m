function [ ] = connect_instruments( )
%CONNECT_INSTRUMENTS Open the handles to the instruments (power supply, magnetometer)

global config;

try
    fclose(instrfind);
end

s=user_config();

try
    config.instruments.psuout(1) = s.psuout.x;
    config.instruments.psu(1) = open_psu(s.psucom.x);
catch e
    errordlg('Could not connect to power supply "X"');
    rethrow(e);
end

try
    config.instruments.psuout(1) = s.psuout.y;
    if s.psucom.y == s.psucom.x
        config.instruments.psu(2) = config.instruments.psu(1);
    else
        config.instruments.psu(2) = open_psu(s.psucom.y);
    end
catch e
    errordlg('Could not connect to power supply "Y"');
    rethrow(e);
end

try
    config.instruments.psuout(3) = s.psuout.z;
    config.instruments.psu(3) = open_psu(s.psucom.z);
catch e
    errordlg('Could not connect to power supply "Z"');
    rethrow(e);
end

try
    config.instruments.arduino = serial(sprintf('com%d', s.arduino));
    fopen(config.instruments.arduino);
    fprintf(config.instruments.arduino, '%s\r\n', 'RESET');
    r = fgetl(config.instruments.arduino);
    if ~strcmp(sprintf('OK\r'), r)
       error('Got error from arduino: %s', r);
    end
catch e
    errordlg('Could not connect to Arduino');
    rethrow(e);
end


set_psu_range(1);
set_psu_output([1 2 3], 1);

% connect_mag03dam();
    
end

