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

% Last Modified by GUIDE v2.5 03-Jun-2012 19:00:18

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
% End initialization code - DO NOT EDIT


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
config.points_done=[];
config.abort=0;
config.earth_field=[0 0 0];
connect_instruments();                  % Connect PSUs
calculate_points();                     % Calculate default points to do
plot_status();                          % Plot points to do
rotate3d(config.guihandles.axes_3d,'on');  % Enable mouse rotate


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
if isnan(n) || n<0 || n>60
    set(hObject,'BackgroundColor','red');
else
    set(hObject,'BackgroundColor','white');
    config.step_time=n;
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
config.step_time=n;

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
global config;
enable_gui(handles,'off');
n=measure_field();
set(handles.text_earthfield,'String',mat2str(n*1e6,3));
config.earth_field=n;
plot_status();
enable_gui(handles,'on');

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
n=str2num(get(hObject,'String'));

l=0;
try
    l=norm(n*[1;1;1])
end
if l==0
    set(hObject,'BackgroundColor','red');
else
    set(hObject,'BackgroundColor','white');
    config.rotation_axis=n;
    calculate_points();
    plot_status();
end

% --- Executes during object creation, after setting all properties.
function edit_rotation_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rotation_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'BackgroundColor','white');
global config;
n=str2num(get(hObject,'String'));
config.rotation_axis=n;


function edit_target_flux_density_Callback(hObject, eventdata, handles)
% hObject    handle to edit_target_flux_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_target_flux_density as text
%        str2double(get(hObject,'String')) returns contents of edit_target_flux_density as a double
n=str2double(get(hObject,'String'));
global config;
if n<0 || n>1000
    set(hObject,'BackgroundColor','red');
else
    set(hObject,'BackgroundColor','white');
    config.target_flux_density=n*1e-6;
    calculate_points();
    plot_status();
end
    

% --- Executes during object creation, after setting all properties.
function edit_target_flux_density_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_target_flux_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'BackgroundColor','white');
global config;
n=str2double(get(hObject,'String'))
config.target_flux_density=n*1e-6;


% --- Executes on button press in pushbutton_start_360_cycle.
function pushbutton_start_360_cycle_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start_360_cycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global config
enable_gui(handles,'off');
start_360_cycle();
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
