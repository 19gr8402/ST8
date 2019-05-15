function varargout = SelectPosition(varargin)

% Detect callback and execute callback function
if nargin && ischar(varargin{1})
    gui_Callback = str2func(varargin{1});
    feval(gui_Callback,varargin{2:end});
    return
end

% Input arguments
data.Image=varargin{1};
data.shapex=varargin{2};
data.shapey=varargin{3};
data.offsetr=varargin{4};

% Start the figure/gui
handles.figure1=figure;
handles.axes1=axes;

% Show the image
imshow(data.Image,[]); hold on;
title('Select the contour position');

% Make data structure
data.handles=handles;
data.mouse_position=[0 0];
data.mouse_position_last=[0 0];
data.image_position=[0 0];
data.handle_shape=[];

% Set mouse callbackes
set(data.handles.figure1,'WindowButtonMotionFcn','SelectPosition(''figure1_WindowButtonMotionFcn'')');
set(get(data.handles.axes1,'Children'),'ButtonDownFcn','SelectPosition(''axes1_ButtonDownFcn'')');
data.axes_size=2.*get(data.handles.axes1,'PlotBoxAspectRatio');
data.done=false;
setMyData(data);

% Show contour on initial position
showcontour();

while(~data.done), pause(0.1); data=getMyData();  end

% Output arguments
varargout{1}=data.image_position(1);
varargout{2}=data.image_position(2); 
varargout{3}=data.offsetr;

% Close the gui/figure
close(handles.figure1);


function figure1_WindowButtonMotionFcn()
cursor_position_in_axes();
data=getMyData(); if(isempty(data)), return, end
data.image_position=data.mouse_position([2 1]).*[size(data.Image,1) size(data.Image,2)];
setMyData(data); 
showcontour();

function axes1_ButtonDownFcn(handles)
data=getMyData(); 
data.mouse_button=get(data.handles.figure1,'SelectionType');
%disp([data.mouse_button ' click']);
switch(data.mouse_button)
    case 'normal' 
        data.done=true;
    case 'alt'
    % Correct for rotation
    tform.offsetv=[0 0]; tform.offsetr=0.2; data.offsetr=data.offsetr+0.2;
        
    rot = atan2(data.shapey,data.shapex);
    rot = rot-tform.offsetr;
    dist = sqrt(data.shapex.^2+data.shapey.^2);
    % *tform.offsets;
    data.shapex =dist.*cos(rot);
    data.shapey =dist.*sin(rot);
    data.shapex = data.shapex - tform.offsetv(1);
    data.shapey = data.shapey - tform.offsetv(2);
    
    % Show object
    if(ishandle(data.handle_shape)), delete(data.handle_shape); end
    data.handle_shape=plot(data.shapey+data.image_position(2),data.shapex+data.image_position(1),'b.');
    
    case 'extend'
    % Correct for rotation
    tform.offsetv=[0 0]; tform.offsetr=-0.2; data.offsetr=data.offsetr-0.2;
        
    rot = atan2(data.shapey,data.shapex);
    rot = rot-tform.offsetr;
    dist = sqrt(data.shapex.^2+data.shapey.^2);
    % *tform.offsets;
    data.shapex =dist.*cos(rot);
    data.shapey =dist.*sin(rot);
    data.shapex = data.shapex - tform.offsetv(1);
    data.shapey = data.shapey - tform.offsetv(2);
    
    % Show object
    if(ishandle(data.handle_shape)), delete(data.handle_shape); end
    data.handle_shape=plot(data.shapey+data.image_position(2),data.shapex+data.image_position(1),'b.');
    
    otherwise
end
setMyData(data);

% function axes1_ButtonDownFcn()
% data=getMyData(); 
% data.done=true;
% setMyData(data);
        
function cursor_position_in_axes()
data=getMyData(); if(isempty(data)), return, end;
data.mouse_position_last=data.mouse_position;
p = get(data.handles.axes1, 'CurrentPoint');
data.mouse_position=[p(1, 1) p(1, 2)]./data.axes_size(1:2);
setMyData(data);

function showcontour()
data=getMyData(); if(isempty(data)), return, end;

if(ishandle(data.handle_shape)), delete(data.handle_shape); end
data.handle_shape=plot(data.shapey+data.image_position(2),data.shapex+data.image_position(1),'b.');
setMyData(data);


function setMyData(data)
% Store data struct in figure
setappdata(gcf,'data2d',data);

function data=getMyData()
% Get data struct stored in figure
data=getappdata(gcf,'data2d');
