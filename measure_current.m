function [ I ] = measure_current( )
%MEASURE_CURRENT Measure the power supply currents using the built-in sensing

global config;

if config.dryrun==1
    I=[0 0 0];
    return
end

for k=[1 2 3]
    fprintf(config.instruments.psu(k), 'I%d0?\n', config.instruments.psuout(k));
    I(k) = fscanf(config.instruments.psu(k), '%fA');
end

end % function

