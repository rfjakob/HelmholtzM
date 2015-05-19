%% Roller Coaster
custom_step_size = 6;
custom_step_time = 2;

meta_step_size = 15
meta_axes = [
0 0 1
0 1 0
1 0 0
];

custom_rotation_axes = [];
for k = 1:length(meta_axes(:,1))
    part = rotate_around_axis(meta_axes(k,:), meta_step_size);
    n = ceil( 180 / meta_step_size);
    part = part(1:n,:);
    custom_rotation_axes = [custom_rotation_axes; part];
end