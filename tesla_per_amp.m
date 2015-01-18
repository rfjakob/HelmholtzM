function [ out ] = tesla_per_amp( )
%TESLA_PER_AMP Return tesla per amp specification for all coils ([x y z])

out=          [253 250 250] * 1e-6 * 2;
%                                    ^ Spec is for one strand of bifilar wire
%                              ^ uT
%               ^   ^   ^ Ferronato spec
%

end

