function [  ] = plot_log( log )
%PLOT_LOG Summary of this function goes here
%   Detailed explanation goes here

global global_state

is=1e3; % I_Scale (mA)
bs=1e6; % B_Scale (uT)
xyz='XYZ';

axes_xyz=[global_state.guihandles.axes_x ...
    global_state.guihandles.axes_y global_state.guihandles.axes_z];
axes_xyz2=[global_state.guihandles.axes_x2 ...
    global_state.guihandles.axes_y2 global_state.guihandles.axes_z2];

for k=1:3
    AX(1)=axes_xyz(k);
    AX(2)=axes_xyz2(k);
    
%     [AX,H1,H2]=plotyy(0,0,0,0);
%     xlim(AX(1),'auto')
%     ylim(AX(1),'auto')
%     xlim(AX(2),'auto')
%     ylim(AX(2),'auto')
  
    % http://blogs.mathworks.com/pick/2006/05/26/plotting-multiple-y-scales/ comment #6
    %set(AX(2),'nextplot','add');
    hce=stairs(  AX(2), log.current_expected(:,1), log.current_expected(:,k+1)*is,'r');
    hold(AX(2), 'on')
    hcm=plot(  AX(2), log.current_measured(:,1), log.current_measured(:,k+1)*is,'r.'); 
    set(AX(2), 'YAxisLocation','right');
    set(AX(2), 'Color','none');
    set(AX(2), 'YColor','r');
    ylabel(AX(2), 'mA')
    ax2_xlim = xlim(AX(2));
    hold(AX(2), 'off')
    
    hfm=plot(  AX(1), log.field_measured(:,1), log.field_measured(:,k+1)*bs,'b.');
    hold(AX(1), 'on')
    %hfa=stairs(AX(1), log.field_set_antiparallel(:,1), log.field_set_antiparallel(:,k+1)*bs,'k--');
    hfe=stairs(AX(1), log.field_expected(:,1), log.field_expected(:,k+1)*bs);
    set(AX(1), 'YColor','b');
    
    %title(xyz(k));
    ylabel(AX(1), 'uT')
    title(AX(1), xyz(k));
    %grid(AX(1), 'on');
    if k == 3
         xlabel(AX(1), 'Runtime (seconds)');
    end
    xlim(AX(1), ax2_xlim);
    hold(AX(1), 'off');
    
end % for

persistent legend_drawn;

if isempty(legend_drawn) 

    legend_drawn = 'ok';
    
    % Add legend over top dummy plot
    a = global_state.guihandles.axes_legend;
    hold(a, 'on');
    hfe=stairs(a, [0 1], [0 0]);
    hfm=plot(  a, 0, 0, 'b.');
    %hfa=stairs(a, 0, 0, 'k--');
    hce=stairs(  a, 0, 0,'r');
    hcm=plot(  a, 0, 0, 'r.');
    %legend([hfe;hfm;hfa;hce;hcm] ...
    legend([hfe;hfm;hce;hcm] ...
        ,'Expected flux density' ...
        ,'Measured flux density' ...
        ... ,'Antipar. pseudo flux densiy (uT)'
        ,'Expected current' ...
        ,'Measured current' ...
        ,'Location','NorthWest')
    ylabel(a, 'legend');
    set(a, 'XTickLabel', []); % disable tick labeling
    set(a, 'XTick', []);
    set(a, 'YTickLabel', []);
    set(a, 'YTick', []);
end
    
end % function
