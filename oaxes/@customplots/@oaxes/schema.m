function schema
% Class definition for customplots.oaxes class

% $$FileInfo
% $Filename: schema.m
% $Path: $toolboxroot/@customplots/@oaxes/
% $Product Name: oaxes
% $Product Release: 2.3
% $Revision: 1.0.20
% $Toolbox Name: Custom Plots Toolbox
% $$
%
% Copyright (c) 2010-2011 John Barber.
%

%% Define class
pkg = findpackage('customplots');
hgPkg = findpackage('hg');

h = schema.class(pkg,'oaxes',hgPkg.findclass('hggroup'));

%% Define enumerated lists

% Define allowed values for Arrow
if isempty(findtype('oaxesArrowType'))
    schema.EnumType('oaxesArrowType',{'end','extend','off'});
end

% Define auto/manual modes
if isempty(findtype('oaxesAutoManualType'))
    schema.EnumType('oaxesAutoManualType',{'auto','manual'});
end

% Define allowed values for AxisLabelLocation
if isempty(findtype('oaxesAxisLabelLocationType'))
    schema.EnumType('oaxesAxisLabelLocationType',{'end','side'});
end

% Define allowed values for X/Y/ZLimMode
if isempty(findtype('oaxesLimModeType'))
    schema.EnumType('oaxesLimModeType',{'auto','extend','manual'});
end

% Define allowed values for ParentAxesHideMode
if isempty(findtype('oaxesParentAxesHideModeType'))
    schema.EnumType('oaxesParentAxesHideModeType',{'visibility','color'});
end

% Define allowed values for X/Y/ZTickMode
if isempty(findtype('oaxesTickModeType'))
    schema.EnumType('oaxesTickModeType',{'parent','auto','manual','off'});
end

% Define allowed values for X/Y/ZTickLabelMode
if isempty(findtype('oaxesTickLabelModeType'))
    schema.EnumType('oaxesTickLabelModeType',{'auto','manual','off'});
end

% Define allowed values for OA.TickOrientation
if isempty(findtype('oaxesTickOrientationType'))
    tickOrientations = {'auto','yxx','yzx','yxy','yzy',...
                        'zxx','zzx','zxy','zzy'};
    schema.EnumType('oaxesTickOrientationType',tickOrientations);
end

%% Set up property attributes
% {Visible,AbortSet,Init,Listener,PublicGet,PublicSet,Reset};

% Default property options 
defOpts = {'on','on','on','on','on','on','on'};

% Property options list for non-abort-set properties
forceSetOpts = {'on','off','on','on','on','on','on'};

% Property options list for non-reset properties
noResetOpts = {'on','off','off','on','on','on','off'};

% Property options list for hidden properties
hiddenOpts = {'off','on','on','on','on','on','on'};

% Visible read only, no Init/Reset/Listener
visROOpts = {'on','on','off','off','on','off','off'};

% Hidden, read only, no Init/Reset/Listener
hidROOpts = {'off','on','off','off','on','off','off'};

% Private, transient: no Init/Reset/Listener
pvtOpts = {'off','on','off','off','off','off','off'};


%% Master property list
% Format: 
% {PropertyName,dataType,setFcn,getFcn,options,FactoryValue}

