function varargout = manual_segmentation_gui(varargin)
% MANUAL_SEGMENTATION_GUI MATLAB code for segmentation_gui.fig
%      manual_segmentation_gui, by itself, creates a new segmentation_gui or raises the existing
%      singleton*.
%
%      H = manual_segmentation_gui returns the handle to a new segmentation_gui or the handle to
%      the existing singleton*.
%
%      manual_segmentation_gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in segmentation_gui.M with the given input arguments.
%
%      manual_segmentation_gui('Property','Value',...) creates a new manual_segmentation_gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manual_segmentation_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manual_segmentation_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help segmentation_gui

% Last Modified by GUIDE v2.5 04-Dec-2014 20:00:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @manual_segmentation_gui_OpeningFcn, ...
    'gui_OutputFcn',  @manual_segmentation_gui_OutputFcn, ...
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


% --- Executes just before segmentation_gui is made visible.
function manual_segmentation_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segmentation_gui (see VARARGIN)

% Choose default command line output for segmentation_gui
handles.output = hObject;

% add helper function path
% addpath ([pwd '/helper_functions/'])
addpath '/home/kevin/Desktop/auto_segmentation/helper_functions'

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes segmentation_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = manual_segmentation_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on selection change in choose_type.
function choose_type_Callback(hObject, eventdata, handles)
% hObject    handle to choose_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns choose_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choose_type
guidata(hObject, handles)


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
function z_slider_Callback(hObject, eventdata, handles)
% hObject    handle to z_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
cf = round(get(handles.z_slider,'Value'));
set(handles.z_current,'String', num2str(cf));
set(handles.z_slider,'String', num2str(cf));
axes(handles.axes1)
imagesc(handles.bMode(:, :, cf, 1)); colormap(gray)
path_name = handles.path_name;

% if mask indicates segmentation done, then show the contour
% endo
if (exist([path_name 'endo_1_contours.mat'], 'file') == 2) && ...
        (exist([path_name 'endo_1_z_done_flag.mat'], 'file')==2)
    load ([path_name 'endo_1_z_done_flag'])
    load ([path_name 'endo_1_contours'])
    if endo_1_z_done_flag(cf)
        hold on
        plot(endo_1_contours(cf).pts(:,1), endo_1_contours(cf).pts(:,2), 'g');
        hold off
    end
end
% epi
if (exist([path_name 'epi_1_contours.mat'], 'file') == 2) && ...
        (exist([path_name 'epi_1_z_done_flag.mat'], 'file'))
    load ([path_name 'epi_1_z_done_flag'])
    load ([path_name 'epi_1_contours'])
    if epi_1_z_done_flag(cf)
        hold on
        plot(epi_1_contours(cf).pts(:,1), epi_1_contours(cf).pts(:,2), 'r');
        hold off
    end
end





% --- Executes on button press in load_file.
function load_file_Callback(hObject, eventdata, handles)
% hObject    handle to load_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file_name, path_name] = uigetfile;

% load the bMode file
if strcmp(file_name(end-2:end), 'mat')
    load([path_name file_name])
end


% set axes
axes(handles.axes1);

% load z slice 1
mid_frame = round(size(bMode,3)/2);
imagesc(bMode(:,:,mid_frame,1)); colormap(gray)


% set slider max and min
set(handles.z_slider, 'Min', 1)
set(handles.z_slider, 'Max', size(bMode, 3));
set(handles.z_slider, 'Value', mid_frame); % set to beginning of sequence
set(handles.z_slider, 'SliderStep', [1, 1]/(size(bMode, 3) - 1));
set(handles.z_max, 'String', size(bMode,3));
set(handles.z_current, 'String', mid_frame);

