function OA = oaxes(hAx,pvPairs)
% Constructor for customplots.oaxes

% $$FileInfo
% $Filename: oaxes.m
% $Path: $toolboxroot/@customplots/@oaxes
% $Product Name: oaxes
% $Product Release: 2.3
% $Revision: 1.0.49
% $Toolbox Name: Custom Plots Toolbox
% $$
%
% Copyright (c) 2010-2011 John Barber.
%

%%

% Create the oaxes
OA = customplots.oaxes('Parent',hAx,'Tag','oaxes');
hG = double(OA);
OA.hAx = hAx;

% Create hggroups to hold x,y and z axis graphics
OA.hX = hggroup('HandleVisibility','on','Parent',hG,'Tag','oaxesXAxis');
OA.hY = hggroup('HandleVisibility','on','Parent',hG,'Tag','oaxesYAxis');
OA.hZ = hggroup('HandleVisibility','on','Parent',hG,'Tag','oaxesZAxis');

% Copy properties from parent axes
OA.XColor = get(hAx,'XColor');
OA.YColor = get(hAx,'YColor');
OA.ZColor = get(hAx,'ZColor');
OA.TickLabelFontAngle = get(hAx,'FontAngle');
OA.TickLabelFontName = get(hAx,'FontName');
OA.TickLabelFontSize = get(hAx,'FontSize');
OA.TickLabelFontUnits = get(hAx,'FontUnits');
OA.TickLabelFontWeight = get(hAx,'FontWeight');

% Create axis labels
axLabelProps = {'HandleVisibility','on',...
                'HitTest','off',...
                'Units','data',...
                'Visible','off',...
                'XLimInclude','off',...
                'YLimInclude','off',...
                'ZLimInclude','off',...
                };

OA.hXLabel = [text('Parent',hG,'Tag','NegativeXAxisLabel',...
                axLabelProps{:});...
              text('Parent',hG,'Tag','PositiveXAxisLabel',...
                axLabelProps{:})];
OA.hYLabel = [text('Parent',hG,'Tag','NegativeYAxisLabel',...
                axLabelProps{:});...
              text('Parent',hG,'Tag','PositiveYAxisLabel',...
                axLabelProps{:})];
OA.hZLabel = [text('Parent',hG,'Tag','NegativeZAxisLabel',...
                axLabelProps{:});...
              text('Parent',hG,'Tag','PositiveZAxisLabel',...
                axLabelProps{:})];