propList = { 

    % Public properties   
    'Arrow','oaxesArrowType',[],[],defOpts,'end';
    'ArrowAspectRatio','double',[],[],defOpts,2.0;
    'AxisExtend','double',[],[],defOpts,0.75;
    'AxisLabelLocation','oaxesAxisLabelLocationType',[],[],...
        defOpts,'end';
    'AxisLabelOffset','double',[],[],defOpts,3;
    'HideParentAxes','on/off',[],[],defOpts,'on';
    'HideParentAxesMode','oaxesParentAxesHideModeType',[],[],defOpts,...
        'visibility';
    'hXLabel','handle vector',[],[],visROOpts,[];
    'hYLabel','handle vector',[],[],visROOpts,[];
    'hZLabel','handle vector',[],[],visROOpts,[];
    'LineWidth','double',[],[],defOpts,1.5;
    'ListenersEnabled','on/off',[],[],defOpts,'on';
    'Origin','mxArray',@setOrigin,@getOrigin,forceSetOpts,[NaN NaN NaN]; 
    'OriginMode','mxArray',@setOriginMode,@getOriginMode,defOpts,'auto';
    'TickLabelFontAngle','string',[],[],noResetOpts,'';
    'TickLabelFontName','string',[],[],noResetOpts,'';
    'TickLabelFontSize','NReals',[],[],noResetOpts,[];
    'TickLabelFontUnits','string',[],[],noResetOpts,'';
    'TickLabelFontWeight','string',[],[],noResetOpts,'';
    'TickLabelInterpreter','string',[],[],defOpts,'tex';
    'TickLabelOffset','double',[],[],defOpts,1.4;
    'TickLength','NReals',@setTickLength,[],defOpts,[6 8];
    'TickOrientation','oaxesTickOrientationType',[],[],defOpts,'auto';
    'Title','mxArray',@setTitle,@getTitle,noResetOpts,'';
    'XAxisLine','on/off',[],[],defOpts,'on';
    'YAxisLine','on/off',[],[],defOpts,'on';
    'ZAxisLine','on/off',[],[],defOpts,'on';
    'XColor','mxArray',[],[],noResetOpts,'b'; 
    'YColor','mxArray',[],[],noResetOpts,[0 .5 0];
    'ZColor','mxArray',[],[],noResetOpts,'r';
    'XLabel','mxArray',{@setLabel,'X'},[],defOpts,...
        {'\it{-x}';'\it{x}'};
    'YLabel','mxArray',{@setLabel,'Y'},[],defOpts,...
        {'\it{-y}';'\it{y}'};
    'ZLabel','mxArray',{@setLabel,'Z'},[],defOpts,...
        {'\it{-z}';'\it{z}'};
    'XLabelHorizontalAlignment','mxArray',{@setLabelAlignment,...
        'X','Horizontal'},[],defOpts,{'auto','auto'};
    'YLabelHorizontalAlignment','mxArray',{@setLabelAlignment,...
        'Y','Horizontal'},[],defOpts,{'auto','auto'};
    'ZLabelHorizontalAlignment','mxArray',{@setLabelAlignment,...
        'Z','Horizontal'},[],defOpts,{'auto','auto'};
    'XLabelVerticalAlignment','mxArray',{@setLabelAlignment,...
        'X','Vertical'},[],defOpts,{'auto','auto'};
    'YLabelVerticalAlignment','mxArray',{@setLabelAlignment,...
        'Y','Vertical'},[],defOpts,{'auto','auto'};
    'ZLabelVerticalAlignment','mxArray',{@setLabelAlignment,...
        'Z','Vertical'},[],defOpts,{'auto','auto'};
    'XLim','mxArray',{@setLim,'X'},{@getLim,'X'},forceSetOpts,[-Inf Inf];
    'YLim','mxArray',{@setLim,'Y'},{@getLim,'Y'},forceSetOpts,[-Inf Inf];
    'ZLim','mxArray',{@setLim,'Z'},{@getLim,'Z'},forceSetOpts,[-Inf Inf];
    'XLimMode','oaxesLimModeType',{@setLimMode,'X'},[],defOpts,...
        'auto';
    'YLimMode','oaxesLimModeType',{@setLimMode,'Y'},[],defOpts,...
        'auto';
    'ZLimMode','oaxesLimModeType',{@setLimMode,'Z'},[],defOpts,...
        'auto';
    'XOrigin','double',{@setAxOrigin,'X'},{@getAxOrigin,'X'},...
        forceSetOpts,0;
    'YOrigin','double',{@setAxOrigin,'Y'},{@getAxOrigin,'Y'},...
        forceSetOpts,0;
    'ZOrigin','double',{@setAxOrigin,'Z'},{@getAxOrigin,'Z'},...
        forceSetOpts,0;
    'XOriginMode','oaxesAutoManualType',[],[],defOpts,'auto';  
    'YOriginMode','oaxesAutoManualType',[],[],defOpts,'auto';
    'ZOriginMode','oaxesAutoManualType',[],[],defOpts,'auto';
    'XTick','NReals',{@setTick,'X'},{@getTick,'X'},forceSetOpts,[];
    'YTick','NReals',{@setTick,'Y'},{@getTick,'Y'},forceSetOpts,[];
    'ZTick','NReals',{@setTick,'Z'},{@getTick,'Z'},forceSetOpts,[];
    'XTickMode','oaxesTickModeType',{@setTickMode,'X'},[],defOpts,...
        'parent';
    'YTickMode','oaxesTickModeType',{@setTickMode,'X'},[],defOpts,...
        'parent';
    'ZTickMode','oaxesTickModeType',{@setTickMode,'X'},[],defOpts,...
        'parent';
    'XTickLabel','mxArray',{@setTickLabel,'X'},{@getTickLabel,'X'},...
        forceSetOpts,[];
    'YTickLabel','mxArray',{@setTickLabel,'Y'},{@getTickLabel,'Y'},...
        forceSetOpts,[];
    'ZTickLabel','mxArray',{@setTickLabel,'Z'},{@getTickLabel,'Z'},...
        forceSetOpts,[];    
    'XTickLabelMode','oaxesTickModeType',[],[],defOpts,'auto';
    'YTickLabelMode','oaxesTickModeType',[],[],defOpts,'auto';
    'ZTickLabelMode','oaxesTickModeType',[],[],defOpts,'auto';    
    
    % Undocumented properties
    'AlwaysShowLabels','on/off',[],[],hiddenOpts,'off';
    'AxisLines','mxArray',@setAxisLines,@getAxisLines,hiddenOpts,true(1,3);
    'ExpFontScale','double',[],[],hiddenOpts,0.7;
    'FlipMargin','double',[],[],hiddenOpts,0.10;
    'Force3D','on/off',[],[],hiddenOpts,'off';
    'MinorTickLength','double',[],[],hiddenOpts,0.5;
    'MinorTickLineWidth','double',[],[],hiddenOpts,0.5;
        
    % Internal mirror properties
    'OI','mxArray',[],[],hiddenOpts,[NaN NaN NaN];
    'TickLengthI','mxArray',[],[],hiddenOpts,[];
    'XLimI','mxArray',[],[],hiddenOpts,[-Inf Inf];
    'YLimI','mxArray',[],[],hiddenOpts,[-Inf Inf];
    'ZLimI','mxArray',[],[],hiddenOpts,[-Inf Inf];
    'XOriginI','mxArray',[],[],hiddenOpts,NaN;
    'YOriginI','mxArray',[],[],hiddenOpts,NaN;
    'ZOriginI','mxArray',[],[],hiddenOpts,NaN;
    'XTickI','mxArray',[],[],hiddenOpts,[];
    'YTickI','mxArray',[],[],hiddenOpts,[];
    'ZTickI','mxArray',[],[],hiddenOpts,[];
    'XTickLabelI','mxArray',[],[],hiddenOpts,[];
    'YTickLabelI','mxArray',[],[],hiddenOpts,[];
    'ZTickLabelI','mxArray',[],[],hiddenOpts,[];

    % Handle lists
    'hX','handle',[],[],hidROOpts,[];
    'hY','handle',[],[],hidROOpts,[];
    'hZ','handle',[],[],hidROOpts,[];
    'hAx','handle',[],[],hidROOpts,[];
    'hXLine','handle vector',[],[],hidROOpts,[];
    'hYLine','handle vector',[],[],hidROOpts,[];
    'hZLine','handle vector',[],[],hidROOpts,[];
    'hXMinorTick','handle vector',[],[],hidROOpts,[];
    'hYMinorTick','handle vector',[],[],hidROOpts,[];
    'hZMinorTick','handle vector',[],[],hidROOpts,[];    
    'hXTick','handle vector',[],[],hidROOpts,[];
    'hYTick','handle vector',[],[],hidROOpts,[];
    'hZTick','handle vector',[],[],hidROOpts,[];
    'hXTickLabel','handle vector',[],[],hidROOpts,[];
    'hYTickLabel','handle vector',[],[],hidROOpts,[];
    'hZTickLabel','handle vector',[],[],hidROOpts,[];
    'hListenerListener','handle',[],[],hidROOpts,[];
    'hInternalListeners','handle vector',[],[],hidROOpts,[];
    'hParentAxesListeners','handle vector',[],[],hidROOpts,[];
       
    % Internal state variables
    'aEnds','mxArray',[],[],pvtOpts,[];
    'axDir','mxArray',[],[],pvtOpts,[];
    'axHA','mxArray',[],[],pvtOpts,[];
    'axVA','mxArray',[],[],pvtOpts,[];
    'cLims','mxArray',[],[],pvtOpts,[];
    'clip','mxArray',[],[],pvtOpts,[];
    'clipC','mxArray',[],[],pvtOpts,[];
    'clipMask','mxArray',[],[],pvtOpts,[];
    'd2px','mxArray',[],[],pvtOpts,[];
    'd2pxL','mxArray',[],[],pvtOpts,[];
    'flipC','mxArray',[],[],pvtOpts,[];
    'hDir','mxArray',[],[],pvtOpts,[];
    'hv','mxArray',[],[],pvtOpts,[];
    'hvC','mxArray',[],[],pvtOpts,[];
    'ijk','mxArray',[],[],pvtOpts,[];
    'ijkCIdx','mxArray',[],[],pvtOpts,[];
    'labelDir','mxArray',[],[],pvtOpts,[];
    'limsC','mxArray',[],[],pvtOpts,[];
    'logScale','mxArray',[],[],pvtOpts,[];
    'logScaleC','mxArray',[],[],pvtOpts,[];
    'OC','mxArray',[],[],pvtOpts,[];
    'Op','mxArray',[],[],pvtOpts,[];
    'oLims','mxArray',[],[],pvtOpts,[];
    'parentAxesColors','mxArray',[],[],pvtOpts,[];
    'pLims','mxArray',[],[],pvtOpts,[];
    'rT','mxArray',[],[],pvtOpts,[];
    'sf','mxArray',[],[],pvtOpts,[];
    'T','mxArray',[],[],pvtOpts,[];
    'tickEnds','mxArray',[],[],pvtOpts,[];
    'tickHA','mxArray',[],[],pvtOpts,[];
    'tickLabelPos','mxArray',[],[],pvtOpts,[];
    'tickLabelTextHeight','mxArray',[],[],pvtOpts,[];
    'tickLabelTextWidth','mxArray',[],[],pvtOpts,[];
    'tickVA','mxArray',[],[],pvtOpts,[];
    'vDir','mxArray',[],[],pvtOpts,[];
    'visibleAxes','mxArray',[],[],pvtOpts,[];
    'xyz','mxArray',[],[],pvtOpts,[];
    'xyzC','mxArray',[],[],pvtOpts,[];
    };

