function varargout = ImageEncryptionGui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageEncryptionGui_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageEncryptionGui_OutputFcn, ...
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

function ImageEncryptionGui_OpeningFcn(hObject, eventdata, handles, varargin)


handles.output = hObject;

%BackGr = imread('background.jpg');
%  imshow(BackGr);

guidata(hObject, handles);
clear all;
clc;
global Img;
global EncImg;
global DecImg;

function varargout = ImageEncryptionGui_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


function pushbutton1_Callback(hObject, eventdata, handles)

global Img;
global key;

[cover_fname, cover_pthname] = ...
    uigetfile('*.jpg; *.png; *.tif; *.bmp; *.ppm;*.pgm;', 'Select an Image ');
if (cover_fname ~= 0)
    cover_image = strcat(cover_pthname, cover_fname);
    Img = imread(cover_image);
    axes(handles.axes1)
  imshow(Img);
  
  [n m k] = size(Img);
  key = keyGen(n*m);
   
else
    return;
end



  
guidata(hObject, handles);

function pushbutton2_Callback(hObject, eventdata, handles)
global Img ;
global EncImg; 
global key;
hexkey=dec2hex(key);
dlmwrite ('keytext.txt',hexkey );
disp(hexkey);
EncImg = imageProcess(Img,key);
axes(handles.axes2)
imshow(EncImg);
imwrite(EncImg,'Encrypted_images\Encoded.jpg','jpg');
guidata(hObject, handles);

function pushbutton3_Callback(hObject, eventdata, handles)
global DecImg;
global EncImg;
global key;
DecImg = imageProcess(EncImg,key);
axes(handles.axes3);
imshow(DecImg);
imwrite(DecImg,'Decrypted_images\Decoded.jpg','jpg');
guidata(hObject, handles);


% --- Executes on key press with focus on pushbutton1 and none of its controls.
function pushbutton1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
