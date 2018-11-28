function varargout = auto_segmentation_fix(varargin)
% AUTO_SEGMENTATION_FIX MATLAB code for auto_segmentation_fix.fig
%      AUTO_SEGMENTATION_FIX, by itself, creates a new AUTO_SEGMENTATION_FIX or raises the existing
%      singleton*.
%
%      H = AUTO_SEGMENTATION_FIX returns the handle to a new AUTO_SEGMENTATION_FIX or the handle to
%      the existing singleton*.
%
%      AUTO_SEGMENTATION_FIX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUTO_SEGMENTATION_FIX.M with the given input arguments.
%
%      AUTO_SEGMENTATION_FIX('Property','Value',...) creates a new AUTO_SEGMENTATION_FIX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before auto_segmentation_fix_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to auto_segmentation_fix_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help auto_segmentation_fix

% Last Modified by GUIDE v2.5 20-Mar-2015 20:54:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @auto_segmentation_fix_OpeningFcn, ...
                   'gui_OutputFcn',  @auto_segmentation_fix_OutputFcn, ...
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


% --- Executes just before auto_segmentation_fix is made visible.
function auto_segmentation_fix_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to auto_segmentation_fix (see VARARGIN)

% add helper function path
addpath ([pwd '/helper_functions/'])

% Choose default command line output for auto_segmentation_fix
handles.output = hObject;

%%% make the fixed sliders

% amount of knots for rbf/spline and smoothness quantity
knot_min    = 5;
knot_max    = 40;
knot_start  = 15;
knot_step   = 5;
set(handles.knot_slider, 'Min', knot_min)
set(handles.knot_slider, 'Max', knot_max);
set(handles.knot_slider, 'Value', knot_start);
set(handles.knot_slider, 'SliderStep', [knot_step knot_step*2]/(knot_max - knot_min));
set(handles.k_min, 'String', num2str(knot_min));
set(handles.k_max, 'String', num2str(knot_max));
set(handles.k_current, 'String',num2str(knot_start));

sm_min    = 1;
sm_max    = 10;
sm_start  = 3;
sm_step   = 1;
set(handles.smoothness_slider, 'Min', sm_min)
set(handles.smoothness_slider, 'Max', sm_max);
set(handles.smoothness_slider, 'Value', sm_start);
set(handles.smoothness_slider, 'SliderStep', [sm_step sm_step*2]/(sm_max - sm_min));
set(handles.sm_min, 'String', num2str(sm_min));
set(handles.sm_max, 'String', num2str(sm_max));
set(handles.sm_current, 'String',num2str(sm_start));

%%% end auto_segmentation_fix_OpeningFcn


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes auto_segmentation_fix wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = auto_segmentation_fix_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function z_slider_Callback(hObject, eventdata, handles)
% hObject    handle to z_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
load([pwd '/auto_fix_temp/z_vals.mat'])
cf = round(get(handles.z_slider,'Value'));
ct = round(get(handles.t_slider,'Value'));

set(handles.z_current,'String', num2str(cf));
set(handles.z_slider,'String', num2str(cf));
axes(handles.axes1)
imagesc(handles.bMode(:,:,cf,ct)); colormap(gray); hold on

num_points  = handles.plot_num_points;
if cf >= z_range(1) && cf <= z_range(2)
    v_endo = mask2ContourPts(handles.endo_a(:, :, cf, ct), num_points, 5);
    plot(v_endo(:,1), v_endo(:,2), 'g');
    v_epi = mask2ContourPts(handles.epi_a(:, :, cf, ct), num_points, 5);
    plot(v_epi(:,1), v_epi(:,2), 'r');
    
    % if updates have been made, draw updated contour as well
    if isfield(handles, 'endo_update_flag')
        if handles.endo_update_flag(cf, ct) == 1
            v_endo = mask2ContourPts(handles.endo_a_updated(:, :, cf, ct), num_points, 5);
            plot(v_endo(:,1), v_endo(:,2), 'm');
        end
        
        if handles.epi_update_flag(cf, ct) == 1
            v_epi = mask2ContourPts(handles.epi_a_updated(:, :, cf, ct), num_points, 5);
            plot(v_epi(:,1), v_epi(:,2), 'y');
        end
    end
end
hold off
%%% end z_slider_callback



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
function t_slider_Callback(hObject, eventdata, handles)
% hObject    handle to t_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
load([pwd '/auto_fix_temp/z_vals.mat'])