% Define all properties
for k = 1:size(propList,1)
       
    % Create the property
    p = schema.prop(h,propList{k,1},propList{k,2});
    
    % Define set/get functions
    p.SetFunction = propList{k,3};
    p.GetFunction = propList{k,4};
   
    % Property attributes
    p.Visible = propList{k,5}{1};

    p.AccessFlags.AbortSet = propList{k,5}{2};
    p.AccessFlags.Init = propList{k,5}{3};
    p.AccessFlags.Listener = propList{k,5}{4};
    p.AccessFlags.PublicGet = propList{k,5}{5};
    p.AccessFlags.PublicSet = propList{k,5}{6};
    p.AccessFlags.Reset = propList{k,5}{7};
    
    p.FactoryValue = propList{k,6};
    
end

% End of function schema
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                         Set/Get Functions                             %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function AxisLines = getAxisLines(obj,val) %#ok<INUSD>
% Get dependent property AxisLines
AxisLines = strcmp('on',{obj.XAxisLine obj.YAxisLine obj.ZAxisLine});

% End of function getAxisLines
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function AxOrigin = getAxOrigin(obj,val,ax) %#ok<INUSL>
% Returns either OI(axis) if (ax)OriginMode is 'auto', or (ax)OriginI.

OI = obj.OI;
if isempty(OI)
    OI = [NaN NaN NaN];
