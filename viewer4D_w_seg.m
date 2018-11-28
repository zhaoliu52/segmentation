function varargout = viewer4D_w_seg(varargin)
% VIEWER4D_W_SEG MATLAB code for viewer4D_w_seg.fig
%      VIEWER4D_W_SEG, by itself, creates a new VIEWER4D_W_SEG or raises the existing
%      singleton*.
%
%      H = VIEWER4D_W_SEG returns the handle to a new VIEWER4D_W_SEG or the handle to
%      the existing singleton*.
%
%      VIEWER4D_W_SEG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWER4D_W_SEG.M with the given input arguments.
%
%      VIEWER4D_W_SEG('Property','Value',...) creates a new VIEWER4D_W_SEG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before viewer4D_w_seg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to viewer4D_w_seg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help viewer4D_w_seg

% Last Modified by GUIDE v2.5 20-Jun-2017 22:38:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @viewer4D_w_seg_OpeningFcn, ...
                   'gui_OutputFcn',  @viewer4D_w_seg_OutputFcn, ...
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


% --- Executes just before viewer4D_w_seg is made visible.
function viewer4D_w_seg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to viewer4D_w_seg (see VARARGIN)

% Choose default command line output for viewer4D_w_seg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes viewer4D_w_seg wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = viewer4D_w_seg_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_button.
function load_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load([pwd '/bMode.mat'])
% data_num = input('input data number: ');
% load ([pwd  '/auto_fix_temp/st2015_' num2str(data_num) '_endo_a__rsp_2original'])
% load ([pwd  '/auto_fix_temp/st2015_' num2str(data_num) '_epi_a__rsp_2original'])
% load ([pwd  '/auto_fix_temp/st2015_' num2str(105) '_endo_a__rsp_2original'])
% load ([pwd  '/auto_fix_temp/st2015_' num2str(105) '_epi_a__rsp_2original'])
load ([pwd  '/auto_fix_temp/endo_a_updated'])
load ([pwd  '/auto_fix_temp/epi_a_updated'])


handles.endo_mask = endo_a_updated;
handles.epi_mask = epi_a_updated;

% set axes 1
axes(handles.axes1);
mid_frame       = round(size(bMode,3)/2);
handles.bMode   = bMode;
endo_fr_xy      = contour(squeeze(handles.endo_mask(:,:,mid_frame,1)));
epi_fr_xy       = contour(squeeze(handles.epi_mask(:,:,mid_frame,1)));
imagesc(bMode(:,:, mid_frame, 1)); colormap(gray); hold on
plot(epi_fr_xy(1, :), epi_fr_xy(2, :), 'g.');
plot(endo_fr_xy(1, :), endo_fr_xy(2, :), 'r.'); hold off

% set z slider values
set(handles.z_slider, 'Min', 1)
set(handles.z_slider, 'Max', size(bMode, 3));
set(handles.z_slider, 'Value', mid_frame); % set to beginning of sequence
set(handles.z_slider, 'SliderStep', [1, 1]/(size(bMode, 3) - 1));
set(handles.z_max, 'String', size(bMode, 3));
set(handles.z_current, 'String', mid_frame);

% set axes 2
axes(handles.axes2);
mid_frame   = round(size(bMode,2)/2);
endo_fr_xz  = contour(squeeze(handles.endo_mask(:,mid_frame,:,1)));
epi_fr_xz   = contour(squeeze(handles.epi_mask(:,mid_frame,:,1)));
imagesc(squeeze(bMode(:, mid_frame, :, 1))); colormap(gray); hold on
plot(epi_fr_xz(1, :), epi_fr_xz(2, :), 'g.');
plot(endo_fr_xz(1, :), endo_fr_xz(2, :), 'r.'); hold off

% set y slider values
set(handles.y_slider, 'Min', 1)
set(handles.y_slider, 'Max', size(bMode, 2));
set(handles.y_slider, 'Value', mid_frame); % set to beginning of sequence
set(handles.y_slider, 'SliderStep', [1, 1]/(size(bMode, 2) - 1));
set(handles.y_max, 'String', size(bMode, 2));
set(handles.y_current, 'String', mid_frame);


% set axes 2
axes(handles.axes3);
mid_frame   = round(size(bMode, 1)/2);
endo_fr_yz  = contour(squeeze(handles.endo_mask(mid_frame,:,:,1)));
epi_fr_yz   = contour(squeeze(handles.epi_mask(mid_frame,:,:,1)));
imagesc(squeeze(bMode(mid_frame, :, :, 1))); colormap(gray); hold on
plot(epi_fr_yz(1, :), epi_fr_yz(2, :), 'g.');
plot(endo_fr_yz(1, :), endo_fr_yz(2, :), 'r.'); hold off

% set y slider values
set(handles.x_slider, 'Min', 1)
set(handles.x_slider, 'Max', size(bMode, 1));
set(handles.x_slider, 'Value', mid_frame); % set to beginning of sequence
set(handles.x_slider, 'SliderStep', [1, 1]/(size(bMode, 1) - 1));
set(handles.x_max, 'String', size(bMode, 1));
set(handles.x_current, 'String', mid_frame);