cf = round(get(handles.z_slider,'Value'));
ct = round(get(handles.t_slider,'Value'));
set(handles.t_current,'String', num2str(ct));
set(handles.t_slider,'String', num2str(ct));
axes(handles.axes1)
imagesc(handles.bMode(:,:,cf,ct)); colormap(gray); hold on;
num_points  = handles.plot_num_points;

if cf >= z_range(1) && cf <= z_range(2)
    v_endo = mask2ContourPts(handles.endo_a(:, :, cf, ct), num_points, 5);
    plot(v_endo(:,1), v_endo(:,2), 'g');
    v_epi = mask2ContourPts(handles.epi_a(:, :, cf, ct), num_points, 5);
    plot(v_epi(:,1), v_epi(:,2), 'r');
    
    % if updates have been made, draw updated contour as well
    if isfield(handles, 'endo_update_flag')
        if handles.endo_update_flag(cf, ct) == 1
            v_endo = mask2ContourPts(handles.endo_a_updated(:, :, cf, ct), num_points, 5);
            plot(v_endo(:,1), v_endo(:,2), 'm');
        end
        
        if handles.epi_update_flag(cf, ct) == 1
            v_epi = mask2ContourPts(handles.epi_a_updated(:, :, cf, ct), num_points, 5);
            plot(v_epi(:,1), v_epi(:,2), 'y');
        end
    end
end
hold off


% update, save everytime time slider is moved if in save mode
if get(handles.save_radio_button, 'Value')
    endo_a_updated      = handles.endo_a_updated;
    endo_update_flag    = handles.endo_update_flag;
    epi_a_updated       = handles.epi_a_updated;
    epi_update_flag     = handles.epi_update_flag;
    save([pwd '/auto_fix_temp/endo_a_updated'], 'endo_a_updated');
    save([pwd '/auto_fix_temp/endo_update_flag'], 'endo_update_flag');
    save([pwd '/auto_fix_temp/epi_a_updated'], 'epi_a_updated');
    save([pwd '/auto_fix_temp/epi_update_flag'], 'epi_update_flag');
end
%%% end t_slider_Callback



% --- Executes during object creation, after setting all properties.
function t_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in load_file.
function load_file_Callback(hObject, eventdata, handles)
% hObject    handle to load_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load([pwd '/auto_fix_temp/bMode.mat'])

listing = dir([pwd '/auto_fix_temp/']);
for i = 1:length(listing)
    if length(listing(i).name) > 9
        if findstr(listing(i).name, 'endo_a')
            load ([pwd '/auto_fix_temp/' listing(i).name])
        end
        if findstr(listing(i).name, 'epi_a')
            load ([pwd '/auto_fix_temp/' listing(i).name])
        end
    end
end
% load([pwd '/auto_fix_temp/endo_a.mat'])
% load([pwd '/auto_fix_temp/epi_a.mat'])
addpath([pwd '/helper_functions/'])


% set axes
axes(handles.axes1);

% load z slice 1
mid_frame           = round(size(bMode,3)/2);
handles.bMode       = bMode;

imagesc(bMode(:,:,mid_frame,1)); colormap(gray); hold on


% set z and t sliders max and min according to image dimensions
set(handles.z_slider, 'Min', 1)
set(handles.z_slider, 'Max', size(bMode, 3));
set(handles.z_slider, 'Value', mid_frame); % set to beginning of sequence
set(handles.z_slider, 'SliderStep', [1, 1]/(size(bMode, 3) - 1));
set(handles.z_max, 'String', size(bMode, 3));
set(handles.z_current, 'String', mid_frame);
set(handles.t_slider, 'Min', 1)
set(handles.t_slider, 'Max', size(bMode, 4));
set(handles.t_slider, 'Value', 1); % set to beginning of sequence
set(handles.t_slider, 'SliderStep', [1, 1]/(size(bMode, 4) - 1));
set(handles.t_max, 'String', size(bMode,4));
set(handles.t_current, 'String', 1);


% show the endo and epi contour with different colors 
% figure(5); imagesc(endo_a(:, :, mid_frame, 1));
num_points  = 50;
handles.plot_num_points = num_points;

