function [ ] = calculate_points( )
%CALCULATE_POINTS Calculate the points to step through.

global global_state;

points_todo=[]; % Format: [x y z antiparallelx antiparallely antiparallelz], x y z in Tesla, antiparallelx, antiparallely, antiparallelz 0 or 1

if global_state.mode == OperatingMode.Rotation
    points_todo = rotate_around_axis(global_state.rotation_axis, global_state.step_size);
    % Scale to requested flux density
    points_todo = points_todo * global_state.target_flux_density;
    % pad with antiparallel zeros
    points_todo(:,4:6) = 0;
elseif global_state.mode == OperatingMode.Static
	% In static mode, the "rotation_axis" is used as the field vector
    xyz = global_state.rotation_axis;
    % Scale to wanted flux density
    flux =  global_state.target_flux_density;
    points_todo = xyz / norm(xyz) * flux;

    % If field is on a principal axis, set two others antiparallel
    if xyz(1) == 0 && xyz(2) == 0
        % On Z axis
        points_todo(1) = flux;
        points_todo(2) = flux;

        points_todo(4) = 1;
        points_todo(5) = 1;
        points_todo(6) = 0;
    elseif xyz(1) == 0 && xyz(3) == 0
        % On Y axis
        points_todo(1) = flux;
        points_todo(3) = flux;

        points_todo(4) = 1;
        points_todo(5) = 0;
        points_todo(6) = 1;
    elseif xyz(2) == 0 && xyz(3) == 0
        % On X axis
        points_todo(2) = flux;
        points_todo(3) = flux;

        points_todo(4) = 0;
        points_todo(5) = 1;
        points_todo(6) = 1;
    else
        % Not on a principal axis.
        points_todo(4) = 0;
        points_todo(5) = 0;
        points_todo(6) = 0;
    end
elseif global_state.mode == OperatingMode.Nulling
    points_todo = -global_state.rotation_axis / 1e6;
    points_todo(4:6) = 0;
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
elseif global_state.mode == OperatingMode.Rot90
    points_todo = rot90_all();
    % No coils are run antiparallel
    points_todo(:,4) = 0;
    points_todo(:,5) = 0;
    points_todo(:,6) = 0;
    % Scale to requested flux density
    points_todo = points_todo * global_state.target_flux_density;
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

