function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 08-Feb-2022 22:14:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
clc
cargarInteligencias;
%%
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;
%abrir cámara
objects=imaqfind();
delete(objects);
axes(handles.axes1);
axis off;
axes(handles.axes2);
axis off;
axes(handles.axes1);
handles.camara = videoinput('winvideo',1);
set(handles.camara,'ReturnedColorspace','rgb');
resolucion=get(handles.camara,'VideoResolution');
nB=get(handles.camara,'NumberofBands');
hImagen=image(zeros(resolucion (2), resolucion(1), nB), 'Parent',...  
    handles.axes1);
preview(handles.camara,hImagen);
% Update handles structure
guidata(hObject, handles);




% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ann.
function ann_Callback(hObject, eventdata, handles)
global foto;
axes (handles.axes2)
data = foto;
imagen = imsubtract (data(:,:,1), rgb2gray(data));
imagen = medfilt2 (imagen, [3 3]);
imagen = imbinarize(imagen,0.1);
imagen = bwareaopen(imagen, 300);
b=bwlabel(imagen,8);
region = regionprops(b,'Area', 'centroid', 'BoundingBox');
areaMaxima=max([region.Area]);
indices = find([region.Area]==areaMaxima);
valores = region(indices,1).BoundingBox;
imagenRecortada = imcrop(data,valores);
map = rgb2gray(imagenRecortada);
imagenAdaptada = imresize(map,[28,28]);
imagenBinaria=im2bw(imagenAdaptada);
nuevaImagen=imcomplement(imagenBinaria);
imshow(nuevaImagen)
x = reshape(nuevaImagen,1,[]);


xData = cast(x,'double');
yPredicha = myNeuralNetworkFunctionANN(xData);
[dx,class]=max(yPredicha);
yPredicha=class-1;
set(handles.texto_predicho,'String',int2str(yPredicha));
% hObject    handle to ann (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in tomar_foto.
function tomar_foto_Callback(hObject, eventdata, handles)
global foto;
foto = getsnapshot(handles.camara);
axes(handles.axes2)
imshow(foto)
% hObject    handle to tomar_foto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in knn_button.
function knn_button_Callback(hObject, eventdata, handles)

global foto;
axes (handles.axes2)
data = foto;
imagen = imsubtract (data(:,:,1), rgb2gray(data));
imagen = medfilt2 (imagen, [3 3]);
imagen = imbinarize(imagen,0.1);
imagen = bwareaopen(imagen, 300);
b=bwlabel(imagen,8);
region = regionprops(b,'Area', 'centroid', 'BoundingBox');
areaMaxima=max([region.Area]);
indices = find([region.Area]==areaMaxima);
valores = region(indices,1).BoundingBox;
imagenRecortada = imcrop(data,valores);
map = rgb2gray(imagenRecortada);
imagenAdaptada = imresize(map,[28,28]);
imagenBinaria=im2bw(imagenAdaptada);
nuevaImagen=imcomplement(imagenBinaria);
imshow(nuevaImagen)
x = reshape(nuevaImagen,1,[]);

xData = cast(x,'double');
global knn;
yPredicha = knn.predictFcn(xData);
set(handles.texto_predicho,'String',int2str(yPredicha));
% hObject    handle to knn_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in arbol.
function arbol_Callback(hObject, eventdata, handles)
global foto;
axes (handles.axes2)
data = foto;
imagen = imsubtract (data(:,:,1), rgb2gray(data));
imagen = medfilt2 (imagen, [3 3]);
imagen = imbinarize(imagen,0.1);
imagen = bwareaopen(imagen, 300);
b=bwlabel(imagen,8);
region = regionprops(b,'Area', 'centroid', 'BoundingBox');
areaMaxima=max([region.Area]);
indices = find([region.Area]==areaMaxima);
valores = region(indices,1).BoundingBox;
imagenRecortada = imcrop(data,valores);
map = rgb2gray(imagenRecortada);
imagenAdaptada = imresize(map,[28,28]);
imagenBinaria=im2bw(imagenAdaptada);
nuevaImagen=imcomplement(imagenBinaria);
imshow(nuevaImagen)
x = reshape(nuevaImagen,1,[]);

xData = cast(x,'double');
global tree;
yPredicha = tree.predictFcn(xData);
set(handles.texto_predicho,'String',int2str(yPredicha));
% hObject    handle to arbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
