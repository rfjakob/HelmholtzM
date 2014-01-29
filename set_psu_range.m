function [ ] = set_psu_range( irange )
%SET_PSU_RANGE Summary of this function goes here
%   Detailed explanation goes here

global config

for k=[1 2 3]
    if config.dryrun==0
        set_psu_output(k,0);
        fprintf(config.instruments.psu(k), 'IRANGE1 %d\n', irange);
    end
end

end

