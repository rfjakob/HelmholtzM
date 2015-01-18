function [ ] = set_antiparallel( state )
%SET_ANTIPARALLEL Switch the relays to antiparallel (state==1) currents.
%   Switches off the outputs of the power supplies first to prevent arcing.

persistent last_state;

if isempty(last_state)
    last_state=-1;
end

if last_state~=state
    set_psu_output(1,0);
    set_psu_output(2,0);
    set_psu_output(3,0);
    pause(1);
    set_arduino_bit('antiparallel',state);
    set_psu_output(1,1);
    set_psu_output(2,1);
    set_psu_output(3,1);
    last_state=state;
end



end
