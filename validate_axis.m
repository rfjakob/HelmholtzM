function [ n ] = validate_axis( hObject )
%VALIDATE_AXIS Summary of this function goes here
%   Detailed explanation goes here

n=str2num(get(hObject,'String'));

l=0;
try
    l=norm(abs(n)*[1;1;1]); % This also checks if dimensions are correct
end

if l==0 || isnan(l) || ~isreal(n)
    set(hObject,'BackgroundColor','red');
    n=NaN;
else
    set(hObject,'BackgroundColor','white');
end

end

