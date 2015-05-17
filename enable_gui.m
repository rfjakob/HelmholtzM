function [ ] = enable_gui( handles, state )
%ENABLE_GUI Unlock/lock user controls on the GUI.

global global_state;

h=handles;

% Set these controls to <state>
l=[ h.pushbutton_start_360_cycle
    h.edit_rotation_axis
    h.edit_stepsize
    h.edit_steptime
    h.edit_target_flux_density
    h.edit_numberof];

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
set(h.pushbutton_abort,'Enable',opstate)

% Disable/Enable axes rotation. Throws errors if user rotates while cycle
% is running.
rotate3d(global_state.guihandles.axes_3d,state);    


end

