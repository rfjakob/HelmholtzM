function [ ] = plot_status( )
%PLOT_STATUS Plot points to go and points done to the 3d axes plot

global config;

ax=config.guihandles.axes_3d;
ax2=config.guihandles.axes_2d;

path(path, 'oaxes')

ef=config.earth_field*1e6; % uT
pt=config.points_todo*1e6;
pd=config.points_done*1e6;
if isempty(pd)
    plot3(ax,ef(1),ef(2),ef(3),'og',pt(:,1),pt(:,2),pt(:,3),'ob');
else
    plot3(ax,ef(1),ef(2),ef(3),'og',pt(:,1),pt(:,2),pt(:,3),'ob',pd(:,1),pd(:,2),pd(:,3),'xr')
end

set(ax,'XColor','blue','YColor','green', 'ZColor','red')
oaxes(ax,[0 0 0])
%set(ax, 'CameraViewAngle',7)
%axis(ax,'vis3d')
axis(ax,'equal')

t=(1:size(pt,1))*config.step_time;
t=t.';
stairs(ax2,[t t t],pt);
ylabel(ax2,'uT');
xlabel(ax2,'t (s)');
legend(ax2,'x','y','z');
grid(ax2,'on');

eta=size(pt,1)*config.step_time;
eta=datestr(datenum(0,0,0,0,0,eta),'HH:MM:SS');
set(config.guihandles.text_eta,'String',eta);

end