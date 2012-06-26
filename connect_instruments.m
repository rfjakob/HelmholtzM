function [ ] = connect_instruments( )
%CONNECT_INSTRUMENTS Open the handles to the instruments (power supply, magnetometer)

    global config;

    config.instruments.psux=-1;
    config.instruments.psuy=-1;
    config.instruments.psuz=-1;

end

