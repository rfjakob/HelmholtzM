function [ ] = set_psu_output( axes, state )
%SET_PSU_OUTPUT Set OUTPUT ON (state==1) or OFF (state==0) on one
% supply(-ies) set in axes
% Used for example before switching relays to prevent arcing.

global global_state
persistent last_state

if isempty(last_state)
    last_state=[-1 -1 -1];
end

for a=axes
	if global_state.dryrun==0 && last_state(a)~=state
        f = sprintf('OP%d %d', global_state.instruments.psuout(a), state);
        fprintf(global_state.instruments.psu(a),f);
		last_state(a)=state;
	end
end
	
end