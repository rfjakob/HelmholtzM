function [ actual_expected_field, would_be_field ] = points_to_expected_field( points )
%POINT_TO_EXPECTED_FIELD Convert from [x y z antiparallel] format to actual
%expected field. That is, earth field when antiparallel, xyz field when
%normal.

% Antiparallel flag
ap=[points(:,4) points(:,5) points(:,6)];
% XYZ target field strength
xyz=points(:,1:3);

% Field that would be generated if antiparallel is off
would_be_field = xyz;

% Negated antiparallel flag. If the coil is running antiparallel, we want
% a zero.
nap = ~ap;

% Field that we expect, taking the antiparallel flags into account
actual_expected_field = xyz .* nap;
          
end

