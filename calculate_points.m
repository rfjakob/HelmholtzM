function [ ] = calculate_points( )
%CALCULATE_POINTS Calculate the points to step through.

global global_state;

points_todo=[]; % Format: [x y z antiparallel], x y z in Tesla, antiparallel 0 or 1

if global_state.mode == OperatingMode.Rotation
    points_todo = rotate_around_axis(global_state.rotation_axis, global_state.step_size);
elseif global_state.mode == OperatingMode.Static
    points_todo = global_state.rotation_axis;
    points_todo = points_todo / norm(points_todo);
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
end

% Scale to requested flux density
points_todo = points_todo * global_state.target_flux_density;

% Repeat "number_of_cycles" times
points_todo = repmat(points_todo, global_state.number_of_cycles, 1);

% Add antiparallel flags
points_todo(:,4) = global_state.antiparallel;
global_state.points_todo = points_todo;

plot_status();

end

