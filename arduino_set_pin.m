function [ ] = arduino_set_pin( pin_no, value )
% Set arduino pin to value (0 or 1) and check success

global global_state;

fprintf(global_state.instruments.arduino, '%s\r\n', sprintf('P%d %d', [pin_no; value]));
r = fgetl(global_state.instruments.arduino);
if ~strcmp(sprintf('OK\r'), r)
    error('Got error from arduino: %s', r);
end

end

