function [ ] = calculate_points( )
%CALCULATE_POINTS Calculate points of the circle to step through.

global config;

n=config.rotation_axis;
if n(1)==0
    s=[1 0 0];
elseif n(2)==0
    s=[0 1 0];
elseif n(3)==0
    s=[0 0 1];
else
    % n is not in any special plane.
    % Assume s(1)=1 and s(2)=1, calculate s(3).
    s=[1 1 -(n(1)+n(2))/n(3)];
    s=s/norm(s); % Unity length
end
s=s(:);
points=[];
for r=0:config.step_size:360
    r=r/360*2*pi;
    R=rotationmat3D(r,n);
    p=R*s;
    points=[points; p.'];
end

config.points_todo=points*config.target_flux_density;

end

