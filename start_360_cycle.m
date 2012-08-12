function [ log ] = start_360_cycle( )
%START360CYCLE Perform a 360 degree magnetic field rotation 

global config;

config.points_done=[];

log.field_set=[];
log.field_act=[];
log.current_set=[];
log.current_act=[];
log.runtime=[];


set_current([0 0 0]);

if norm(config.earth_field)==0
    set_psu_output(0);
    n=measure_field();
    config.earth_field=n;
    set(config.guihandles.text_earthfield,'String',mat2str(n*1e6,3));
    set_psu_output(1);
end

tic
points=config.points_todo;
l=length(points);
fprintf('Stepping through %d points:',l);
for k=1:l
    fprintf(' %d',k);
    if config.abort==1
        fprintf('\nUser abort in start_360_cycle')
        set_flux_density([0 0 0]);
        break
    end
    p=points(k,:);
    current_set=set_flux_density(p);
    pause(config.step_time);
    log.field_set=[log.field_set; p];
    log.field_act=[log.field_act; measure_field()];
    log.current_set=[log.current_set; current_set];
    log.current_act=[log.current_act; measure_current().*sign(current_set)];
    log.runtime=[log.runtime; toc];
    
    plot_log(log);
end
fprintf('\n');

set_flux_density([0 0 0]);
