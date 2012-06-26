function [ output_args ] = start_360_cycle( )
%START360CYCLE Summary of this function goes here
%   Detailed explanation goes here

global config;

config.points_done=[];

set_current([0 0 0]);

if norm(config.earth_field)==0
    set_psu_output(0);
    n=measure_field();
    config.earth_field=n;
    set(config.guihandles.text_earthfield,'String',mat2str(n*1e6,3));
    set_psu_output(1);
end

points=config.points_todo;
for k=1:length(points)
    if config.abort==1
        disp('User abort in start_360_cycle')
        set_flux_density([0 0 0]);
        break
    end
    p=points(k,:);
    set_flux_density(p);
    config.points_done=[config.points_done;p];
    plot_status();
    pause(0.5);
end

set_flux_density([0 0 0]);
