function [ log ] = iterative_nulling( )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

global global_state;

t0=clock;

log.field_expected = [];
log.field_measured = [];
log.field_set_antiparallel=[];
log.current_expected = [NaN NaN NaN NaN];
log.current_measured = [];

set_flux_density([0 0 0], 0);
set_psu_output([1 2 3], 1);

B = [0 0 0];

while 1
    B_rest = measure_field();
   
    et = etime(clock,t0);
    log.field_measured(end+1,:) = [et B_rest];
    log.field_expected(end+1, :) = [et 0 0 0];
    
    B = B - B_rest * 0.1;
    
    norm(B)
    if norm(B) > 100e-6
        errordlg('Excessive current needed for compensation - measurement problem? Aborting for safety.');
        break
    end
    
    current_expected = set_flux_density(B, 0);
    
    c = measure_current().*sign(current_expected);
    log.current_expected(end+1,:)=[etime(clock,t0) current_expected];
    log.current_measured(end+1,:)=[etime(clock,t0) c];

    plot_log(log);
    drawnow;
    
    if global_state.abort==1
        break
    end
end

set_psu_output([1 2 3], 0);

end

