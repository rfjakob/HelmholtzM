function [ ] = enable_gui( handles, state )
%ENABLE_GUI Summary of this function goes here
%   Detailed explanation goes here

% Set these controls to <state>
l=[handles.pushbutton_remeasure
    handles. pushbutton_start_360_cycle
    handles.edit_rotation_axis
    handles.edit_stepsize
    handles.edit_steptime
    handles.edit_target_flux_density
    handles.checkbox_antiparallel];

for k=l
    set(k,'Enable',state);
end

% Abort button gets opposite state
if strcmp(state,'off')
    opstate='on';
elseif strcmp(state,'on')
    opstate='off';
else
    error('BUG!')
end
set(handles.pushbutton_abort,'Enable',opstate)

% Disable/Enable axes rotation. Throws errors if user rotates while cycle
% is running.
global config;
rotate3d(config.guihandles.axes_3d,state);    


end

