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
        set_redlab_bit([xyz(k) 'POL'],1)
    elseif I_coil(k)>=0 && I_old(k)>=0
        set_redlab_bit([xyz(k) 'POL'],0)
    end
end

f='I1 %d\n';

fprintf(config.instruments.psux, f,I_psu(1));
fprintf(config.instruments.psuy, f,I_psu(2));
fprintf(config.instruments.psuz, f,I_psu(3));

%{
% Write-out asynchronously to all three simultaneously for speed
fprintf(config.instruments.psux, f,I_psu(1), 'async');
fprintf(config.instruments.psuy, f,I_psu(2), 'async');
fprintf(config.instruments.psuz, f,I_psu(3), 'async');

% Wait for completion
wait_time=0.01;
k=0;
while 1
    if config.instruments.psux.BytesToOutput==0 ...
            && config.instruments.psuy.BytesToOutput==0 ...
            && config.instruments.psuz.BytesToOutput==0
        break
    end
    
    pause(wait_time)
    k=k+1;
    
    if wait_time*k > 1
        % Longer than 1 second - something is broken
        disp('Timeout in set_current')
        break
    end
end
%}

I_old=I_coil;
end
