function [ actual_expected_field, would_be_field ] = points_to_expected_field( points )
%POINT_TO_EXPECTED_FIELD Convert from [x y z antiparallel] format to actual
%expected field. That is, earth field when antiparallel, xyz field when
%normal.

global config
ef=config.earth_field;
ap=points(:,4);
xyz=points(:,1:3);
nap = ~ap;
actual_expected_field=xyz.*[nap nap nap]+repmat(ef,size(ap,1),1).*[ap ap ap]; % When ap==1 we get only the earth field
would_be_field=xyz; % Field that would occour if antiparallel was off
would_be_field(ap==0,:)=NaN; % If antiparallel is actually off, we set to NaN

end

