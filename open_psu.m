function [ s, idn ] = open_psu( com_number )
%open_psu Opens the serial com_number port and queries *IDN?

    global global_state
    if global_state.dryrun==1
        s=NaN;
        idn=NaN;
        return
    end

    s = serial(sprintf('com%d',com_number));
    fopen(s);

    % Reset the PSU. This also disables the outputs.
    fprintf(s,'*RST');

    % Get model number
    fprintf(s,'*IDN?');
    idn=fscanf(s);

    % Set to zero volts and set current limit
    v = 0;
    conf = config();
    i = conf.current_limit;
    for n=1:2
        fprintf(s,'V%d %d\n', [n; v]);
        fprintf(s,'I%d %d\n', [n; i]);
    end
end

