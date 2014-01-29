function [ I ] = measure_current( )
%MEASURE_CURRENT Measure the power supply currents using the built-in sensing

global config;

if config.dryrun==1
    I=[0 0 0];
    return
end

% Write-out asynchronously to all three simultaneously for speed
f='I1O?\n';
for k=[1 2 3]
    fprintf(config.instruments.psu(k), f, 'async');
end

% query(s,'I1O?') -> 0.1A
f='%fA';
% Why not direct fscanf()? Can't debug the received string!
for k=[1 2 3]
    s.x=fscanf(config.instruments.psu(k));
    I(k)=sscanf(s.x, f);
end


end

