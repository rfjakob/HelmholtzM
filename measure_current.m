function [ I ] = measure_current( )
%MEASURE_CURRENT Measure the power supply currents using the built-in sensing

global config;

% Write-out asynchronously to all three simultaneously for speed
f='I1O?\n';
fprintf(config.instruments.psux, f, 'async');
fprintf(config.instruments.psuy, f, 'async');
fprintf(config.instruments.psuz, f, 'async');

% query(s,'I1O?') -> 0.1A
f='%fA';
% Why not direct fscanf()? Can't debug the received string!
s.x=fscanf(config.instruments.psux);
I(1)=sscanf(s.x, f);
s.y=fscanf(config.instruments.psuy);
I(2)=sscanf(s.y, f);
s.z=fscanf(config.instruments.psuz);
I(3)=sscanf(s.z, f);


end

