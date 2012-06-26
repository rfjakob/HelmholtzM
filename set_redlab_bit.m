function [ ] = set_redlab_bit( bitname, value )
%SET_REDLAB_BIT Set a bit (or bit block) on the redlab unit by functional
%name (see below).
%   If the bit already has that value, this function is a no-op.


persistent bitvals

if isempty(bitvals)
    bitvals.antiparallel=0;
    bitvals.XPOL=0;
    bitvals.YPOL=0;
    bitvals.ZPOL=0;
end
    

switch bitname
    case 'antiparallel'
        if bitvals.antiparallel==value
            return
        end
        % TODO x 3
    case 'XPOL'
        if bitvals.XPOL==value
            return
        end
        % TODO
    case 'YPOL'
        if bitvals.YPOL==value
            return
        end        
        % TODO
    case 'ZPOL'
        if bitvals.ZPOL==value
            return
        end
        % TODO
    otherwise
        bitname
        error('BUG: Invalid bitname')
end


end

