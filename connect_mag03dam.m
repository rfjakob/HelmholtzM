function [ ] = connect_mag03dam( )

	s=config();

    warning off MATLAB:loadlibrary:TypeNotFound
    %unloadlibrary('M201_SP')
    %loadlibrary('M201_SP.dll','M201_SP.h' , 'mfilename', 'M201_SP_mHeader');
	%unloadlibrary('M201_SP')
    [notfound,warnings]=loadlibrary('M201_SP.dll',@M201_SP_mHeader);

	global global_state;
	if global_state.dryrun~=0
		return
	end

	r = calllib('M201_SP','EX_SetCOMport',s.mag03com-1);
	if r==0
        error('Could not initialize Mag-03DAM: EX_SetCOMport failed');
    end
    r = calllib('M201_SP','EX_InitDev');
    if r==0
        error('Could not initialize Mag-03DAM: EX_InitDev failed');
    end

end

