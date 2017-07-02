function [ points_todo ] = rot90_one( start_vector, rotation_axis )
%ROT90_ONCE Summary of this function goes here
%   Detailed explanation goes here

global global_state;

ramp_steps = round(3.2/global_state.step_time);
rot_steps = round(2/global_state.step_time);

points_todo = [];

for k = 1:ramp_steps
    points_todo = [points_todo; start_vector*(k/ramp_steps)];
end

step_rad = pi/2/rot_steps;
for k = 1:rot_steps
    R = rotationmat3D(step_rad*k, rotation_axis);
    points_todo = [points_todo; start_vector * R];
end

last_point = points_todo(end,:);
for k = 1:ramp_steps
    points_todo = [points_todo; last_point*(ramp_steps-k)/ramp_steps];
end

size(points_todo)

end

