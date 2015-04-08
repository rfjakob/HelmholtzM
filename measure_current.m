function [ I ] = measure_current( )
%MEASURE_CURRENT Measure the power supply currents using the built-in sensing

global global_state;

% TODO
if 1
%if global_state.dryrun==1
    I=[0 0 0];
    return
end

for k=[1 2 3]
    fprintf(global_state.instruments.psu(k), 'I%d?\n', global_state.instruments.psuout(k));
    reply = fgetl(global_state.instruments.psu(k));
    disp(reply)
    I(k) = sscanf(reply, sprintf('I%d %%f', global_state.instruments.psuout(k)));
end

end % function

