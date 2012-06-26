function [ ] = set_psu_output( state )
%SET_PSU_OUTPUT Set OUTPUT ON (state==1) of OFF (state==0) on all power supplies.
%   Used for example before switching relays to prevent arcing.

global config

if state == 0
    f='OUT1 OFF';
elseif state == 1
    f='OUT1 ON';
else
    state
    error('BUG: Invalid state')
end

fprintf(config.instruments.psux,f);
fprintf(config.instruments.psuy,f);
fprintf(config.instruments.psuz,f);

config.psu_output_state = state;

end