end

switch ax
    case 'X'
        if strcmp(obj.XOriginMode,'auto')
            AxOrigin = OI(1);
        else
            AxOrigin = obj.XOriginI;
        end
    case 'Y'
        if strcmp(obj.YOriginMode,'auto')
            AxOrigin = OI(2);
        else
            AxOrigin = obj.YOriginI;
        end
    case 'Z'
        if strcmp(obj.ZOriginMode,'auto')
            AxOrigin = OI(3);
        else
            AxOrigin = obj.ZOriginI;
        end
end

% End of function getAxOrigin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Lim = getLim(obj,val,ax) %#ok<INUSL>
% Get function for oaxes.X/Y/ZLim properties.  Returns the value if
% X/Y/ZLimMode is 'manual', or returns oaxes.oLims(axis)

if strcmp(get(obj,[ax 'LimMode']),'manual')
    Lim = get(obj,[ax 'LimI']);
else
    lims = obj.methods('getPrivate','oLims');
    if strcmp(ax,'X')
        Lim = lims(:,1)';
    elseif strcmp(ax,'Y')
        Lim = lims(:,2)';
    elseif strcmp(ax,'Z')
        Lim = lims(:,3)';
    end
end

% End of function getLim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Origin = getOrigin(obj,val)  %#ok<INUSD>
% Get function for the oaxes.Origin property.  Returns a 3x1 vector
% containing OI for axes whose X/Y/ZOriginMode is 'auto', or X/Y/ZOrigin
% for axes whose X/Y/ZOriginMode is 'manual'. 