% Store user-specified properties and the object handles that we just got
for k = 1:size(pvPairs,1)
    
    % Make sure the property exists
    p = findprop(OA,pvPairs{k,1});
    if isempty(p)
        wID = 'OAXES:UnknownProperty';
        wStr = ['Unknown property: ''' pvPairs{k,1} '''.'];
        warning(wID,wStr)
        continue
    end

    % Set the property value
    set(OA,pvPairs{k,1},pvPairs{k,2})
end

%% Create the oaxes contents

% Copy axis labels from OA to label objects
set(OA.hXLabel,{'String'},OA.XLabel)
set(OA.hYLabel,{'String'},OA.YLabel)
set(OA.hZLabel,{'String'},OA.ZLabel)

% Initialize text size
OA.methods('calcTextSize',false)

% Draw oaxes contents
OA.draw(false)

% Set parent axes visibility
OA.methods('hideParentAxes')

%% Set up listeners

% Delete function for oaxes
set(OA,'DeleteFcn',@deleteOAxes)

% Delete functions for axis labels
set(OA.hXLabel,'DeleteFcn',{@deleteLabel,'X',OA});
set(OA.hYLabel,'DeleteFcn',{@deleteLabel,'Y',OA});
set(OA.hZLabel,'DeleteFcn',{@deleteLabel,'Z',OA});

% Listener for parent axes redraw event
fh = @drawOAxes;
hL = handle.listener(handle(hAx),'AxisInvalidEvent',{fh,OA});
OA.hParentAxesListeners = hL;

% Internal oaxes property listeners
hL = cell(0,0);
pType = 'PropertyPostSet';

% Set up listeners to redraw entire oaxes
propList = {'Arrow';
            'ArrowAspectRatio';
            'AxisExtend';
            'AxisLines';
            'FlipMargin';
            'Force3D';
            'LineWidth';
            'TickLabelOffset';
            'TickLength';
            'TickOrientation';
            'XLim';
            'YLim';
            'ZLim';
            'XLimMode';
            'YLimMode';
            'ZLimMode';
            'XOrigin';
            'YOrigin';
            'ZOrigin';
            'XOriginMode';
            'YOriginMode';
            'ZOriginMode';
            };
hL = localAddListener(hL,OA,propList,pType,{@drawOAxes,OA});

% Set up listeners to redraw the X/Y/Z axis line
propList = {'XAxisLine'; 'XColor'};
fh = {@oaxesListener,OA,'drawAxis','X'};
hL = localAddListener(hL,OA,propList,pType,fh);

propList = {'YAxisLine'; 'YColor'};
fh = {@oaxesListener,OA,'drawAxis','Y'};
hL = localAddListener(hL,OA,propList,pType,fh);

propList = {'ZAxisLine'; 'ZColor'};
fh = {@oaxesListener,OA,'drawAxis','Z'};
hL = localAddListener(hL,OA,propList,pType,fh);

% Set up listeners to update axis label position and alignment
propList = {'AlwaysShowLabels';
            'AxisLabelLocation';
            'AxisLabelOffset';
            'XLabelHorizontalAlignment';
            'YLabelHorizontalAlignment';
            'ZLabelHorizontalAlignment';
            'XLabelVerticalAlignment';
            'YLabelVerticalAlignment';
            'ZLabelVerticalAlignment';
            };
fh = {@oaxesListener,OA,'drawLabels'};
hL = localAddListener(hL,OA,propList,pType,fh);

% Set up listeners to update axis label text
hL = localAddListener(hL,OA,'XLabel',pType,{@drawLabelString,'X',OA});
hL = localAddListener(hL,OA,'YLabel',pType,{@drawLabelString,'Y',OA});
hL = localAddListener(hL,OA,'ZLabel',pType,{@drawLabelString,'Z',OA});

% Set up listeners for tick properties
propList = {'ExpFontScale';
            'MinorTickLength';
            'MinorTickLineWidth';
            'TickLabelFontAngle';
            'TickLabelFontName';
            'TickLabelFontSize';
            'TickLabelFontUnits';
            'TickLabelFontWeight';
            'TickLabelInterpreter';
            };
fh = {@oaxesListener,OA,'calcTextSize',true};
hL = localAddListener(hL,OA,propList,pType,fh);

% Set up listeners to redraw X/Y/Z ticks
propList = {'XTick'; 'XTickMode'; 'XTickLabel'; 'XTickLabelMode'};
fh = {@oaxesListener,OA,'drawTicks','X'};
hL = localAddListener(hL,OA,propList,pType,fh);

propList = {'YTick'; 'YTickMode'; 'YTickLabel'; 'YTickLabelMode'};
fh = {@oaxesListener,OA,'drawTicks','Y'};
hL = localAddListener(hL,OA,propList,pType,fh);

propList = {'ZTick'; 'ZTickMode'; 'ZTickLabel'; 'ZTickLabelMode'};
fh = {@oaxesListener,OA,'drawTicks','Z'};
hL = localAddListener(hL,OA,propList,pType,fh);

% Set up listeners for parent axes visibility
propList = {'HideParentAxes','HideParentAxesMode'};
fh = {@oaxesListener,OA,'hideParentAxes'};
hL = localAddListener(hL,OA,propList,pType,fh);

% Store internal property listener handles
OA.hInternalListeners = hL;

% Set up listener for 'ListenersEnabled' property
hL = localAddListener(cell(0,0),OA,'ListenersEnabled',pType,...
    @listenerListener);
OA.hListenerListener = hL;

% End of method oaxes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                         Listener functions                            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function deleteLabel(src,eventData,ax,OA) %#ok<INUSL>
% Listener to rebuild labels if someone deletes them

% If the oaxes is being deleted, take no action
if strcmp(OA.BeingDeleted,'on')
    return
end

% Disable listeners
hL = [OA.hParentAxesListeners;
      OA.hInternalListeners];
enableState = get(hL,'Enabled');
set(hL,'Enabled','off')

% Call quasi-private method deleteLabel
OA.methods('deleteLabel',ax,src)

% Set the 'DeleteFcn' property of the new labels
pName = ['h' ax 'Label'];
hLabel = get(OA,pName);
fh = {@deleteLabel,ax,OA};
set(hLabel,'DeleteFcn',fh)

% Reenable listeners
set(hL,{'Enabled'},enableState)

% End of function deleteLabel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function deleteOAxes(src,eventData)  %#ok<INUSD>
% Delete function attached to OAxes to restore parent axes visibility when
% the OAxes is deleted    

OA = handle(src);

% Turn listeners off
set(OA.hParentAxesListeners,'Enabled','off')
set(OA.hInternalListeners,'Enabled','off')

% Restore parent axes visibility
hAx = OA.hAx;

if strcmp(OA.HideParentAxes,'on')
    if strcmp(OA.HideParentAxesMode,'visibility')
        % If we hid axes by making it invisible, reset to visible
        set(hAx,'Visible','on')
    elseif strcmp(OA.HideParentAxesMode,'color')
        % If we hid axes using figure background color, reset the colors
        set(hAx,{'XColor','YColor','ZColor'},OA.parentAxesColors)
    end
end

% End of function deleteOAxes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drawLabelString(src,eventData,ax,OA) %#ok<INUSL>
% Update axis label text in response to changes in OA.X/Y/ZLabel

% Get handles of axis labels
h = get(OA,['h' ax 'Label']);

% Apparently, the original input is passed as eventData.NewValue, not the
% output of the set function.  
str = eventData.NewValue;
if ischar(str)
    str = {str,str};
end

% Copy the new labels to the label text objects
set(h(1),'String',str{1})
set(h(2),'String',str{2})

% End of function drawLabelString
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drawOAxes(src,eventData,OA) %#ok<INUSL>
% Listener for properties that need the entire oaxes to be redrawn

% Call OA.draw
OA.draw(true)

% End of function drawOAxes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function listenerListener(src,eventData) %#ok<INUSL>
% Toggle the 'Enabled' property of oaxes listeners in response to a change
% in the oaxes' 'ListenersEnabled' property

OA = eventData.AffectedObject;

if strcmp(eventData.NewValue,'off')
    % Turn off all axes listeners
    set(OA.hParentAxesListeners,'Enabled','off')
    set(OA.hInternalListeners,'Enabled','off')
else
    
    % Do label strings, parent axes visibility and text size calculations
    % since these aren't done by oaxes.draw
    set(OA.hXLabel,{'String'},OA.XLabel)
    set(OA.hYLabel,{'String'},OA.YLabel)
    set(OA.hZLabel,{'String'},OA.ZLabel)
    OA.methods('hideParentAxes')
    OA.methods('calcTextSize',true)
    
    % Force a redraw of the OAxes
    OA.draw
        
    % Turn on all axes listeners
    set(OA.hParentAxesListeners,'Enabled','on')
    set(OA.hInternalListeners,'Enabled','on')
    
end

% End of function listenerListener
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hL = localAddListener(hL,hObj,propNames,propType,fh)
% Helper function to attach a listener to the specified properties of hObj

if isnumeric(hObj)
    hObj = handle(hObj);
end

if ischar(propNames)
    propH = findprop(hObj,propNames);
elseif iscell(propNames)
    propH = [];
    for k = 1:length(propNames)
        propH = [propH; findprop(hObj,propNames{k})]; %#ok<AGROW>
    end
else
    propH = propNames;
end

try
    h = handle.listener(hObj,propH,propType,fh);
catch  %#ok<CTCH>
    propType = propType(9:end);
    % e.g. 'PropertyPostSet becomes 'PostSet' for older MATLAB versions
    h = handle.listener(hObj,propH,propType,fh);
end

% Append handle to hL
hL = [hL; h];

% End of function localAddListener
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function oaxesListener(src,eventData,OA,method,args) %#ok<INUSL>
% Listener attached to oaxes properties.  Calls the quasi-private method
% specified by 'method', with optional arguments args{:}.

% Disable listeners
hL = [OA.hParentAxesListeners;
      OA.hInternalListeners];
enableState = get(hL,'Enabled');
set(hL,'Enabled','off')

% Call the quasi-private method
if nargin == 5
    OA.methods(method,args)
else
    OA.methods(method)
end

% Reenable listeners
set(hL,{'Enabled'},enableState)

% End of function oaxesListener
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

