function [ s ] = coilcontrol_settings( )
%_coilcontrol_settings Settings for coilcontrol that might need adjustment when
% moving to a different computer

% What COM port number are the power supplies connected to
s.psucom.x=4;
s.psucom.y=5;
s.psucom.z=6;

% What COM port number is the Bartington Mag03DAM connected to
s.mag03com=2;

end

