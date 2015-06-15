function [ ] = connect_instruments( )
%CONNECT_INSTRUMENTS Open the handles to the instruments (power supply, magnetometer)

global global_state;

try
    fclose(instrfind);
end

s=config();

try
    global_state.instruments.psuout(1) = s.psuout.x;
    global_state.instruments.psu(1) = open_psu(s.psucom.x);
catch e
    errordlg('Could not connect to power supply "X"');
    rethrow(e);
end

try
    global_state.instruments.psuout(2) = s.psuout.y;
    if s.psucom.y == s.psucom.x
        global_state.instruments.psu(2) = global_state.instruments.psu(1);
    else
        global_state.instruments.psu(2) = open_psu(s.psucom.y);
    end
catch e
    errordlg('Could not connect to power supply "Y"');
    rethrow(e);
end

try
    global_state.instruments.psuout(3) = s.psuout.z;
    global_state.instruments.psu(3) = open_psu(s.psucom.z);
catch e
    errordlg('Could not connect to power supply "Z"');
    rethrow(e);
end

if global_state.dryrun == 0
    try
        global_state.instruments.arduino = serial(sprintf('com%d', s.arduino));
        fopen(global_state.instruments.arduino);
        fprintf(global_state.instruments.arduino, '%s\r\n', 'RESET');
        r = fgetl(global_state.instruments.arduino);
        if ~strcmp(sprintf('OK\r'), r)
           error('Got error from arduino: %s', r);
        end
    catch e
        errordlg('Could not connect to Arduino');
        rethrow(e);
    end
end

connect_mag03dam();
    
end

