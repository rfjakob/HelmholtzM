function [ b_coilcoords ] = measure_field( )
%measure_field Measure the current field flux density B using bartington mag03dam

	global global_state;
	if global_state.dryrun~=0
		b_coilcoords=[0 0 0]*1e-6;
		return
	end

	for a=[1 2 3]
		r=calllib('M201_SP','EX_SetPolledModeChan',a-1, 0);
		if r==0
            error('Could not read from Mag-03DAM: EX_SetPolledModeChan failed');
        end
        
		% http://www.mathworks.de/help/techdoc/matlab_external/f42650.html#f50691
		x = 15;
		xp = libpointer('doublePtr',x);
		r=calllib('M201_SP','EX_GetOneConversion',xp);
        if r==0
            error('Could not read from Mag-03DAM: EX_GetOneConversion failed');
        end
		b(a)=xp.Value;
    end
    
    % Values are 0.1uT
    b=b*0.1e-6;
    
    % Coordinate system of coils and of magnetometer are not the same.
    b_coilcoords(1)=b(1);
    b_coilcoords(2)=b(3);
    b_coilcoords(3)=-b(2);
	
end

