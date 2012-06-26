function [ ] = set_flux_density( targetB )
%SET_FLUX_DENSITY Make the specified flux density happen, that is, set the
%output currents so we achieve it. Takes the earth field into account.

global config;

tesla_per_amp=[253 250 250] * 1e-6 * 2;
%                                    ^ Spec is for one strand of bifilar wire
%                              ^ µT
%               ^   ^   ^ Ferronato spec
%
setB=targetB-config.earth_field;
I=setB./tesla_per_amp;
set_current(I);

end
