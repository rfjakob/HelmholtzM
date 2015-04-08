function [ I ] = measure_current( )
%MEASURE_CURRENT Measure the power supply currents using the built-in sensing

global global_state;

if global_state.dryrun==1
    I=[0 0 0];
    return
end

for k=[1 2 3]
    psu = global_state.instruments.psu(k);
    output = global_state.instruments.psuout(k);

    fprintf(psu, 'I%d?\n', output);
    reply = fgetl(psu);
    I(k) = sscanf(reply, sprintf('I%d %f', output));
end

end % function

