function [ ] = set_arduino_bit( bitname, BitValue )
%SET_REDLAB_BIT Set a bit (or bit block) on the redlab unit by functional
%name (see below).

global config

switch bitname
    case 'antiparallel'
        BitNum=[1 2 3];
    case 'XPOL'
        BitNum=4;
    case 'YPOL'   
        BitNum=5;
    case 'ZPOL'
        BitNum=6;
    otherwise
        error('BUG: Invalid bitname "%d"',bitname)
end

for b=BitNum
    if config.dryrun==1
        return
    end
    
    for bit=BitNum
        fprintf(config.instruments.arduino, 'P%d %d', bit, BitValue);
        r = fgetl(config.instruments.arduino);
        if ~strcmp('OK', r)
            error('Got error from arduino: %s', r);
        end
    end
end

end % function

