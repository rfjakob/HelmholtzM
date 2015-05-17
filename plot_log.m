function [  ] = plot_log( log )
%PLOT_LOG Summary of this function goes here
%   Detailed explanation goes here

global global_state

is=1e3; % I_Scale (mA)
bs=1e6; % B_Scale (uT)
xyz='XYZ';

if ~ishandle(1)
    % Set a bigger window size when the plot is opened
    hFig=figure(1);
    set(hFig, 'Position', [100 100 800 800])
end

figure(1)

for k=1:3
    a=subplot(4,1,k+1);
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
    hfa=stairs(AX(1), log.field_set_antiparallel(:,1), log.field_set_antiparallel(:,k+1)*bs,'k--');
    hfe=stairs(AX(1), log.field_expected(:,1),         log.field_expected(:,k+1)*bs);
    
    %title(xyz(k));
    %ylabel('uT / mA')
    ylabel(xyz(k));
    grid on;
    if k == 3
         xlabel('Runtime (seconds)');
    end
    hold off
end % for

% Add legend over top dummy plot
a=subplot(4,1,1);
AX(1)=a;
AX(2)=a;
hce=plot(  AX(2), 0, 0, 'ro');
hold on
hcm=plot(  AX(2), 0, 0, 'r.'); 
hfm=plot(  AX(1), 0, 0, 'b.');
hfa=stairs(AX(1), 0, 0, 'k--');
hfe=stairs(AX(1), [0 1], [0 0]);
legend([hfe;hfm;hfa;hce;hcm] ...
    ,'Expected flux density (uT)','Measured flux density (uT)' ...
    ,'Antipar. pseudo flux densiy (uT)' ...
    ,'Expected current (mA)','Measured current (mA)' ...
    , 'Location','NorthWest')
ylabel('legend');
        
end % function
