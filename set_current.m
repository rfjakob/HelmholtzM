function [ output_args ] = set_current( I_coil )
%SET_CURRENT Make the power supplies output the specified (I=[ Ix Iy Iz ])
%current


return % Disabled for now

global config;

I_old=config.set_current;

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
        set_redlab_bit(['POL' xyz(k)],1)
    elseif I_coil(k)>=0 && I_old(k)>=0
        set_redlab_bit(['POL' xyz(k)],0)
    end
end

% Write-out asynchronously to all three simultaneously for speed
f='I1 %d\n';
fprintf(config.instruments.psux, f,I_psu(1), 'async');
fprintf(config.instruments.psuy, f,I_psu(2), 'async');
fprintf(config.instruments.psuz, f,I_psu(3), 'async');

% Wait for completion
wait_time=0.01;
wait_num=0;
while 1
    if config.visa.psux.BytesToOutput==0 ...
            && config.visa.psuy.BytesToOutput==0 ...
            && config.visa.psuz.BytesToOutput==0
        break
    end
    if config.abort==1
        disp('User abort in set_current')
        break
    end
    
    pause(p)
    k=k+1;
    
    if wait_time*wait_num > 1
        % Longer than 1 second - something's broken
        disp('Timeout in set_current')
        break
    end
end

config.set_current=I_coil;
