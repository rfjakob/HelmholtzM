function [ ] = set_psu_output( axes, state )
%SET_PSU_OUTPUT Set OUTPUT ON (state==1) or OFF (state==0) on one
% supply(-ies) set in axes
% Used for example before switching relays to prevent arcing.

global config
persistent last_state

if isempty(last_state)
    last_state=[-1 -1 -1];
end

if state == 0
    f='OP1 0';
elseif state == 1
    f='OP1 1';
else
    state
    error('BUG: Invalid state')
end

for a=axes
	if config.dryrun==0 && last_state(a)~=state
        fprintf(config.instruments.psu(a),f);
		last_state(a)=state;
	end
end
	
end