% set t slider values
set(handles.t_slider, 'Min', 1)
set(handles.t_slider, 'Max', size(bMode, 4));
set(handles.t_slider, 'Value', 1); % set to beginning of sequence
set(handles.t_slider, 'SliderStep', [1, 1]/(size(bMode, 4) - 1));
set(handles.t_max, 'String', size(bMode, 4));
set(handles.t_current, 'String', 1);


clear bMode

guidata(hObject, handles)


% --- Executes on slider movement.
function z_slider_Callback(hObject, eventdata, handles)
% hObject    handle to z_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
cf = round(get(handles.z_slider,'Value'));
ct = round(get(handles.t_slider,'Value'));

set(handles.z_current,'String', num2str(cf));
set(handles.z_slider,'String', num2str(cf));
axes(handles.axes1)
imagesc(handles.bMode(:,:,cf,ct)); colormap(gray); hold on
endo_fr_xy      = contour(squeeze(handles.endo_mask(:,:,cf,ct)));
epi_fr_xy       = contour(squeeze(handles.epi_mask(:,:,cf,ct)));
plot(epi_fr_xy(1, :), epi_fr_xy(2, :), 'g.');
plot(endo_fr_xy(1, :), endo_fr_xy(2, :), 'r.'); hold off




% --- Executes during object creation, after setting all properties.
function z_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function y_slider_Callback(hObject, eventdata, handles)
% hObject    handle to y_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
cf = round(get(handles.y_slider,'Value'));
ct = round(get(handles.t_slider,'Value'));

set(handles.y_current,'String', num2str(cf));
set(handles.y_slider,'String', num2str(cf));
axes(handles.axes2)
imagesc(squeeze(handles.bMode(:,cf,:,ct))); colormap(gray); hold on
endo_fr_xz      = contour(squeeze(handles.endo_mask(:,cf,:,ct)));
epi_fr_xz       = contour(squeeze(handles.epi_mask(:,cf,:,ct)));
plot(epi_fr_xz(1, :), epi_fr_xz(2, :), 'g.');
plot(endo_fr_xz(1, :), endo_fr_xz(2, :), 'r.'); hold off


% --- Executes during object creation, after setting all properties.
function y_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function x_slider_Callback(hObject, eventdata, handles)
% hObject    handle to x_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
cf = round(get(handles.x_slider,'Value'));
ct = round(get(handles.t_slider,'Value'));

set(handles.x_current,'String', num2str(cf));
set(handles.x_slider,'String', num2str(cf));
axes(handles.axes3)
imagesc(squeeze(handles.bMode(cf, :, :, ct))); colormap(gray); hold on
endo_fr_yz      = contour(squeeze(handles.endo_mask(cf,:,:,ct)));
epi_fr_yz       = contour(squeeze(handles.epi_mask(cf,:,:,ct)));
plot(epi_fr_yz(1, :), epi_fr_yz(2, :), 'g.');
plot(endo_fr_yz(1, :), endo_fr_yz(2, :), 'r.'); hold off 
 

% --- Executes during object creation, after setting all properties.
function x_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function t_slider_Callback(hObject, eventdata, handles)
% hObject    handle to t_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
ct = round(get(handles.t_slider,'Value'));
set(handles.t_current,'String', num2str(ct));
set(handles.t_slider,'String', num2str(ct));

axes(handles.axes1)
z = round(get(handles.z_slider,'Value'));
imagesc(squeeze(handles.bMode(:, :, z, ct))); colormap(gray); hold on
endo_fr_xy      = contour(squeeze(handles.endo_mask(:,:,z,ct)));
epi_fr_xy       = contour(squeeze(handles.epi_mask(:,:,z,ct)));
plot(epi_fr_xy(1, :), epi_fr_xy(2, :), 'g.');
plot(endo_fr_xy(1, :), endo_fr_xy(2, :), 'r.'); hold off

axes(handles.axes2)
y = round(get(handles.y_slider,'Value'));
imagesc(squeeze(handles.bMode(:, y, :, ct))); colormap(gray); hold on
endo_fr_xz      = contour(squeeze(handles.endo_mask(:,y,:,ct)));
epi_fr_xz       = contour(squeeze(handles.epi_mask(:,y,:,ct)));
plot(epi_fr_xz(1, :), epi_fr_xz(2, :), 'g.');
plot(endo_fr_xz(1, :), endo_fr_xz(2, :), 'r.'); hold off

axes(handles.axes3)
x = round(get(handles.x_slider,'Value'));
imagesc(squeeze(handles.bMode(x, :, :, ct))); colormap(gray); hold on
endo_fr_yz      = contour(squeeze(handles.endo_mask(x,:,:,ct)));
epi_fr_yz       = contour(squeeze(handles.epi_mask(x,:,:,ct)));
plot(epi_fr_yz(1, :), epi_fr_yz(2, :), 'g.');
plot(endo_fr_yz(1, :), endo_fr_yz(2, :), 'r.'); hold off 


% --- Executes during object creation, after setting all properties.
function t_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
