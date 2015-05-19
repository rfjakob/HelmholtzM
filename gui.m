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

% Last Modified by GUIDE v2.5 19-May-2015 01:09:34

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
global global_state;

clear plot_log; % Clear persistent variables

user_config = config();
global_state.dryrun=user_config.dryrun;

global_state.points_done=[];
global_state.abort=0;
global_state.earth_field=[0 0 0];
global_state.mode=OperatingMode.Rotation;
global_state.antiparallel = 0;
global_state.measure_field_during_exp = 0;
connect_instruments();                  % Connect PSUs
calculate_points();                     % Calculate default points to do
rotate3d(global_state.guihandles.axes_3d,'on');  % Enable mouse rotate
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
global global_state;
n=str2double(get(hObject,'String'));
if isnan(n) || n<0 || n>3600
    set(hObject,'BackgroundColor','red');
    n=NaN;
    global_state.step_time=n;
else
    set(hObject,'BackgroundColor','white');
    global_state.step_time=n;
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
global global_state;
n=str2double(get(hObject,'String'));
global_state.step_time=n;

function edit_stepsize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stepsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_stepsize as text
%        str2double(get(hObject,'String')) returns contents of edit_stepsize as a double
global global_state;
n=str2double(get(hObject,'String'));
if isnan(n) || n<0 || n>360
    set(hObject,'BackgroundColor','red');
    global_state.step_size=NaN;
else
    set(hObject,'BackgroundColor','white');
    global_state.step_size=n;
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
global global_state;
n=str2double(get(hObject,'String'));
global_state.step_size=n;

% --- Executes on button press in checkbox_antiparallel.
function checkbox_antiparallel_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_antiparallel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global global_state;
n=get(hObject,'Value');
global_state.antiparallel = n;
calculate_points();

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
global global_state;
global_state.guihandles.axes_3d=hObject;

function edit_rotation_axis_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rotation_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rotation_axis as text
%        str2double(get(hObject,'String')) returns contents of edit_rotation_axis as a double
global global_state;
global_state.rotation_axis = validate_axis(hObject);
calculate_points();

% --- Executes during object creation, after setting all properties.
function edit_rotation_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rotation_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'BackgroundColor','white');
global global_state;
global_state.rotation_axis = validate_axis(hObject);


function edit_target_flux_density_Callback(hObject, eventdata, handles)
% hObject    handle to edit_target_flux_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_target_flux_density as text
%        str2double(get(hObject,'String')) returns contents of edit_target_flux_density as a double
global global_state;
global_state.target_flux_density=validate_scalar(hObject)*1e-6; % uT
calculate_points();
    

% --- Executes during object creation, after setting all properties.
function edit_target_flux_density_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_target_flux_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'BackgroundColor','white');
global global_state;
global_state.target_flux_density=validate_scalar(hObject)*1e-6; % uT


% --- Executes on button press in pushbutton_start_360_cycle.
function pushbutton_start_360_cycle_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start_360_cycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global global_state
% if norm(global_state.earth_field)==0 && global_state.dryrun==0
%    disp('You have to compensate earth field first!')
%    return
%end
global log
enable_gui(handles,'off');
log=start_360_cycle();
enable_gui(handles,'on');
global_state.abort=0;


% --- Executes on button press in pushbutton_abort.
function pushbutton_abort_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_abort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global global_state;
global_state.abort=1;


% --- Executes during object creation, after setting all properties.
function text_earthfield_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_earthfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

global global_state;
global_state.guihandles.text_earthfield=hObject;



