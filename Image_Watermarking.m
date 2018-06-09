ifunction varargout = Image_Watermarking(varargin)
% IMAGE_WATERMARKING MATLAB code for Image_Watermarking.fig
%      IMAGE_WATERMARKING, by itself, creates a new IMAGE_WATERMARKING or raises the existing
%      singleton*.
%
%      H = IMAGE_WATERMARKING returns the handle to a new IMAGE_WATERMARKING or the handle to
%      the existing singleton*.
%
%      IMAGE_WATERMARKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGE_WATERMARKING.M with the given input arguments.
%
%      IMAGE_WATERMARKING('Property','Value',...) creates a new IMAGE_WATERMARKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Image_Watermarking_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Image_Watermarking_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Image_Watermarking

% Last Modified by GUIDE v2.5 22-Aug-2017 11:41:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Image_Watermarking_OpeningFcn, ...
                   'gui_OutputFcn',  @Image_Watermarking_OutputFcn, ...
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


% --- Executes just before Image_Watermarking is made visible.
function Image_Watermarking_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Image_Watermarking (see VARARGIN)

% Choose default command line output for Image_Watermarking
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Image_Watermarking wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Image_Watermarking_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

[cover_fname, cover_pthname] = ...
    uigetfile('*.jpg; *.png; *.tif; *.bmp', 'Select the Cover Image');
if (cover_fname ~= 0)
    cover_image = strcat(cover_pthname, cover_fname);
   
else
    return;
end


rgbimage=imread(cover_image);
axes(handles.axes1);
imshow(rgbimage);
title('Original color image');
[h_LL,h_LH,h_HL,h_HH]=dwt2(rgbimage,'haar');
img=h_LL;
red1=img(:,:,1);
green1=img(:,:,2);
blue1=img(:,:,3);
[U_imgr1,S_imgr1,V_imgr1]= svd(red1);
[U_imgg1,S_imgg1,V_imgg1]= svd(green1);
[U_imgb1,S_imgb1,V_imgb1]= svd(blue1);

%watermark

[cover_fname, cover_pthname] = ...
    uigetfile('*.jpg; *.png; *.tif; *.bmp', 'Select the Watermark Image');
if (cover_fname ~= 0)
    watermark_image = strcat(cover_pthname, cover_fname);
   
else
    return;
end

rgbimage=imread(watermark_image);
axes(handles.axes2);
imshow(rgbimage);
title('Watermark image');
[w_LL,w_LH,w_HL,w_HH]=dwt2(rgbimage,'haar');
img_wat=w_LL;
red2=img_wat(:,:,1);
green2=img_wat(:,:,2);
blue2=img_wat(:,:,3);
[U_imgr2,S_imgr2,V_imgr2]= svd(red2);
[U_imgg2,S_imgg2,V_imgg2]= svd(green2);
[U_imgb2,S_imgb2,V_imgb2]= svd(blue2);


% watermarking

S_wimgr=S_imgr1+(0.10*S_imgr2);
S_wimgg=S_imgg1+(0.10*S_imgg2);
S_wimgb=S_imgb1+(0.10*S_imgb2);


wimgr = U_imgr1*S_wimgr*V_imgr1';
wimgg = U_imgg1*S_wimgg*V_imgg1';
wimgb = U_imgb1*S_wimgb*V_imgb1';

wimg=cat(3,wimgr,wimgg,wimgb);
newhost_LL=wimg;

%output

rgb2=idwt2(newhost_LL,h_LH,h_HL,h_HH,'haar');
imwrite(uint8(rgb2),'Watermarked_images\Watermarked.jpg');
axes(handles.axes3);
imshow(uint8(rgb2));title('Watermarked Image');


%watermarked




rgbimage=imread('Watermarked_images\Watermarked.jpg');

[wm_LL,wm_LH,wm_HL,wm_HH]=dwt2(rgbimage,'haar');
img_w=wm_LL;
red3=img_w(:,:,1);
green3=img_w(:,:,2);
blue3=img_w(:,:,3);
[U_imgr3,S_imgr3,V_imgr3]= svd(red3);
[U_imgg3,S_imgg3,V_imgg3]= svd(green3);
[U_imgb3,S_imgb3,V_imgb3]= svd(blue3);



S_ewatr=(S_imgr3-S_imgr1)/0.10;
S_ewatg=(S_imgg3-S_imgg1)/0.10;
S_ewatb=(S_imgb3-S_imgb1)/0.10;

ewatr = U_imgr2*S_ewatr*V_imgr2';
ewatg = U_imgg2*S_ewatg*V_imgg2';
ewatb = U_imgb2*S_ewatb*V_imgb2';

ewat=cat(3,ewatr,ewatg,ewatb);

newwatermark_LL=ewat;

%output

rgb2=idwt2(newwatermark_LL,w_LH,w_HL,w_HH,'haar');
axes(handles.axes4);
imshow(uint8(rgb2));
imwrite(uint8(rgb2),'Extracted_watermarks\EWatermark.jpg');title('Extracted Watermark');
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