Origin = [obj.XOrigin obj.YOrigin obj.ZOrigin];

% End of function getOrigin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function OriginMode = getOriginMode(obj,val) %#ok<INUSD>
% OriginMode is a dependent property that aggregates the X/Y/ZOriginMode
% properties.  The get function simply returns the three individual axis
% OriginModes.

OriginMode = {obj.XOriginMode obj.YOriginMode obj.ZOriginMode};

% End of function getOrigin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Tick = getTick(obj,val,ax) %#ok<INUSL>
% Get function for oaxes X/Y/ZTick property.  Returns X/Y/ZTickI.
pName = [ax 'TickI'];
Tick = get(obj,pName);

% End of function getTick
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function TickLabel = getTickLabel(obj,val,ax) %#ok<INUSL>
% Get function for oaxes X/Y/ZTickLabel property.  Returns X/Y/ZTickLabelI.

pName = [ax 'TickLabelI'];
TickLabel = get(obj,pName);

% End of function getTickLabel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Title = getTitle(obj,val) %#ok<INUSD>
% Get function for dependent property Title.  Returns the parent axes'
% title string.
Title = get(get(obj.hAx,'Title'),'String');

% End of function getTitle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function AxisLines = setAxisLines(obj,val)
% Set function for dependent property AxisLines.  Sets X/Y/ZAxisLine
% properties.

eID = 'OAXES:InvalidAxisLines';
eStr = 'AxisLines must be ''on'', ''off'', or a 3x1 cell array.';

if islogical(val)
    tmp = cell(size(val));
    tmp(val) = {'on'};
    tmp(~val) = {'off'};
    val = tmp;
elseif ischar(val) && size(val,1) == 1
    val = {val};
elseif ~iscell(val)
    error(eID,eStr)
end

if all(size(val) == [1 3])
    % noop
elseif all(size(val) == [3 1])
    val = val';
elseif all(size(val) == [1 1])
    val = [val val val];
else
    error(eID,eStr)
end

val = lower(val);

isValid = cellfun(@(x)(any(strcmp(x,{'on','off'}))),val);
if ~all(isValid)
    error(eID,eStr)
end

AxisLines = val;

obj.XAxisLine = val{1};
obj.YAxisLine = val{2};
obj.ZAxisLine = val{3};

% End of function setAxisLines
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function AxOrigin = setAxOrigin(obj,val,ax)
% Set X/Y/ZOrigin and set X/Y/ZOriginMode to 'manual'
AxOrigin = val;

% Store in X/Y/ZOriginI
pName = [ax 'OriginI'];
set(obj,pName,val)

% Set X/Y/ZOriginMode
pName = [ax 'OriginMode'];
set(obj,pName,'manual')    

% End of function setAxOrigin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Label = setLabel(obj,val,ax) %#ok<INUSL>
% Sets the X/Y/ZLabel property

eID = 'OAXES:InvalidPropertyValue';
eStr = [ax 'Label must be a 2x1 cell array of strings'];

