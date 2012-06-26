function [ ] = set_redlab_bit( bitname, value )
%SET_REDLAB_BIT Set a bit (or bit block) on the redlab unit by functional
%name (see below).

switch bitname
    case 'antiparallel'
        % TODO x 3
    case 'XPOL'
        % TODO
    case 'YPOL'   
        % TODO
    case 'ZPOL'
        % TODO
    otherwise
        bitname
        error('BUG: Invalid bitname')
end


end