% save bMode with handles
handles.bMode       = bMode(:,:,:,1);
if ~(exist('endo_1_z_done_flag.mat', 'file') == 2) % initiate endo parameters
    endo_1_z_done_flag         = zeros(size(bMode,3),1);
    save([path_name 'endo_1_z_done_flag'], 'endo_1_z_done_flag');
    
    % temp endo mask
    endo_1_temp = zeros(size(bMode(:,:,:,1)));
    save([path_name 'endo_1_temp'], 'endo_1_temp');
    
    % contours contours
    for i = 1:size(bMode,3)
        endo_1_contours(i).pts = [];
    end
    save([path_name 'endo_1_contours'], 'endo_1_contours');
    
    % contours contours
    for i = 1:size(bMode,3)
        endo_1_spline(i).knots = [];
    end
    save([path_name 'endo_1_spline'], 'endo_1_spline');
    
    % suggestion flag to use previous or next contour, all 1 by default
    endo_1_suggest_flag = ones(size(bMode,3),1);
    save([path_name 'endo_1_suggest_flag'], 'endo_1_suggest_flag');
    
    fprintf('z flag created and temp mask created \n')
end
if ~(exist('epi_1_z_done_flag.mat', 'file') == 2) % initiate epi parameters
    epi_1_z_done_flag         = zeros(size(bMode,3),1);
    save([path_name 'epi_1_z_done_flag'], 'epi_1_z_done_flag');
    
    % temp endo mask
    epi_1_temp = zeros(size(bMode(:,:,:,1)));
    save([path_name 'epi_1_temp'], 'epi_1_temp');
    
    % contours contours
    for i = 1:size(bMode,3)
        epi_1_contours(i).pts = [];
    end
    save([path_name 'epi_1_contours'], 'epi_1_contours');
    
    % contours contours
    for i = 1:size(bMode,3)
        epi_1_spline(i).knots = [];
    end
    save([path_name 'epi_1_spline'], 'epi_1_spline');
    
    % suggestion flag to use previous or next contour, all 1 by default
    epi_1_suggest_flag = ones(size(bMode,3),1);
    save([path_name 'epi_1_suggest_flag'], 'epi_1_suggest_flag');
    
    fprintf('z flag created and temp mask created \n')
end

handles.path_name = path_name; 

guidata(hObject, handles)


% --- Executes on button press in start_seg.
function start_seg_Callback(hObject, eventdata, handles) %#ok<INUSL,DEFNU>
% hObject    handle to start_seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bMode       = handles.bMode;
fprintf('use the tool to begin segmentation \n')
cf          = round(get(handles.z_slider,'Value'));
axes(handles.axes1)
path_name = handles.path_name;


% load the done flag and based on that operate
load ([path_name 'endo_1_temp'])
load ([path_name 'endo_1_z_done_flag'])
load ([path_name 'endo_1_spline'])
load ([path_name 'endo_1_contours'])
load ([path_name 'endo_1_suggest_flag'])
load ([path_name 'epi_1_temp'])
load ([path_name 'epi_1_z_done_flag'])
load ([path_name 'epi_1_spline'])
load ([path_name 'epi_1_contours'])
load ([path_name 'epi_1_suggest_flag'])

% previous or next frame has already been segmented, then use that as
% starting point
if get(handles.choose_type, 'Value') == 1
    if endo_1_z_done_flag(cf) && endo_1_suggest_flag(cf)
        pos_init    = endo_1_spline(cf).knots;
        handles.roi_obj           = impoly(gca, pos_init);
    elseif endo_1_z_done_flag(cf-1) && endo_1_suggest_flag(cf)
        pos_init    = endo_1_spline(cf-1).knots;
        handles.roi_obj           = impoly(gca, pos_init);
    elseif endo_1_z_done_flag(cf+1) && endo_1_suggest_flag(cf)
        pos_init    = endo_1_spline(cf+1).knots;
        handles.roi_obj           = impoly(gca, pos_init);
    else
        handles.roi_obj           = impoly(gca);
    end
    
    guidata(hObject, handles)
    
    position = wait(handles.roi_obj);
    
    % if position is acquired
    if position
        % smooth positions and save
        pos_smoothed        = MakeContourClockwise2D(position);
        pos_smoothed        = InterpolateContourPoints2D(pos_smoothed, 100);
        BW                  = roipoly(bMode(:,:,cf), pos_smoothed(:,1), pos_smoothed(:,2));
        
        % update segmentation and other parameters for this frame
        endo_1_temp(:,:,cf)   = BW;
        endo_1_contours(cf).pts = pos_smoothed;
        endo_1_spline(cf).knots = position;
        endo_1_z_done_flag(cf) = 1;
        endo_1_suggest_flag(cf) = 1;
        
        % update/save relavent variables
        handles.endo_m = endo_1_temp;
        save([path_name 'endo_1_temp'], 'endo_1_temp')
        save([path_name 'endo_1_z_done_flag'], 'endo_1_z_done_flag')
        save([path_name 'endo_1_suggest_flag'], 'endo_1_suggest_flag')
        save([path_name 'endo_1_spline'], 'endo_1_spline')
        save([path_name 'endo_1_contours'], 'endo_1_contours')
        
        fprintf('done with endo frame %d \n', cf);
    end
