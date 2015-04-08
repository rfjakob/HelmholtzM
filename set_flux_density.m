function [ I ] = set_flux_density( targetB )
% SET_FLUX_DENSITY Make the specified flux density happen, that is, set the
% output currents so we achieve it. Takes the earth field into account.
% I and targetB are x,y,z vectors.

global global_state;

s = user_config();

setB = targetB - global_state.earth_field;
I = setB ./ s.tesla_per_amp;

% For the 1300mm coils, current control does not work.
% The current fluctuates wildly sometimes, which is an indication that
% the PSU cannot handle the high inductance.
% Therefore, we use voltage control.
%
%set_current(I);
R = s.resistance_ohms;
V = R .* I;
set_voltage(V);

end
