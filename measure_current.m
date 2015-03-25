function [ I ] = measure_current( )
%MEASURE_CURRENT Measure the power supply currents using the built-in sensing

global config;

% TODO
if 1
%if config.dryrun==1
    I=[0 0 0];
    return
end

for k=[1 2 3]
    fprintf(config.instruments.psu(k), 'I%d?\n', config.instruments.psuout(k));
    reply = fgetl(config.instruments.psu(k));
    disp(reply)
    I(k) = sscanf(reply, sprintf('I%d %%f', config.instruments.psuout(k)));
end

end % function

