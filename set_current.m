function [ output_args ] = set_current( I_coil )
%SET_CURRENT Make the power supplies output the specified (I=[ Ix Iy Iz ])
%current

global config;
persistent I_old;

if isempty(I_old)
    I_old=[0 0 0];
end

xyz='XYZ';
for k=[1 2 3]

    % The PSU current is always positive, the relays reverse the polarity
    if I_coil(k)<0
        I_psu(k)=-I_coil(k);
    else
        I_psu(k)=I_coil(k);
    end
    
    % If the polarity is changing, switch the relays
    if I_coil(k)<0 && I_old(k)>=0
        set_arduino_bit([xyz(k) 'POL'],1)
    elseif I_coil(k)>=0 && I_old(k)>=0
        set_arduino_bit([xyz(k) 'POL'],0)
    end
    
    if config.dryrun==0
        set_psu_output(k,1);
        % TODO. Current control does not work.
        fprintf(config.instruments.psu(k), 'I%d %d\n', [config.instruments.psuout(k); I_psu(k)]);
    end
end

I_old=I_coil;
end
