function [ ] = enable_gui( handles, state )
%ENABLE_GUI Unlock/lock user controls on the GUI.

global config;

% Set these controls to <state>
l=[handles.pushbutton_remeasure
    handles. pushbutton_start_360_cycle
    handles.edit_rotation_axis
    handles.edit_stepsize
    handles.edit_steptime
    handles.edit_target_flux_density
    handles.checkbox_antiparallel
    handles.radiobutton_rotfld
    handles.radiobutton_onofffld
    handles.edit_numberof];

for k=l
    set(k,'Enable',state);
end

% Step size stays disabled if mode is on-off switching
if config.mode==1
    set(handles.edit_stepsize,'Enable','off');
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

