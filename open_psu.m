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
    fprintf(s,'*RST');
    
    fprintf(s,'*IDN?');
    idn=fscanf(s);
    
    v=10;
    i=0;
    fprintf(s,'I1 %d\n',i);
    fprintf(s,'V1 %d\n',v);
end

