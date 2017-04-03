function [ ] = calculate_points( )
%CALCULATE_POINTS Calculate the points to step through.

global global_state;

points_todo=[]; % Format: [x y z antiparallelx antiparallely antiparallelz], x y z in Tesla, antiparallelx, antiparallely, antiparallelz 0 or 1

if global_state.mode == OperatingMode.Rotation
    points_todo = rotate_around_axis(global_state.rotation_axis, global_state.step_size);
    % Scale to requested flux density
    points_todo = points_todo * global_state.target_flux_density;
elseif global_state.mode == OperatingMode.Static
	on_principal_axis = 1
    % If field is on a principal axis, set two others antiparallel
    if points_todo(1) == 0 && points_todo(2) == 0
        points_todo(1,4) = 1;
        points_todo(1,5) = 1;
        points_todo(1,6) = 0;
    elseif points_todo(1) == 0 && points_todo(3) == 0
        points_todo(1,4) = 1;
        points_todo(1,5) = 0;
        points_todo(1,6) = 1;
    elseif points_todo(2) == 0 && points_todo(3) == 0
        points_todo(1,4) = 0;
        points_todo(1,5) = 1;
        points_todo(1,6) = 1;
    else
        points_todo(1,4) = 0;
        points_todo(1,5) = 0;
        points_todo(1,6) = 0;
    	on_principal_axis = 0;
    end

    if on_principal_axis
    	% energize all coils
    	points_todo(1,1:3) = global_state.target_flux_density;
	else
		a = global_state.rotation_axis / norm(global_state.rotation_axis);
	    points_todo(1,1:3) =  a * global_state.target_flux_density;
    end
elseif global_state.mode == OperatingMode.Nulling
    points_todo = -global_state.rotation_axis / 1e6;
elseif global_state.mode == OperatingMode.Custom
    try
        eval(global_state.custom_mode_string);
        for k=1:length(custom_rotation_axes(:,1))
            points_todo = [points_todo; rotate_around_axis(custom_rotation_axes(k,:), custom_step_size)];
        end
        global_state.step_time = custom_step_time;
    catch e
        errordlg(e.message);
    end
    % Scale to requested flux density
    points_todo = points_todo * global_state.target_flux_density;
	% No coils are run antiparallel
    points_todo(:,4) = 0;
    points_todo(:,5) = 0;
    points_todo(:,6) = 0;
end

% Repeat "number_of_cycles" times
points_todo = repmat(points_todo, global_state.number_of_cycles, 1);

% Add antiparallel flags
if  global_state.antiparallel==1
    points_todo(:,4) = 1;
    points_todo(:,5) = 1;
    points_todo(:,6) = 1;
end

global_state.points_todo = points_todo;

plot_status();

end

