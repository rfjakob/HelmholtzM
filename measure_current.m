function [ I ] = measure_current( )
%MEASURE_CURRENT Measure the power supply currents using the built-in sensing

global global_state;

if global_state.dryrun==1
    I=[0.001 0.001 0.001];
    return
end

for k=[1 2 3]
    psu = global_state.instruments.psu(k);
    output = global_state.instruments.psuout(k);

    tic
    fprintf(psu, 'I%dO?\n', output);
    reply = fgetl(psu);
    delay_ms = toc * 1000;
    if delay_ms > 100
        fprintf('Slow current measurement: %d ms\n', delay_ms);
    end
    if isempty(reply)
        errordlg('Could not get current');
        error('Could not get current')
    end
    value = sscanf(reply, '%fA');
    I(k) = value;
    %fprintf('current: %d mA\n', value*1000);
end

end % function