else
    if epi_1_z_done_flag(cf) && epi_1_suggest_flag(cf)
        pos_init    = epi_1_spline(cf).knots;
        handles.roi_obj           = impoly(gca, pos_init);
    elseif epi_1_z_done_flag(cf-1) && epi_1_suggest_flag(cf)
        pos_init    = epi_1_spline(cf-1).knots;
        handles.roi_obj           = impoly(gca, pos_init);
    elseif epi_1_z_done_flag(cf+1) && epi_1_suggest_flag(cf)
        pos_init    = epi_1_spline(cf+1).knots;
        handles.roi_obj           = impoly(gca, pos_init);
    else
        handles.roi_obj           = impoly(gca);
    end
    
    guidata(hObject, handles)
    
    position = wait(handles.roi_obj);
    
    % if position is acquired
    if position
        % smooth positions and save
        pos_smoothed        = MakeContourClockwise2D(position);
        pos_smoothed        = InterpolateContourPoints2D(pos_smoothed, 100);
        BW                  = roipoly(bMode(:,:,cf), pos_smoothed(:,1), pos_smoothed(:,2));
        
        % update segmentation and other parameters for this frame
        epi_1_temp(:,:,cf)   = BW;
        epi_1_contours(cf).pts = pos_smoothed;
        epi_1_spline(cf).knots = position;
        epi_1_z_done_flag(cf) = 1;
        epi_1_suggest_flag(cf) = 1;
        
        % update/save relavent variables
        handles.endo_m = epi_1_temp;
        save([path_name 'epi_1_temp'], 'epi_1_temp')
        save([path_name 'epi_1_z_done_flag'], 'epi_1_z_done_flag')
        save([path_name 'epi_1_suggest_flag'], 'epi_1_suggest_flag')
        save([path_name 'epi_1_spline'], 'epi_1_spline')
        save([path_name 'epi_1_contours'], 'epi_1_contours')
        
        fprintf('done with epi frame %d \n', cf);
    end
end
guidata(hObject, handles)


% --- Executes on button press in clear_seg.
function clear_seg_Callback(hObject, eventdata, handles)
% hObject    handle to clear_seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cf          = round(get(handles.z_slider,'Value'));
axes(handles.axes1);
imagesc(handles.bMode(:,:,cf));
path_name = handles.path_name;

if get(handles.choose_type, 'Value') == 1    
    if (exist([path_name 'endo_1_z_done_flag.mat'], 'file') == 2)
        load ([path_name 'endo_1_z_done_flag'])
        load ([path_name 'endo_1_suggest_flag'])
        endo_1_z_done_flag(cf) = 0;
        endo_1_suggest_flag(cf) = 0;
    end
    
    save([path_name 'endo_1_z_done_flag'], 'endo_1_z_done_flag')
    save([path_name 'endo_1_suggest_flag'], 'endo_1_suggest_flag')
else
        
    if (exist([path_name 'epi_1_z_done_flag.mat'], 'file') == 2)
        load ([path_name 'epi_1_z_done_flag'])
        load ([path_name 'epi_1_suggest_flag'])
        epi_1_z_done_flag(cf) = 0;
        epi_1_suggest_flag(cf) = 0;
    end
    
    save([path_name 'epi_1_z_done_flag'], 'epi_1_z_done_flag')
    save([path_name 'epi_1_suggest_flag'], 'epi_1_suggest_flag')
end
guidata(hObject, handles)



% --- Executes on button press in segment_all.
function segment_all_Callback(hObject, eventdata, handles)
% hObject    handle to segment_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path_name = handles.path_name;
addpath('/home/kevin/Desktop/data')

