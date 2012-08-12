function [ ] = color_startbutton(handles)
%COLOR_STARTBUTTON Color the startbutton red or white depending on whether
%the config contains errors

p=handles.pushbutton_start_360_cycle;

if isnan_config()>0
    set(p,'BackgroundColor','red');
    set(p,'Enable','off');
else
    set(p,'BackgroundColor',[0.7020    0.7020    0.7020]);
    set(p,'Enable','on');
end

end

