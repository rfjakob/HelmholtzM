function [ ] = set_polarity( axis, state )
%SET_POLARITZ Summary of this function goes here
%   Detailed explanation goes here

persistent last_state;

if isempty(last_state)
    last_state=[-1 -1 -1];
end

if last_state(axis)~=state
    set_psu_output(axis,0);
    pause(0.1);
    if axis==1
        set_redlab_bit('PSUX',state);
    elseif axis==2
        set_redlab_bit('PSUX',state);
    elseif axis==3
        set_redlab_bit('PSUX',state);
    else
        error('Invalid axis')
    end
    set_psu_output(axis,1);
    last_state(axis)=state;
end

end

