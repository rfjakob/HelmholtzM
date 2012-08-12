function [ num_nan ] = isnan_config( )
%CONFIG_ISNAN Check if there are any NaN values in the config entered by
%the user

global config;

a=isnan([config.target_flux_density,config.step_time,config.step_size,config.rotation_axis]);
num_nan=sum(a);

end

