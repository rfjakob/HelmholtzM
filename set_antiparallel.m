function [ ] = set_antiparallel( state )
%SET_ANTIPARALLEL Switch the relays to antiparallel (state==1) currents.
%   Switches off the outputs of the power supplies first to prevent arcing.

global config;

if config.psu_output_state == 0
    % PSU output is already off, just switch
    set_redlab_bit('antiparallel',state);
else
    % Output is on, set to off first, switch relays, set back on
    set_psu_output(0);
    pause(0.2);
    set_redlab_bit('antiparallel',state);
    set_psu_output(1);
end



end
