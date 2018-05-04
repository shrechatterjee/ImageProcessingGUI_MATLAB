function varargout = threshold(varargin)
% THRESHOLD MATLAB code for threshold.fig
%      THRESHOLD, by itself, creates a new THRESHOLD or raises the existing
%      singleton*.
%
%      H = THRESHOLD returns the handle to a new THRESHOLD or the handle to
%      the existing singleton*.
%
%      THRESHOLD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THRESHOLD.M with the given input arguments.
%
%      THRESHOLD('Property','Value',...) creates a new THRESHOLD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before threshold_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to threshold_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help threshold

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @threshold_OpeningFcn, ...
                   'gui_OutputFcn',  @threshold_OutputFcn, ...
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
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% global excelRow;
% excelRow = 0; % Row for the first write.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% --- Executes just before threshold is made visible.

% skc105@ecs.soton.ac.uk
%This code creates a GUI to interactively select ROI's as per different thresholds for Upper, Middle and Lower Images. A histogram plot can 
% enables to find the optimum threshold for the particular segment of the
% image. The target images are saved with different segments binarized as
% per the chosen thresholds. The threshold values can be saved into an
% excel sheet. 

function threshold_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to threshold (see VARARGIN)

% Choose default command line output for threshold
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes threshold wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = threshold_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% global T;
global filename;

% T = table(Filename,Lower_threshold,Middle_threshold,Upper_threshold);
% T(1:100,:)
filename = 'threshold_values.xlsx';
F=strcat('Filename','');
L=strcat('Lower_threshold','');
M=strcat('Middle_threshold','');
U=strcat('Upper_threshold','');

xlswrite(filename,{F},1,'C1:C1');
xlswrite(filename,{L},1,'D1:D1');
xlswrite(filename,{M},1,'E1:E1');
xlswrite(filename,{U},1,'F1:F1');
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% --- Executes on button press in pushbutton1 - loads the image
function pushbutton1_Callback(hObject1, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
global I;
global name;

%handles.axes1 = hObject1;
[image_name pathname] = uigetfile('*.jpg','select jpg file');
[pathstr,name,ext] = fileparts(image_name);
complete = strcat(pathname,image_name);

I = imread(complete);
image = I;
imshow(I,[]);
% Creates a new figure
movegui(handles.axes1);
F = getframe(handles.axes1);
Image1 = frame2im(F);
imwrite(Image1, image_name)

% guidata(hObject1, handles.axes1);

% --- Executes on button press in pushbutton2 - thresholds the image
function pushbutton2_Callback(hObject2, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
global I;
global name;

%handles.axes3 = hObject2;
% image_double = im2double(I);
% %image_gray = rgb2gray(image);
% level_MATLAB = multithresh(image_double)
% BW = im2bw(image_double,level_MATLAB);
% imshow(BW,[])
clc
imhist(I)
s = strcat(name,'_histogram.jpg');
movegui(handles.axes3);
F = getframe(handles.axes3);
Image2 = frame2im(F);
imwrite(Image2, s)

%guidata(im1, handles.axes1);
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% --- Executes on slider movement.
function slider1_Callback(hObject3, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global I;
global level
global I_thresholded;
clc
handles.slider1 = hObject3;
set(handles.slider1,'min',0);
set(handles.slider1,'max',255);
set(handles.slider1,'sliderstep',[1/255 1/255]);

level = get(handles.slider1,'Value');

% BW = im2bw(image_double,level);
% imshow(BW,[])

I = I(:,:,1);
I_thresholded = I;
I_thresholded(I>level) = 256;
I_thresholded(I<level) = 0;

imshow(I_thresholded,[])
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton3 - clears both original and
% thresholded image
function pushbutton3_Callback(hObject5, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global excelRow;
clc
cla(handles.axes1,'reset');
cla(handles.axes3,'reset');
cla(handles.axes4,'reset');
set(handles.slider1,'Value',0);

excelRow=1;
set(handles.pushbutton7, 'String', excelRow);
clc
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject7, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global name; %name of the image being read
global cellreference1;
global cellreference2;
global cellreference3;
global cellreference4;
global excelRow;
global filename;
clc


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Read current text and convert it to a number.
currentCounterValue = str2double(get(handles.pushbutton7, 'string'));

% Create a new string with the number being 1 more than the current number.
excelRow = sprintf('%d', int64(currentCounterValue +1))
% Send the new string to the text control.
set(handles.pushbutton7, 'String', excelRow);
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fig_name=num2str(name);

cellreference1 = sprintf('C%s',excelRow);
cellreference2 = sprintf('D%s',excelRow);
cellreference3 = sprintf('E%s',excelRow);
cellreference4 = sprintf('F%s',excelRow);

% --- Executes on button press in pushbutton4 - saves the thresholded image
% in axes4

function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global name;
global level;
global filename;
global A;
global cellreference2;
global cellreference1;

A=[];
clc
s = strcat(name,'_lower_ocean_thresholded.jpg');
movegui(handles.axes4);
F = getframe(handles.axes4);
Image3 = frame2im(F);
imwrite(Image3, s)
A=level;
xlswrite(filename,A,1,cellreference2); %write threshold value of lower part of the image
xrange=[cellreference1,':',cellreference1];
format long;
IMG=strcat(name,'');
xlswrite(filename,{IMG},1,xrange); %writes name of the file

% --- Executes on button press in pushbutton5 - saves the thresholded image
% in axes4

function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global name;
global filename;
global level;
global B;
global cellreference3;
global excelRow;
B=[];
clc
s = strcat(name,'_middle_ocean_thresholded.jpg');
movegui(handles.axes4);
F = getframe(handles.axes4);
Image3 = frame2im(F);
imwrite(Image3, s)
% for i=1:1:100;
B=level;
xlswrite(filename,B,1,cellreference3);

% --- Executes on button press in pushbutton6 - saves the thresholded image
% in axes4
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global name;
global filename;
global level;
global C;
global cellreference4;
global excelRow;
C=[];
clc
s = strcat(name,'_horizon_thresholded.jpg');
movegui(handles.axes4);
F = getframe(handles.axes4);
Image3 = frame2im(F);
imwrite(Image3, s)
C=level;
xlswrite(filename,C,1,cellreference4);


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