if isempty(val)
    val = {'',''};
elseif ischar(val)
    if size(val,1) == 1
        val = repmat(cellstr(val),1,2);
    else
        error(eID,eStr)
    end
elseif iscell(val)
    if all(size(val) == [1 2]) 
        val = val';
    elseif all(size(val) == [2 1])
        % noop
    else
        error(eID,eStr)
    end
    
    idx = cellfun(@(x)(ischar(x)|isempty(x)),val);
    if ~all(idx)
        error(eID,eStr)
    end
else
    error(eID,eStr)
end

Label = val;

% End of function setLabel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function AL = setLabelAlignment(obj,val,ax,hv) %#ok<INUSL>
% Sets the [X/Y/Z]Label[Horizontal/Vertical]Alignment property

eID = 'OAXES:InvalidProperty';
eStr = [ax 'Label' hv 'Alignment must be a 1x2 cell array'];

if isempty(val) || isnumeric(val)
    error(eID,eStr)
end

if ischar(val)
    if size(val,1) == 1
        val = repmat(cellstr(val),1,2);
    else
        error(eID,eStr)
    end
elseif iscell(val)
    if all(size(val) == [1 2]) 
        % noop
    elseif all(size(val) == [2 1])
        val = val';
    else
        error(eID,eStr)
    end
else
    error(eID,eStr)
end

val = lower(val);

if strcmp(hv(1),'H')
    list = {'auto','center','left','right'};
else
    list = {'auto','baseline','bottom','cap','middle','top'};
end

isValid = cellfun(@(x)(any(strcmp(x,list))),val);
if ~all(isValid)
    listStr = '';
    for k = 1:length(list)-1
        listStr = [listStr list{k} ', ' ]; %#ok<AGROW>
    end
    listStr = [listStr list{end}];
    eStr = ['Values for ' ax 'Label' hv 'Alignment must be ' ...
            'one of: ' listStr '.'];
    error(eID,eStr)
end

AL = val;

% End of function setLabelAlignment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Lim = setLim(obj,val,ax)
% Sets the X/Y/ZLim property and sets the corresponding X/Y/ZLimMode to
% 'manual'.

% Validate input
if isempty(val) || ~isnumeric(val) || ~isreal(val) || ...
   ~all(size(val) == [1 2]) || val(1) >= val(2)
    eID = 'OAXES:InvalidLimits';
    eStr = [ax 'Lim must be a 1x2 vector with ' ax 'Lim(1) > ' ...
            ax 'Lim(2).'];
    error(eID,eStr)
end

Lim = val;

% Set X/Y/ZLimI to the value of X/Y/ZLim
pName = [ax 'LimI'];
set(obj,pName,val);

% Set X/Y/ZLimMode to 'manual'
pName = [ax 'LimMode'];
set(obj,pName,'manual');

% End of function setLim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LimMode = setLimMode(obj,val,ax)
% Set function for X/Y/ZLimMode.  If val='auto', sets X/Y/ZLimI to [-Inf
% Inf].

LimMode = val;

if strcmp(val,'auto')
    pName = [ax 'LimI'];
    set(obj,pName,[-Inf Inf]); 
end

% End of function setLimMode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Origin = setOrigin(obj,val)
% Set function for the dependent Origin property
% Where Origin is NaN, set the X/Y/ZOriginMode to 'auto'.  Where Origin is
% a number, set the X/Y/ZOrigin property to that value, which will trigger
% a change of its X/Y/ZOriginMode to 'manual'.

% Validate input
if isempty(val) || ~isnumeric(val) || ~isreal(val) || ...
   ~all(size(val) == [1 3])
    eID = 'OAXES:InvalidOrigin';
    eStr = 'Origin must be a 1x3 real vector.';
    error(eID,eStr)
end

Origin = val;

if ~isnan(val(1))
    obj.XOrigin = val(1);
else
    obj.XOriginMode = 'auto';
end

if ~isnan(val(2))
    obj.YOrigin = val(2);
else
    obj.YOriginMode = 'auto';
end

if ~isnan(val(3))
    obj.ZOrigin = val(3);
else
    obj.ZOriginMode = 'auto';
end

