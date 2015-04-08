function [ s ] = config()
%CONFIG Settings for HelmholtzM that might need adjustment when
% moving to a different computer

% X coils
s.psucom.x=7; % COM port number
s.psuout.x=1; % Output channel (for dual output PSUs)

% Y coils
s.psucom.y=7;
s.psuout.y=2;

% Z coils
s.psucom.z=6;
s.psuout.z=1;

% What COM port number is the Bartington Mag03DAM connected to
s.mag03com=2;

% COM port of the Arduino
s.arduino = 8;

% flux density in the coil center (tesla) per amp of current in the coils
s.tesla_per_amp =  [253 250 250] * 1e-6 * 2;
%                                         ^ Spec is for one strand of bifilar wire
%                                    ^ uT
%                    ^   ^   ^ Ferronato spec

% Electrical resistance of the coils (Ohms, x y z)
s.resistance_ohms = [ 1 1 1 ];

% PSU-side current limit - protection in the event of misconfiguration
s.current_limit = 5;

end
