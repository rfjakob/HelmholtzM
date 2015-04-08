function [ ] = set_psu_range( irange )
%SET_PSU_RANGE Summary of this function goes here
%   Detailed explanation goes here

global global_state

for k=[1 2 3]
    if global_state.dryrun==0
        set_psu_output(k, 0);
        fprintf(global_state.instruments.psu(k), 'IRANGE%d %d\n', [global_state.instruments.psuout(k); irange]);
    end
end

end

