function [ ] = arduino_set_relays( V, antiparallel )
% antiparallel ... boolean
% V ... x y z voltages (only the sign matters)

global global_state;

persistent last_state;
if isempty(last_state)
    last_state = [1 1 1 1 1 1];
end

% Relays 1 to 6.
% 1 = X1, 2 = X2, 3 = Y1, 4 = Y2 etc.
new_state = [0 0 0 0 0 0];

if antiparallel == 1
    new_state = [0 1 0 1 0 1];
else
    if V(1) < 0
        new_state(1:2) = 1;
    end
    if V(2) < 0
        new_state(3:4) = 1;
    end
    if V(3) < 0
        new_state(5:6) = 1;
    end
end

if isequal(last_state, new_state) || global_state.dryrun == 1
    % Nothing to do
    return;
end

for n=1:6
    % Pins are numbered from zero
    arduino_set_pin(n-1, new_state(n));
end

last_state = new_state;

end % function

