function [ log ] = start_360_cycle()
%START360CYCLE Perform a 360 degree magnetic field rotation 

global global_state;

global_state.points_done=[];

log.field_expected=[];
log.field_measured=[];
log.field_set_antiparallel=[];
log.current_expected=[];
log.current_measured=[];
log.earth_field=global_state.earth_field;
log.swtime=[];
log.antipar=[];

points=global_state.points_todo;
l=length(points);
if(global_state.mode==0)
    step_time=global_state.cycle_time*global_state.step_size/360;
else
    step_time=global_state.cycle_time/2;
end

s = config();

maxcurr = (max(points(:,1:3))-global_state.earth_field) / s.tesla_per_amp;
maxcurr = max(maxcurr);
if maxcurr < 0.5
    set_psu_range(1);
else
    set_psu_range(2);
end

set_flux_density([0 0 0], 0);
set_psu_output([1 2 3], 1);

fprintf('Stepping through %d points:',l);
t0=clock;
for k=1:l
    fprintf(' %d',k);
    if global_state.abort==1
        fprintf('\nUser abort in start_360_cycle')
        break
    end
    tsw=clock;    
    
    current_expected=set_flux_density(points(k,1:3), points(k,4));
    [field_expected, field_set_antiparallel]=points_to_expected_field(points(k,:));
    
    rt1=etime(clock,t0);
    log.antipar(end+1,:)=[rt1  points(k,4)];
    log.swtime(end+1,:)=[rt1 etime(clock,tsw)];
    log.field_expected(end+1,:)=[rt1 field_expected];
    log.field_set_antiparallel(end+1,:)=[rt1 field_set_antiparallel];
    log.current_expected(end+1,:)=[rt1 current_expected];
    
    if global_state.measure_field_during_exp==1
        %tic
        f=measure_field();
        %toc 1.5 seconds
        log.field_measured(end+1,:)=[etime(clock,t0) f];
    else
        log.field_measured=[NaN NaN NaN NaN];
    end
    
    c=measure_current().*sign(current_expected);
    log.current_measured(end+1,:)=[etime(clock,t0) c];
    
    plot_log(log);
    
    if step_time>0
        t2=t0;
        t2(6)=t2(6)+k*step_time;
        
        % Use the waiting time to measure stuff
        % Does this really add value?
        %while etime(t2,clock)>0.1
        %    pause(0.05)
        %    c=measure_current().*sign(current_expected);
        %    log.current_measured(end+1,:)=[etime(clock,t0) c];
        %    
        %    diff=max(abs(c-current_expected));
        %    if diff<0.001 || diff/max(abs(current_expected))>0.05
        %        break
        %    end
        %end
        
        p=etime(t2,clock);
        if p<0
            fprintf(' warning: %d seconds behind schedule\n',-p)
        else
            pause(p);
        end
    end

end
fprintf('\n');

set_psu_output([1 2 3], 0);