function edit_numberof_Callback(hObject, eventdata, handles)
% hObject    handle to edit_numberof (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_numberof as text
%        str2double(get(hObject,'String')) returns contents of edit_numberof as a double
global global_state;
global_state.number_of_cycles = validate_uint(hObject);
calculate_points();

% --- Executes during object creation, after setting all properties.
function edit_numberof_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_numberof (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'BackgroundColor','white');
global global_state;
global_state.number_of_cycles = validate_uint(hObject);

% --- Executes when selected object is changed in uipanel7.
function uipanel7_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel7 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
global global_state;
h=handles;
s=get(eventdata.NewValue,'Tag');
invisible_in_static = [h.edit_stepsize; h.edit_steptime; h.text_steptime; h.text_stepsize];
only_visible_in_custom = h.edit_custom;
invisible_in_nulling = [h.edit_target_flux_density; h.text_target_flux];
if strcmp(s,'radiobutton_rotfld')
    global_state.mode=OperatingMode.Rotation;    
    set(invisible_in_static, 'Visible','on');
    set(only_visible_in_custom, 'Visible','off');
    set(invisible_in_nulling, 'Visible','on');
    set(h.text_axis, 'String', 'Rotation axis [x y z]');
    set(h.text_numberof, 'String', 'Number of cycles');
    set(h.edit_steptime,'String', global_state.step_time);
elseif strcmp(s,'radiobutton_static')
    global_state.mode=OperatingMode.Static;
    set(invisible_in_static, 'Visible','off');
    set(only_visible_in_custom, 'Visible','off');
    set(invisible_in_nulling, 'Visible','on');
    set(h.edit_steptime,'String','1');
    global_state.step_time = 1;
    set(h.text_axis, 'String', 'Direction [x y z]');
    set(h.text_numberof, 'String', 'Duration (s)');
elseif strcmp(s, 'radiobutton_nulling')
    global_state.mode=OperatingMode.Nulling;
    set(invisible_in_static, 'Visible','off');
    set(invisible_in_nulling, 'Visible','off');
    set(only_visible_in_custom, 'Visible','off');
    set(h.edit_steptime,'String','1');
    global_state.step_time = 1;
    set(h.text_axis, 'String', 'Earth field [x y z] in uT');
    set(h.text_numberof, 'String', 'Duration (s)');
elseif strcmp(s, 'radiobutton_custom')
    global_state.mode=OperatingMode.Custom;
    set(only_visible_in_custom, 'Visible','on');
else
    error('UNKNOWN MODE');
end
calculate_points();


% --- Executes during object creation, after setting all properties.
function text_eta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_eta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global global_state;
global_state.guihandles.text_eta=hObject;


% --- Executes during object creation, after setting all properties.
function axes_2d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_2d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_2d
global global_state;
global_state.guihandles.axes_2d=hObject;


% --- Executes on button press in pushbutton_recompensate.
function pushbutton_recompensate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_recompensate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global global_state;
enable_gui(handles,'off');
drawnow
set_psu_output([1 2 3],0);
n=measure_field();
set(handles.text_earthfield,'String',mat2str(n*1e6,3));
set(handles.text_earthfield,'BackgroundColor',[ 0.941176470588235   0.941176470588235   0.941176470588235]);
drawnow
global_state.earth_field=n;
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
global global_state
global_state.measure_field_during_exp=v;


% --- Executes during object creation, after setting all properties.
function checkbox_measure_field_during_exp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkbox_measure_field_during_exp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
checkbox_measure_field_during_exp_Callback(hObject, eventdata, handles)
x

% --- Executes during object creation, after setting all properties.
function axes_x_CreateFcn(hObject, eventdata, handles)
global global_state;
global_state.guihandles.axes_x=hObject;


% --- Executes during object creation, after setting all properties.
function axes_y_CreateFcn(hObject, eventdata, handles)
global global_state;
global_state.guihandles.axes_y=hObject;


% --- Executes during object creation, after setting all properties.
function axes_z_CreateFcn(hObject, eventdata, handles)
global global_state;
global_state.guihandles.axes_z=hObject;


% --- Executes during object creation, after setting all properties.
function axes_legend_CreateFcn(hObject, eventdata, handles)
global global_state;
global_state.guihandles.axes_legend=hObject;


function axes_x2_CreateFcn(hObject, eventdata, handles)
global global_state;
global_state.guihandles.axes_x2=hObject;


function axes_y2_CreateFcn(hObject, eventdata, handles)
global global_state;
global_state.guihandles.axes_y2=hObject;


function axes_z2_CreateFcn(hObject, eventdata, handles)
global global_state;
global_state.guihandles.axes_z2=hObject;



function edit_custom_Callback(hObject, eventdata, handles)
% hObject    handle to edit_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global global_state;
string_cell_array = get(hObject,'String');
string_plain = [];
for k = 1:length(string_cell_array)
    string_plain = [ string_plain sprintf('\n%s', string_cell_array{k}) ];
end
global_state.custom_mode_string = string_plain;
calculate_points();

% --- Executes during object creation, after setting all properties.
function edit_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global global_state;
string_cell_array = get(hObject,'String');
string_plain = [];
for k = 1:length(string_cell_array)
    string_plain = [ string_plain sprintf('\n%s', string_cell_array{k}) ];
end
global_state.custom_mode_string = string_plain;
