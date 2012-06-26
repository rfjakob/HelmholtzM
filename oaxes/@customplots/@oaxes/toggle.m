function toggle(OA)
% Toggle the state of the oaxes' listeners

% $$FileInfo
% $Filename: toggle.m
% $Path: $toolboxroot/@customplots/@oaxes
% $Product Name: oaxes
% $Product Release: 2.3
% $Revision: 1.0.3
% $Toolbox Name: Custom Plots Toolbox
% $$
%
% Copyright (c) 2010-2011 John Barber.
%

%%

enabled = OA.ListenersEnabled;

if strcmp(enabled,'off')
    OA.ListenersEnabled = 'on';
    disp('oaxes listeners are now enabled')
else
    OA.ListenersEnabled = 'off';
    disp('oaxes is now frozen')
end