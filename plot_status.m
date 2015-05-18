function [ ] = plot_status( )
%PLOT_STATUS Plot points to go and points done to the 3d axes plot

global global_state;

ax3d=global_state.guihandles.axes_3d;
ax2=global_state.guihandles.axes_2d;

path(path, 'oaxes')

ef=global_state.earth_field*1e6; % uT
pt=global_state.points_todo(:,1:3)*1e6;
pd=global_state.points_done*1e6;
if isempty(pt)
   plot3(ax3d,nan,nan,nan);
   plot(ax2,nan,nan);
   return
end

if isempty(pd)
    plot3(ax3d,ef(1),ef(2),ef(3),'og',pt(:,1),pt(:,2),pt(:,3),'ob');
else
    plot3(ax3d,ef(1),ef(2),ef(3),'og',pt(:,1),pt(:,2),pt(:,3),'ob',pd(:,1),pd(:,2),pd(:,3),'xr')
end


set(ax3d,'XColor','blue','YColor','green', 'ZColor','red')
oaxes(ax3d,[0 0 0])
axis(ax,'vis3d')
axis(ax3d,'equal')
set(ax3d, 'CameraViewAngle',7)

ap = global_state.points_todo(:,4); % Antiparallel bit (1=antiparallel, 0=normal)

[actual_expected_field, would_be_field]=points_to_expected_field(global_state.points_todo);

% Make the stairs plot draws a line for the last point
actual_expected_field(end+1,:)=actual_expected_field(end,:);
would_be_field(end+1,:)=would_be_field(end,:);

t=(0:size(actual_expected_field,1)-1)*global_state.step_time;
t=t.';
t3=[t t t];
h1=stairs(ax2,t3,would_be_field*1e6,'--');
hold(ax2,'on');
h2=stairs(ax2,t3,actual_expected_field*1e6);
ylabel(ax2,'Flux density (uT)');
xlabel(ax2,'t (s)');
grid(ax2,'on');
hold(ax2,'off');
legend([h2; h1(1)],'X','Y','Z','Antipar.');

ymax=max(max(global_state.points_todo(:,1:3)))*1.1*1e6; % 1.1 ... add a bit of headroom
ymin=min(min(global_state.points_todo(:,1:3)))*1.1*1e6; % 1e6 ... uT
ylim([ymin ymax]);

eta=size(actual_expected_field,1)*global_state.step_time;
eta=datestr(datenum(0,0,0,0,0,eta),'HH:MM:SS');
set(global_state.guihandles.text_eta,'String',eta);

end