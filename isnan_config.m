function [ num_nan ] = isnan_config( )
%CONFIG_ISNAN Check if there are any NaN values in the config entered by
%the user

global global_state;

a=isnan([global_state.target_flux_density,global_state.step_time,global_state.step_size,global_state.rotation_axis]);
num_nan=sum(a);

end