% End of function setOrigin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function OriginMode = setOriginMode(obj,val)
% OriginMode is a dependent property that aggregates the X/Y/ZOriginMode
% properties.  The set function for OriginMode sets the individual
% X/Y/ZOriginMode properties to the value or values specified.

eID = 'OAXES:InvalidOriginMode';
eStr = ['OriginMode must be ''auto'', ''manual'', or a 1x3 cell array' ...
        'containing ''auto'' or ''manual'' in each cell.'];

% Validate input
if isempty(val) || isnumeric(val) || islogical(val)
    error(eID,eStr)
end

% Handle char input
if ischar(val) 
    if size(val,1) == 1
        val = cellstr(val);
    else
        error(eID,eStr)
    end
end

% Validate size
if all(size(val) == [1 1])
    val = repmat(val,1,3);
elseif all(size(val) == [1 3])
    % noop
elseif all(size(val) == [3 1])
    val = val';
else
    error(eID,eStr)
end

% Validate contents
val = strtrim(lower(val));
isValid = all(cellfun(@(x)(any(strcmp(x,{'auto','manual'}))),val));
if ~isValid
    error(eID,eStr);
end

obj.XOriginMode = val{1};
obj.YOriginMode = val{2};
obj.ZOriginMode = val{3};

OriginMode = val;

% End of function setOriginMode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Tick = setTick(obj,val,ax)
% Sets X/Y/ZTickI and sets X/Y/ZTickMode to 'manual'

Tick = val;

% Store in X/Y/ZTickI
pName = [ax 'TickI'];
set(obj,pName,val)

% Set X/Y/ZTickMode
pName = [ax 'TickMode'];
set(obj,pName,'manual')

% End of function setTick
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function TickLabel = setTickLabel(obj,val,ax)
% Sets X/Y/ZTickLabelI and sets X/Y/ZTickLabelMode to 'manual'

eID = 'OAXES:InvalidTickLabel';
eStr = ['Invalid ' ax 'TickLabel.'];

% Validate different input types
if isempty(val)
    val = {''};
elseif isnumeric(val)
    if min(size(val)) > 1
        error(eID,eStr)
    elseif size(val,1) > 1
        val = val';
    end
    val = strtrim(cellstr(num2str(val','%g')))';
elseif ischar(val)
    val = strtrim(cellstr(val))';
elseif iscell(val)
    if min(size(val)) > 1
        error(eID,eStr)
    elseif size(val,1) > 1
        val = val';
    end
    isValid = cellfun(@ischar,val);
    if ~all(isValid)
        error(eID,eStr)
    end
else
    error(eID,eStr)
end

TickLabel = val;

% Store in X/Y/ZTickI
pName = [ax 'TickLabelI'];
set(obj,pName,val)

% Set X/Y/ZTickMode
pName = [ax 'TickLabelMode'];
set(obj,pName,'manual')    

% End of function setTickLabel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function TickLength = setTickLength(obj,val) %#ok<INUSL>
% Set function for TickLength

if all(size(val) == [1 1])
    val = [val val];
elseif ~all(size(val) == [1 2])
    eID = 'OAXES:InvalidTickLength';
    eStr = 'TickLength must be a 1x2 vector';
    error(eID,eStr)
end

if any(val <= 0)
    eID = 'OAXES:InvalidTickLength';
    eStr = 'TickLength must be greater than 0.';
    error(eID,eStr)
end

TickLength = val;

% End of function setTickLength
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function TickMode = setTickMode(obj,val,ax) %#ok<INUSL>
% Set function for X/Y/ZTickMode.  Checks for existence of calcticks,
% needed for 'auto' mode.

if strcmp(val,'auto') && ~(exist('calcticks.m','file') == 2)
    wID = 'OAXES:CalcticksNotFound';
    wStr = ['''calcticks.m'' is required for ''auto'' ' ax 'TickMode '...
            'but was not found. ' ax 'TickMode will be set to '...
            '''parent''.'];
    warning(wID,wStr)
    TickMode = 'parent';
else
    TickMode = val;
end

% End of function setTickMode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Title = setTitle(obj,val)
% Set function for dependent property Title.  Sets the parent axes' title
% string to val.
set(get(obj.hAx,'Title'),'String',val)
Title = val;

% End of function setTitle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
