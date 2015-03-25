function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 03-Sep-2012 13:50:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT\

% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Coilcontrol: Startup
global config;

config.dryrun=0;

config.points_done=[];
config.abort=0;
config.earth_field=[0 0 0];
config.mode=0;
config.axes_enabled=[1 1 1];
connect_instruments();                  % Connect PSUs
calculate_points();                     % Calculate default points to do
rotate3d(config.guihandles.axes_3d,'on');  % Enable mouse rotate
evalin('base','global log') % Make the log variable visible in the base workspace
disp('coilcontrol ready')

% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function edit_steptime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_steptime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_steptime as text
%        str2double(get(hObject,'String')) returns contents of edit_steptime as a double
global config;
n=str2double(get(hObject,'String'));
if isnan(n) || n<0 || n>3600
    set(hObject,'BackgroundColor','red');
    n=NaN;
    config.cycle_time=n;
else
    set(hObject,'BackgroundColor','white');
    config.cycle_time=n;
    calculate_points();
    plot_status();
end



% --- Executes during object creation, after setting all properties.
function edit_steptime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_steptime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'BackgroundColor','white');
global config;
n=str2double(get(hObject,'String'));
config.cycle_time=n;

function edit_stepsize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stepsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_stepsize as text
%        str2double(get(hObject,'String')) returns contents of edit_stepsize as a double
global config;
n=str2double(get(hObject,'String'));
if isnan(n) || n<0 || n>360
    set(hObject,'BackgroundColor','red');
    config.step_size=NaN;
else
    set(hObject,'BackgroundColor','white');
    config.step_size=n;
    calculate_points();
    plot_status();
end

% --- Executes during object creation, after setting all properties.
function edit_stepsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_stepsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'BackgroundColor','white');
global config;
n=str2double(get(hObject,'String'));
config.step_size=n;

% --- Executes on button press in checkbox_antiparallel.
function checkbox_antiparallel_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_antiparallel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_antiparallel

n=get(hObject,'Value');
set_antiparallel(n);

% --- Executes on button press in pushbutton_remeasure.
function pushbutton_remeasure_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_remeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n=measure_field();
set(handles.text20,'String',mat2str(n*1e6,3));

% --- Executes on button press in pushbutton_debug.
function pushbutton_debug_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_debug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('debug')


% --- Executes during object creation, after setting all properties.
function axes_3d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_3d
global config;
config.guihandles.axes_3d=hObject;

function edit_rotation_axis_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rotation_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rotation_axis as text
%        str2double(get(hObject,'String')) returns contents of edit_rotation_axis as a double
global config;
config.rotation_axes(1,:)=validate_axis(hObject);
calculate_points();

% --- Executes during object creation, after setting all properties.
function edit_rotation_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rotation_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'BackgroundColor','white');
global config;
config.rotation_axes(1,:)=validate_axis(hObject);


function edit_target_flux_density_Callback(hObject, eventdata, handles)
% hObject    handle to edit_target_flux_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_target_flux_density as text
%        str2double(get(hObject,'String')) returns contents of edit_target_flux_density as a double
global config;
config.target_flux_density=validate_scalar(hObject)*1e-6; % uT
calculate_points();
    

% --- Executes during object creation, after setting all properties.
function edit_target_flux_density_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_target_flux_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'BackgroundColor','white');
global config;
config.target_flux_density=validate_scalar(hObject)*1e-6; % uT


% --- Executes on button press in pushbutton_start_360_cycle.
function pushbutton_start_360_cycle_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start_360_cycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global config
% if norm(config.earth_field)==0 && config.dryrun==0
%    disp('You have to compensate earth field first!')
%    return
%end
global log
enable_gui(handles,'off');
log=start_360_cycle();
enable_gui(handles,'on');
config.abort=0;


% --- Executes on button press in pushbutton_abort.
function pushbutton_abort_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_abort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global config;
config.abort=1;


% --- Executes during object creation, after setting all properties.
function text_earthfield_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_earthfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

global config;
config.guihandles.text_earthfield=hObject;



