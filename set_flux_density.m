function [ I ] = set_flux_density( targetB )
%SET_FLUX_DENSITY Make the specified flux density happen, that is, set the
%output currents so we achieve it. Takes the earth field into account.

global config;

setB=targetB-config.earth_field;
I=setB./tesla_per_amp();
%disp(I*1000)
set_current(I);

end
