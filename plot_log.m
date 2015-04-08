function [  ] = plot_log( log )
%PLOT_LOG Summary of this function goes here
%   Detailed explanation goes here

global config

is=1e3; % I_Scale (mA)
bs=1e6; % B_Scale (uT)
xyz='XYZ';
figure(1)
for k=1:3
    a=subplot(3,1,k);
    AX(1)=a;
    AX(2)=a;
    
%     [AX,H1,H2]=plotyy(0,0,0,0);
%     xlim(AX(1),'auto')
%     ylim(AX(1),'auto')
%     xlim(AX(2),'auto')
%     ylim(AX(2),'auto')
  
    % http://blogs.mathworks.com/pick/2006/05/26/plotting-multiple-y-scales/ comment #6
    %set(AX(2),'nextplot','add');
    hce=plot(  AX(2), log.current_expected(:,1),       log.current_expected(:,k+1)*is,'ro');
    hold on
    hcm=plot(  AX(2), log.current_measured(:,1),       log.current_measured(:,k+1)*is,'r.'); 
    
    hfm=plot(  AX(1), log.field_measured(:,1),         log.field_measured(:,k+1)*bs,'b.');
    hfa=stairs(AX(1), log.field_set_antiparallel(:,1), log.field_set_antiparallel(:,k+1)*bs,'k:');
    hfe=stairs(AX(1), log.field_expected(:,1),         log.field_expected(:,k+1)*bs);
    
    title(xyz(k));
    ylabel('{\mu}T / mA')
    grid on;
    if k==1
        legend([hfe;hfm;hfa;hce;hcm],'Expected flux density ({\mu}T)','Measured flux density ({\mu}T)','Antipar. pseudo flux densiy ({\mu}T)' ...
            ,'Expected current (mA)','Measured current (mA)', 'Location','NorthWest')
    elseif k==3
         xlabel('Runtime (seconds)');
    end
    hold off
end

