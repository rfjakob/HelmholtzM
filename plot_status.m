function [ ] = plot_status( )
%PLOT_STATUS Plot points to go and points done to the 3d axes plot

global config;

ax=config.guihandles.axes_3d;

path(path, 'oaxes')

ef=config.earth_field;
pt=config.points_todo;
pd=config.points_done;
if isempty(pd)
    plot3(ef(1),ef(2),ef(3),'og',pt(:,1),pt(:,2),pt(:,3),'ob');
else
    plot3(ef(1),ef(2),ef(3),'og',pt(:,1),pt(:,2),pt(:,3),'ob',pd(:,1),pd(:,2),pd(:,3),'xr')
end
set(ax,'XColor','blue','YColor','green', 'ZColor','red')
oaxes([0 0 0])
set(ax, 'CameraViewAngle',7)
axis vis3d

end

