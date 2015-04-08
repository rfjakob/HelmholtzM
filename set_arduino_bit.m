function [ ] = set_arduino_bit( bitname, BitValue )
%SET_REDLAB_BIT Set a bit (or bit block) on the redlab unit by functional
%name (see below).

global global_state

switch bitname
    case 'antiparallel'
        BitNum=[1 3 5]; % TODO
    case 'XPOL'
        BitNum=[1 2];
    case 'YPOL'   
        BitNum=[3 4];
    case 'ZPOL'
        BitNum=[5 6];
    otherwise
        error('BUG: Invalid bitname "%d"',bitname)
end

for b=BitNum
    if global_state.dryrun==1
        return
    end
    
    for bit=BitNum
        fprintf(global_state.instruments.arduino, '%s\r\n', sprintf('P%d %d', [bit; BitValue]));
        r = fgetl(global_state.instruments.arduino);
        if ~strcmp(sprintf('OK\r'), r)
            error('Got error from arduino: %s', r);
        end
    end
end

end % function

