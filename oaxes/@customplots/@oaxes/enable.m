function enable(OA)
% Enable listeners attached to parent axes and oaxes properties to allow
% the oaxes to update in response to changes in these properties.

% $$FileInfo
% $Filename: enable.m
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

OA.ListenersEnabled = 'on';