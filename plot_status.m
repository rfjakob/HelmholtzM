function [ ] = plot_status( )
%PLOT_STATUS Plot points to go and points done to the 3d axes plot

global config;

ax3d=config.guihandles.axes_3d;
ax2=config.guihandles.axes_2d;

path(path, 'oaxes')

ef=config.earth_field*1e6; % uT
pt=config.points_todo(:,1:3)*1e6;
pd=config.points_done*1e6;
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
%axis(ax,'vis3d')
axis(ax3d,'equal')
set(ax3d, 'CameraViewAngle',7)

if config.mode==0
    step_time=config.cycle_time*config.step_size/360;
else
    step_time=config.cycle_time/2;
end

if step_time==0
    step_time=0.05;
end

ap = config.points_todo(:,4); % Antiparallel bit (1=antiparallel, 0=normal)

[actual_expected_field, would_be_field]=points_to_expected_field(config.points_todo);

% So the stairs plot draws a line for the last point
actual_expected_field(end+1,:)=actual_expected_field(end,:);
would_be_field(end+1,:)=would_be_field(end,:);

t=(0:size(actual_expected_field,1)-1)*step_time;
t=t.';
t3=[t t t];
h1=stairs(ax2,t3,would_be_field*1e6,'k:');
hold(ax2,'on');
h2=stairs(ax2,t3,actual_expected_field*1e6);
ylabel(ax2,'Flux density ({\mu}T)');
xlabel(ax2,'t (s)');
grid(ax2,'on');
hold(ax2,'off');
legend([h2; h1(1)],'X','Y','Z','Antipar.');
ylim([min(min(actual_expected_field)) max(max(actual_expected_field))]*1.1*1e6);

eta=size(actual_expected_field,1)*step_time;
eta=datestr(datenum(0,0,0,0,0,eta),'HH:MM:SS');
set(config.guihandles.text_eta,'String',eta);

end