function [ ] = enable_gui( handles, state )
%ENABLE_GUI Unlock/lock user controls on the GUI.

global config;

h=handles;

% Set these controls to <state>
l=[h.pushbutton_remeasure
    h.pushbutton_start_360_cycle
    h.edit_rotation_axis
    h.edit_second_axis
    h.edit_third_axis
    h.edit_stepsize
    h.edit_steptime
    h.edit_target_flux_density
    h.edit_guardbefore
    h.edit_guardafter
    h.radiobutton_rotfld
    h.radiobutton_onofffld
    h.edit_numberof
    h.checkbox_secondaxis
    h.checkbox_thirdaxis];

for k=l
    set(k,'Enable',state);
end

% Step size stays disabled if mode is on-off or on-anti
if config.mode~=0
    set(handles.edit_stepsize,'Enable','off');
end
% Antiparallel cycles are disabled in on-anti mode
if config.mode==2
    set(h.edit_guardbefore,'Enable','off');
    set(h.edit_guardafter,'Enable','off');
end
% Disabled axes stay disabled
if config.axes_enabled(2)==0
    set(handles.edit_second_axis,'Enable','off');
end
if config.axes_enabled(3)==0
    set(handles.edit_third_axis,'Enable','off');
end

% Abort button gets opposite state
if strcmp(state,'off')
    opstate='on';
elseif strcmp(state,'on')
    opstate='off';
else
    error('BUG!')
end
set(h.pushbutton_abort,'Enable',opstate)

% Disable/Enable axes rotation. Throws errors if user rotates while cycle
% is running.
rotate3d(config.guihandles.axes_3d,state);    


end