function edit_numberof_Callback(hObject, eventdata, handles)
% hObject    handle to edit_numberof (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_numberof as text
%        str2double(get(hObject,'String')) returns contents of edit_numberof as a double
global config;
config.number_of_cycles(2)=validate_uint(hObject);
calculate_points();

% --- Executes during object creation, after setting all properties.
function edit_numberof_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_numberof (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'BackgroundColor','white');
global config;
config.number_of_cycles(2)=validate_uint(hObject);

% --- Executes when selected object is changed in uipanel7.
function uipanel7_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel7 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
global config;
h=handles;
s=get(eventdata.NewValue,'Tag');
if strcmp(s,'radiobutton_onofffld')
    config.mode=1;
    set(h.edit_stepsize,'Enable','off');
    set(h.edit_guardbefore,'Enable','on');
    set(h.edit_guardafter,'Enable','on');
elseif strcmp(s,'radiobutton_onantifld')
    config.mode=2;
    set(h.edit_stepsize,'Enable','off');
    set(h.edit_guardbefore,'Enable','off');
    set(h.edit_guardafter,'Enable','off');
else
    config.mode=0;
    set(h.edit_stepsize,'Enable','on');
    set(h.edit_guardbefore,'Enable','on');
    set(h.edit_guardafter,'Enable','on');
end
calculate_points();


% --- Executes during object creation, after setting all properties.
function text_eta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_eta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global config;
config.guihandles.text_eta=hObject;


% --- Executes during object creation, after setting all properties.
function axes_2d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_2d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_2d
global config;
config.guihandles.axes_2d=hObject;



function edit_guardafter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_guardafter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_guardafter as text
%        str2double(get(hObject,'String')) returns contents of edit_guardafter as a double
global config;
config.number_of_cycles(3)=validate_uint(hObject);
calculate_points();

% --- Executes during object creation, after setting all properties.
function edit_guardafter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_guardafter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'BackgroundColor','white');
global config;
config.number_of_cycles(3)=validate_uint(hObject);


function edit_second_axis_Callback(hObject, eventdata, handles)
% hObject    handle to edit_second_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_second_axis as text
%        str2double(get(hObject,'String')) returns contents of edit_second_axis as a double
global config;
config.rotation_axes(2,:)=validate_axis(hObject);
calculate_points();

% --- Executes during object creation, after setting all properties.
function edit_second_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_second_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'BackgroundColor','white');
global config;
config.rotation_axes(2,:)=validate_axis(hObject);


function edit_third_axis_Callback(hObject, eventdata, handles)
% hObject    handle to edit_third_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_third_axis as text
%        str2double(get(hObject,'String')) returns contents of edit_third_axis as a double
global config;
config.rotation_axes(3,:)=validate_axis(hObject);
calculate_points();

% --- Executes during object creation, after setting all properties.
function edit_third_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_third_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'BackgroundColor','white');
global config;
config.rotation_axes(3,:)=validate_axis(hObject);



function edit_guardbefore_Callback(hObject, eventdata, handles)
% hObject    handle to edit_guardbefore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_guardbefore as text
%        str2double(get(hObject,'String')) returns contents of edit_guardbefore as a double
global config;
config.number_of_cycles(1)=validate_uint(hObject);
calculate_points();

% --- Executes during object creation, after setting all properties.
function edit_guardbefore_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_guardbefore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'BackgroundColor','white');
global config;
config.number_of_cycles(1)=validate_uint(hObject);


% --- Executes on button press in checkbox_secondaxis.
function checkbox_secondaxis_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_secondaxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_secondaxis
v=get(hObject,'Value');
set(handles.edit_second_axis,'Enable',bool_to_on_off(v));
global config
config.axes_enabled(2)=v;
calculate_points();


% --- Executes on button press in checkbox_thirdaxis.
function checkbox_thirdaxis_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_thirdaxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_thirdaxis
v=get(hObject,'Value');
set(handles.edit_third_axis,'Enable',bool_to_on_off(v));
global config
config.axes_enabled(3)=v;
calculate_points();


% --- Executes on button press in pushbutton_recompensate.
function pushbutton_recompensate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_recompensate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global config;
enable_gui(handles,'off');
drawnow
set_psu_output([1 2 3],0);
n=measure_field();
set(handles.text_earthfield,'String',mat2str(n*1e6,3));
set(handles.text_earthfield,'BackgroundColor',[ 0.941176470588235   0.941176470588235   0.941176470588235]);
drawnow
config.earth_field=n;
set_flux_density([0 0 0]);
pushbutton_remeasure_Callback([], eventdata, handles);
plot_status();
enable_gui(handles,'on');


% --- Executes on button press in checkbox_measure_field_during_exp.
function checkbox_measure_field_during_exp_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_measure_field_during_exp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_measure_field_during_exp
v=get(hObject,'Value');
global config
config.measure_field_during_exp=v;


% --- Executes during object creation, after setting all properties.
function checkbox_measure_field_during_exp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkbox_measure_field_during_exp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
checkbox_measure_field_during_exp_Callback(hObject, eventdata, handles)
