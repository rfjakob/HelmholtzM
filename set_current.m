function [ output_args ] = set_current( I )
%SET_CURRENT Make the power supplies output the specified (I=[ Ix Iy Iz ])
%current


return % Disabled for now

global config;

f='I1 %d\n';
if I(1)<0
    set_redlab_bit('POLX',1)
    I(1)=-I(1);
end
if I(2)<0
    set_redlab_bit('POLY',1)
    I(2)=-I(2);
end
if I(3)<0
    set_redlab_bit('POLZ',1)
    I(3)=-I(3);
end
fprintf(config.instruments.psux,f,I(1),'async');
fprintf(config.instruments.psuy,f,I(2),'async');
fprintf(config.instruments.psuz,f,I(3),'async');

k=0;
p=0.01;
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
    
    if p*k > 1 % Longer than 1 second
        disp('Timeout in set_current')
        break
    end
end

config.set_current=I;