v_endo = mask2ContourPts(endo_a(:, :, mid_frame, 1), num_points, 5);
plot(v_endo(:,1), v_endo(:,2), 'g'); 
v_epi = mask2ContourPts(epi_a(:, :, mid_frame, 1), num_points, 5);
plot(v_epi(:,1), v_epi(:,2), 'r'); 
% if flags and variables don't exist, create them
if ~(exist([pwd '/auto_fix_temp/endo_update_flag.mat'], 'file') == 2) % initiate endo parameters
    endo_a_updated              = endo_a;
    endo_update_flag            = zeros(size(endo_a, 3), size(endo_a, 4));
    epi_a_updated               = epi_a;
    epi_update_flag             = zeros(size(endo_a, 3), size(endo_a, 4));
    handles.endo_a_updated      = endo_a_updated;
    handles.endo_update_flag    = endo_update_flag;
    handles.epi_a_updated       = epi_a_updated;
    handles.epi_update_flag     = epi_update_flag;
    
    save([pwd '/auto_fix_temp/endo_a_updated'], 'endo_a_updated');
    save([pwd '/auto_fix_temp/endo_update_flag'], 'endo_update_flag');
    save([pwd '/auto_fix_temp/epi_a_updated'], 'epi_a_updated');
    save([pwd '/auto_fix_temp/epi_update_flag'], 'epi_update_flag');
% else, load them and show the updated flags in different color
else 
    load([pwd '/auto_fix_temp/endo_a_updated'])
    load([pwd '/auto_fix_temp/endo_update_flag'])
    load([pwd '/auto_fix_temp/epi_a_updated'])
    load([pwd '/auto_fix_temp/epi_update_flag'])
    
    handles.endo_a_updated      = endo_a_updated;
    handles.endo_update_flag    = endo_update_flag;
    handles.epi_a_updated       = epi_a_updated;
    handles.epi_update_flag     = epi_update_flag;
    
    % if updated display 
    if endo_update_flag(mid_frame, 1)
        v_endo = getVertices(endo_a_updated(:, :, mid_frame, 1), num_points);
        plot(v_endo(:,1), v_endo(:,2), 'm');
    end
    
    if epi_update_flag(mid_frame, 1)
        v_epi = getVertices(epi_a_updated(:, :, mid_frame, 1), num_points);
        plot(v_epi(:,1), v_epi(:,2), 'y');
    end
end

hold off

% save endo/epi
handles.endo_a  = endo_a;
handles.epi_a   = epi_a;

clear endo_a endo_a_updated epi_a epi_a_updated bMode

guidata(hObject, handles)
%%% end load_file


% --- Executes on button press in start_seg.
function fix_seg_Callback(hObject, eventdata, handles)
% hObject    handle to start_seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load([pwd '/auto_fix_temp/z_vals.mat'])

cf = round(get(handles.z_slider,'Value'));
ct = round(get(handles.t_slider,'Value'));
set(handles.t_current,'String', num2str(ct));
set(handles.t_slider,'String', num2str(ct));
axes(handles.axes1)
imagesc(handles.bMode(:,:,cf,ct)); colormap(gray); hold on;


