function [ ] = set_redlab_bit( bitname, BitValue )
%SET_REDLAB_BIT Set a bit (or bit block) on the redlab unit by functional
%name (see below).

switch bitname
    case 'antiparallel'
        BitNum=[8 10 12];
    case 'XPOL'
        BitNum=9;
    case 'YPOL'   
        BitNum=11;
    case 'ZPOL'
        BitNum=13;
    otherwise
        error('BUG: Invalid bitname "%d"',bitname)
end
 
[BoardNum,~,PortType]=redlab_conf();

for b=BitNum
    % int cbDBitOut(int BoardNum, int PortType, int BitNum, unsigned short BitValue)
    r=calllib('cbw32','cbDBitOut',BoardNum, PortType, b, BitValue);
    if r~=0
        error('Could set bit on redlab relay switching board: Error %d',r)
    end
end

end