basedir = '/home/kevin/Desktop/data';
studynum = str2num(get(handles.std_name, 'String'));
datanum = str2num(get(handles.data_num, 'String'));
voxunit=1;

[path_name 'st' num2str(studynum) '_' num2str(datanum) '_endo_m.mat']

% make the manual files for xiaojie segmentation
if ~(exist([path_name 'st' num2str(studynum) '_' num2str(datanum) '_endo_m.mat'], 'file') == 2)
    load ([path_name 'bMode.mat'])
    load ([path_name 'endo_1_temp.mat'])
    endo = zeros(size(bMode));
    endo(:,:,:,1)   = endo_1_temp;
    for i = 2:size(bMode,4)
        endo(:,:,:,i) = zeros(size(endo(:,:,:,1)));
    end
    endo = uint8(endo);
    save([path_name 'st' num2str(studynum) '_' num2str(datanum) '_endo_m.mat'], 'endo')
end
% check for epi
if ~(exist([path_name 'st' num2str(studynum) '_' num2str(datanum) '_epi_m.mat'], 'file') == 2)
    load ([path_name 'bMode.mat'])
    load ([path_name 'epi_1_temp.mat'])
    epi = zeros(size(bMode));
    epi(:,:,:,1)    = epi_1_temp;
    for i = 2:size(bMode,4)
        epi(:,:,:,i) = zeros(size(epi(:,:,:,1)));
    end
    epi = uint8(epi);
    save([path_name 'st' num2str(studynum) '_' num2str(datanum) '_epi_m.mat'], 'epi')
end
clear bMode endo epi

% Read the manual tracings
mode = 1;
num1=1;       % frame 1
num2=1;       % ends at frame 1
sm=0;
trim=0;
surunit=1;


% resample to make faster I suppose
if ~(exist([path_name 'st' num2str(studynum) '_' num2str(datanum) '_image_rsp.mat'], 'file') == 2)
    resampleimage2(basedir,studynum,datanum)
end

% Resample the manual segmentation
if mode == 1
    if ~(exist([path_name 'st' num2str(studynum) '_' num2str(datanum) '_endo_m_rsp.mat'], 'file') == 2)
        resamplemanual2(basedir, studynum, datanum, 1);
    end
else
    if ~(exist([path_name num2str(studynum) num2str(datanum) '_epi_m_rsp.mat'], 'file') == 2)
        resamplemanual2(basedir, studynum, datanum, 2);
    end
end


% try segmentation
% Segment the dataset
% parameters are set in SRSegment_region3D_loop_rsp2.m
controlpara.d=1;
controlpara.a=0;
controlpara.c=0.9;
suffix='temp';
multiscale=1;
DictInit=1;
viewmask=0;
Experiment3D_rsp3(basedir,studynum,datanum,suffix,mode,multiscale,DictInit,viewmask,controlpara);


% Resample the segmentation result back to the original resolution
resampleseg_to_original(basedir,studynum,datanum,suffix,mode);

% Save the binary image to an Analyze file
Seg2AnaBin_rsp_2original(basedir,studynum,datanum, suffix, mode);

% Save the segmented images (cardiac borders are in black) to an Analyze file
suffix='temp';
onlyimage=0;
Seg2Ana_rsp(basedir, studynum, datanum, suffix, mode, onlyimage)

% Epi now
mode = 2;

% Resample the manual segmentation
resamplemanual2(basedir,studynum,datanum,mode);

% epi
% parameters are set in SRSegment_region3D_loop_rsp2.m
Experiment3D_rsp3(basedir,studynum,datanum,suffix,mode,multiscale,DictInit,viewmask,controlpara);

% Resample the segmentation result back to the original resolution
resampleseg_to_original(basedir,studynum,datanum,suffix,mode);

% Save the binary image to an Analyze file
Seg2AnaBin_rsp_2original(basedir,studynum,datanum, suffix, mode);


guidata(hObject, handles);


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




% --- Executes during object creation, after setting all properties.
function end_sys_CreateFcn(hObject, eventdata, handles)
% hObject    handle to end_sys (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sh_track.
function sh_track_Callback(hObject, eventdata, handles)
% hObject    handle to sh_track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% call the run shape tracking function
run_shape_tracking(handles)