% for now fix number of knots
knots       = get(handles.knot_slider, 'Value');
smoothness  =  get(handles.smoothness_slider, 'Value'); 
if cf >= z_range(1) && cf <= z_range(2)
    
    % choose endo or epi; endo = 1
    if get(handles.choose_type, 'Value') == 1
        % if updated already, load updated contour, else load nearby
         % contours, else load the old contour
        if handles.endo_update_flag(cf, ct)
            v_endo          = mask2ContourPts(handles.endo_a_updated(:,:,cf, ct), knots, smoothness);
        elseif handles.endo_update_flag(cf-1, ct)
            v_endo          = mask2ContourPts(handles.endo_a_updated(:,:,cf-1, ct), knots, smoothness);
        elseif handles.endo_update_flag(cf+1, ct)
            v_endo          = mask2ContourPts(handles.endo_a_updated(:,:,cf+1, ct), knots, smoothness);
        else
            v_endo          = mask2ContourPts(handles.endo_a(:,:,cf, ct), knots, smoothness);
        end
        
        %%% get epi as well
        if handles.epi_update_flag(cf, ct)
            v_epi          = mask2ContourPts(handles.epi_a_updated(:,:,cf, ct), knots, smoothness);
        elseif handles.epi_update_flag(cf-1, ct)
            v_epi          = mask2ContourPts(handles.epi_a_updated(:,:,cf-1, ct), knots, smoothness);
        elseif handles.epi_update_flag(cf+1, ct)
            v_epi          = mask2ContourPts(handles.epi_a_updated(:,:,cf+1, ct), knots, smoothness);
        else
            v_epi          = mask2ContourPts(handles.epi_a(:,:,cf, ct), knots, smoothness);
        end
        
        plot(v_endo(:,1), v_endo(:,2), 'g'); 
        plot(v_epi(:,1), v_epi(:,2), 'r'); 
        roi_obj             = impoly(gca, v_endo);
        position            = wait(roi_obj);
        
        % if something was obtained
        if position
            pos_smoothed        = MakeContourClockwise2D(position);
            pos_smoothed        = InterpolateContourPoints2D(pos_smoothed, 100);
            BW1                 = roipoly(zeros(size(handles.endo_a(:,:,1,1))), pos_smoothed(:,1), pos_smoothed(:,2));
            
            plot(pos_smoothed(:,1), pos_smoothed(:,2), 'm');
            
            handles.endo_update_flag(cf, ct)    = 1;
            handles.endo_a_updated(:,:,cf,ct)   = BW1;
        end
    else % else Epi
         % if updated already, load updated contour, else load nearby
         % contours, else load the old contour
        if handles.epi_update_flag(cf, ct) == 1
            v_epi          = mask2ContourPts(handles.epi_a_updated(:,:,cf, ct), knots, smoothness);
        elseif handles.epi_update_flag(cf-1, ct)
            v_epi          = mask2ContourPts(handles.epi_a_updated(:,:,cf-1, ct), knots, smoothness);
        elseif handles.epi_update_flag(cf+1, ct)
            v_epi          = mask2ContourPts(handles.epi_a_updated(:,:,cf+1, ct), knots, smoothness);
        else
            v_epi          = mask2ContourPts(handles.epi_a(:,:,cf, ct), knots, smoothness);
        end
        
        if handles.endo_update_flag(cf, ct)
            v_endo          = mask2ContourPts(handles.endo_a_updated(:,:,cf, ct), knots, smoothness);
        elseif handles.endo_update_flag(cf-1, ct)
            v_endo          = mask2ContourPts(handles.endo_a_updated(:,:,cf-1, ct), knots, smoothness);
        elseif handles.endo_update_flag(cf+1, ct)
            v_endo          = mask2ContourPts(handles.endo_a_updated(:,:,cf+1, ct), knots, smoothness);
        else
            v_endo          = mask2ContourPts(handles.endo_a(:,:,cf, ct), knots, smoothness);
        end
        
        plot(v_epi(:,1), v_epi(:,2), 'r');
        plot(v_endo(:,1), v_endo(:,2), 'g');
        roi_obj             = impoly(gca, v_epi);
        position            = wait(roi_obj);
        
        % if something was obtained
        if position
            pos_smoothed        = MakeContourClockwise2D(position);
            pos_smoothed        = InterpolateContourPoints2D(pos_smoothed, 140);
            BW1                 = roipoly(zeros(size(handles.endo_a(:,:,1,1))), pos_smoothed(:,1), pos_smoothed(:,2));
            
            plot(pos_smoothed(:,1), pos_smoothed(:,2), 'm');
            
            handles.epi_update_flag(cf, ct)    = 1;
            handles.epi_a_updated(:,:,cf,ct)   = BW1;
        end
    end
end
hold off
guidata(hObject, handles)
%%% end fix_seg_callback


% --- Executes on selection change in choose_type.
function choose_type_Callback(hObject, eventdata, handles)
% hObject    handle to choose_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns choose_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choose_type


% --- Executes during object creation, after setting all properties.
function choose_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choose_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function std_name_Callback(hObject, eventdata, handles)
% hObject    handle to std_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of std_name as text
%        str2double(get(hObject,'String')) returns contents of std_name as a double


% --- Executes during object creation, after setting all properties.
function std_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to std_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function data_num_Callback(hObject, eventdata, handles)
% hObject    handle to data_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data_num as text
%        str2double(get(hObject,'String')) returns contents of data_num as a double


% --- Executes during object creation, after setting all properties.
function data_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function knot_slider_Callback(hObject, eventdata, handles)
% hObject    handle to knot_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

set(handles.k_current, 'String', num2str(get(handles.knot_slider, 'Value')));
guidata(hObject, handles);

%%% end knot_slider_callback

% --- Executes during object creation, after setting all properties.
function knot_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to knot_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%%% end knot_slider_CreateFcn



% --- Executes on slider movement.
function smoothness_slider_Callback(hObject, eventdata, handles)
% hObject    handle to smoothness_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.sm_current, 'String', num2str(get(handles.smoothness_slider, 'Value')));
guidata(hObject, handles);
%%% end smoothness_slider_Callback

% --- Executes during object creation, after setting all properties.
function smoothness_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothness_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in save_radio_button.
function save_radio_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_radio_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_radio_button
