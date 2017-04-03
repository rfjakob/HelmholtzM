function [ actual_expected_field, would_be_field ] = points_to_expected_field( points )
%POINT_TO_EXPECTED_FIELD Convert from [x y z antiparallel] format to actual
%expected field. That is, earth field when antiparallel, xyz field when
%normal.

global global_state
ef=global_state.earth_field;
ap=[points(:,4) points(:,5) points(:,6)];
xyz=points(:,1:3);

would_be_field=xyz; % Field that would occour if antiparallel was off

if ap(1) == ap(2) && ap(1) == ap(3)
    if ap(1)>0 % Case all antiparallel
        nap=0;
        actual_expected_field=xyz.*[nap nap nap]+repmat(ef,size(ap,1),1).*ap; % When ap(i)==1 for i=4,5,6 we get only the earth field
    elseif ap(1)==0 % Case all antiparallel off
        nap=1;
        actual_expected_field=xyz.*[nap nap nap]+repmat(ef,size(ap,1),1).*ap;
        would_be_field(ap(1)==0,:)=NaN; % If antiparallel is actually off, we set to NaN
    else
        warning('ap contains negative values')
    end
else
    if ap(1)==ap(2)&&ap(1)==1
        nap=[0 0 1];
        actual_expected_field=xyz+repmat(ef,size(ap,1),1).*ap;
    elseif ap(1)==ap(3) && ap(1)==1
        nap=[0 1 0];
        actual_expected_field=xyz+repmat(ef,size(ap,1),1).*ap;
    elseif ap(2)==ap(3) && ap(2)==1
        nap=[1 0 0];
        actual_expected_field=xyz+repmat(ef,size(ap,1),1).*ap;
    else
        ap
        warning('What should happen in this case?')
    end
end
          
end

