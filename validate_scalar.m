function [ n ] = validate_scalar( hObject )
%VALIDATE_SCALAR Summary of this function goes here
%   Detailed explanation goes here

n=str2double(get(hObject,'String'));
if n<0 || isnan(n) || ~isreal(n) || ~isscalar(n)
    set(hObject,'BackgroundColor','red');
    n=NaN;
else
    set(hObject,'BackgroundColor','white');
end

end