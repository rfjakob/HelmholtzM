function [ output_args ] = set_voltage( V, antiparallel )
%SET_VOLTAGE Make the power supplies output the specified voltage
% V=[ Vx Vy Vz ]

global global_state;

% The relays reverse the polarity as needed
arduino_set_relays(V, antiparallel);

% The PSU voltage is always positive
V = abs(V);

for k=[1 2 3]
    fprintf(global_state.instruments.psu(k), 'V%d %d\n', [global_state.instruments.psuout(k); V(k)]);
end

end % function
