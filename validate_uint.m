function [ n ] = validate_uint( hObject )
%VALIDATE_UINT Summary of this function goes here
%   Detailed explanation goes here

n=str2double(get(hObject,'String'));
if n<0 || isnan(n) || ~isreal(n) || ~isscalar(n) || rem(n,1)~=0
    set(hObject,'BackgroundColor','red');
    n=NaN;
else
    set(hObject,'BackgroundColor','white');
end

end

