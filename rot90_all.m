function [ points_todo ] = rot90_all()
%ROT90_CALC Summary of this function goes here
%   Detailed explanation goes here

start_vectors = [1 0 0; 0 1 0; 0 0 1];
start_vectors = [start_vectors; -start_vectors];
rotation_axes = [0 1 0; 0 0 1; 1 0 0];
rotation_axes = [rotation_axes; -rotation_axes];

num_rots = 48;
rads = 2 * pi / num_rots;

points_todo = [];

for r=1:num_rots
    for k=1:6 % 1=x, 2=y, 3=z, 4=-x, 5=-y, 6=-z
        new_points = rot90_one(start_vectors(k,:), rotation_axes(k,:));
        points_todo = [points_todo; new_points];
        R = rotationmat3D(rads, start_vectors(k,:));
        rotation_axes(k,:) = rotation_axes(k,:) * R;
    end
end

end
