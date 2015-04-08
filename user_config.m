function [ s ] = user_config( )
%_coilcontrol_settings Settings for coilcontrol that might need adjustment when
% moving to a different computer

s.psucom.x=7; % COM port number
s.psuout.x=1; % Output channel (for dual output PSUs)

s.psucom.y=7;
s.psuout.y=2;

s.psucom.z=6;
s.psuout.z=1;

% What COM port number is the Bartington Mag03DAM connected to
s.mag03com=2;

% COM port of the Arduino
s.arduino = 8;

% flux density in the coil center (tesla)
% per amp of current in the coils
s.tesla_per_amp =  [253 250 250] * 1e-6 * 2;
%                                         ^ Spec is for one strand of bifilar wire
%                                    ^ uT
%                    ^   ^   ^ Ferronato spec

end
