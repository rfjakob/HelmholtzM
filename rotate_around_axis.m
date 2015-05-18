function [ points ] = rotate_around_axis(axis, step_size)
% Return [x y z] vectors for a single rotation around "axis" in steps of "step_size"
% degrees. Returned vectors have unity length.

points=[]; % Format: [x y z]

% start_vector ... first vector on the circle
% must be normal to the rotation axis, otherwise arbitrary
if axis(1)==0
    start_vector=[1 0 0];
elseif axis(2)==0
    start_vector=[0 1 0];
elseif axis(3)==0
    start_vector=[0 0 1];
else
    % axis is not in any special plane.
    % Set s(1)=1 and s(2)=1, calculate s(3).
    start_vector=[1 1 -(axis(1)+axis(2))/axis(3)];
    start_vector=start_vector/norm(start_vector); % Unity length
end

start_vector = start_vector(:); % Convert to column vector

rotation_deg = 0;
while rotation_deg < 360
    rotation_rad = rotation_deg / 360 * 2 * pi;
    % R ... rotation matrix
    R = rotationmat3D(rotation_rad, axis);
    new_point = (R * start_vector).' ;
    points = [points; new_point];
    rotation_deg = rotation_deg + step_size;
end

end

