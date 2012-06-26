function val = methods(obj,fun,varargin)
% METHODS - List methods for customplots.oaxes

% Allows quasi-private methods to be implemented by calling:
% obj.methods('methodName',args).  The quasi-private methods can be
% subfunctions of methods.m or in @obj\private.  Since methods.m is called
% as a method of obj, it has access to private properties, etc. of obj.

% $$FileInfo
% $Filename: methods.m
% $Path: $toolboxroot/@customplots/@oaxes/
% $Product Name: oaxes
% $Product Release: 2.3
% $Revision: 1.0.15
% $Toolbox Name: Custom Plots Toolbox
% $$
%
% Copyright (c) 2010-2011 John Barber.
%

%%
% If called with one argument, this is a obj.methods call.  Return a list
% of methods.
if nargin==1
    cls = obj.classhandle;
    m = get(cls,'Methods');
    val = get(m,'Name');
    return;
end

% Otherwise, evaluate the function specified in fun using the arguments
% in varargin.
switch fun
    case 'calcTextSize'
        calcTextSize(obj,varargin{:})
    case 'deleteLabel'
        deleteLabel(obj,varargin{:})
    case 'drawAxis'
        drawAxis(obj,varargin{:})
    case 'drawLabels'
        drawLabels(obj)
    case 'drawTicks'
        drawTicks(obj,varargin{:})
    case 'getPrivate'
        val = getPrivate(obj,varargin{:});
    case 'hideParentAxes'
        hideParentAxes(obj)
    case 'setPrivate'
        setPrivate(obj,varargin{:});
    otherwise
        if nargout == 1
            val = [];
        end
        return
end

% End of function methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function calcTextSize(OA,listenerMode) 
% Determine tick label text size and call drawTicks for each axis

% Determine text size in pixels for tick labels.  Use the undocumented
% 'PixelBounds' text property because it works with 3D views, unlike
% 'Extent'. 

if any(strcmp('auto',{OA.XTickMode,OA.YTickMode,OA.ZTickMode}))
    
    % Try to use an invisible color to avoid flicker
    color = get(OA.hAx,'Color');
    if strcmp(color,'none')
        color = get(get(OA.hAx,'Parent'),'Color');
        if strcmp(color,'none')
            color = 'w';
        end
    end

    % Draw the text and get its pixel bounds
    h = text('Units','pixels',...
             'BackgroundColor','none',...
             'Color',color,...
             'Parent',double(OA.hAx),...
             'String','2',...
             'FontUnits',OA.TickLabelFontUnits,...
             'FontAngle',OA.TickLabelFontAngle,...
             'FontName',OA.TickLabelFontName,...
             'FontSize',OA.TickLabelFontSize,...
             'FontWeight',OA.TickLabelFontWeight);
    set(h,'Units','pixels','Margin',0.01)   
    drawnow expose
    pb = get(h,'PixelBounds');
    delete(h)

    % Text height
    OA.tickLabelTextHeight = pb(4) - pb(2);

    % Shrink width when using a proportional font to account for kerning.
    % Subtract 4 pixels to get equivalent results compared to 'Extent'.
    if ~strcmpi(OA.TickLabelFontName,'FixedWidth')
        OA.tickLabelTextWidth = 0.8*(pb(3) - pb(1) - 4);
    else
        OA.tickLabelTextWidth = pb(3) - pb(1) - 4;
    end

    % Redraw ticks if necessary
    if listenerMode
        % Call drawTicks for each axis
        drawTicks(OA,'X')
        drawTicks(OA,'Y')
        drawTicks(OA,'Z')
    end

end
% End of function calcTextSize
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function deleteLabel(OA,ax,h)
% Rebuild labels if someone deletes them

% If the oaxes is being deleted, take no action
if strcmp(OA.BeingDeleted,'on')
    return
end

pName = ['h' ax 'Label'];
hL = get(OA,pName);

str = get(OA,[ax 'Label']);

idx = double(h)==double(hL);
if idx(1)
    tag = ['Negative' ax 'AxisLabel'];
    str = str{1};
else
    tag = ['Positive' ax 'AxisLabel'];
    str = str{2};
end

hNew = text('HandleVisibility','on',...
            'HitTest','off',...
            'Parent',double(OA),...
            'String',str,...
            'Tag',tag,...
            'Units','data',...
            'Visible','off',...
            'XLimInclude','off',...
            'YLimInclude','off',...
            'ZLimInclude','off');

% Store new handle
hL(idx) = handle(hNew);
set(OA,pName,hL)

% Update label positions
drawLabels(OA)

% End of function deleteLabel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drawAxis(OA,ax)
% Draw an axis including axis line, arrows, labels, ticks and ticklabels

switch ax
    case 'X'
        axID = 1;
        hGroup = OA.hX;
        hTick = OA.hXTick;
        hTickLabel = OA.hXTickLabel;
    case 'Y'
        axID = 2;
        hGroup = OA.hY;        
        hTick = OA.hYTick;
        hTickLabel = OA.hYTickLabel;
    case 'Z'
        axID = 3;
        hGroup = OA.hZ;
        hTick = OA.hZTick;
        hTickLabel = OA.hZTickLabel;
end

% If the axis should be hidden, hide it and return
if ~(OA.visibleAxes(axID) && OA.AxisLines(axID))
    set([hGroup; hTick; hTickLabel],'Visible','off')
    return
else
    set(hGroup,'Visible','on')
end

%% Get needed data

% Vector of arrow positions along compliment axis
AVec = [OA.tickEnds(1,:); OA.OI(OA.xyzC); OA.tickEnds(2,:)];

switch ax
    case 'X'
        color = OA.XColor;
        hLine = OA.hXLine;
                    
        % Get line and arrow location data
        lineX = OA.oLims(:,1);
        lineY = [OA.OI(2); OA.OI(2)];
        lineZ = [OA.OI(3); OA.OI(3)];
        arrowX = [OA.aEnds(1,1) OA.aEnds(2,1); ...
                  OA.oLims(1,1) OA.oLims(2,1); ...
                  OA.aEnds(1,1) OA.aEnds(2,1)];
        arrowY = repmat((OA.xyzC(1)==2)*AVec(:,1) + ...
                        (OA.xyzC(1)~=2)*[OA.OI(2);OA.OI(2);OA.OI(2)],1,2);
        arrowZ = repmat((OA.xyzC(1)==3)*AVec(:,1) + ...
                        (OA.xyzC(1)~=3)*[OA.OI(3);OA.OI(3);OA.OI(3)],1,2);

    case 'Y'
        color = OA.YColor;
        hLine = OA.hYLine;
             
        % Get line and arrow location data
        lineX = [OA.OI(1); OA.OI(1)];
        lineY = OA.oLims(:,2);
        lineZ = [OA.OI(3); OA.OI(3)];
        arrowX = repmat((OA.xyzC(2)==1)*AVec(:,2) + ...
                        (OA.xyzC(2)~=1)*[OA.OI(1);OA.OI(1);OA.OI(1)],1,2);
        arrowY = [OA.aEnds(1,2) OA.aEnds(2,2); ...
                  OA.oLims(1,2) OA.oLims(2,2); ...
                  OA.aEnds(1,2) OA.aEnds(2,2)];
        arrowZ = repmat((OA.xyzC(2)==3)*AVec(:,2) + ...
                        (OA.xyzC(2)~=3)*[OA.OI(3);OA.OI(3);OA.OI(3)],1,2);
        
    case 'Z'
        color = OA.ZColor;
        hLine = OA.hZLine;
        
        % Get line and arrow location data
        lineX = [OA.OI(1); OA.OI(1)];
        lineY = [OA.OI(2); OA.OI(2)];
        lineZ = OA.oLims(:,3);
        arrowX = repmat((OA.xyzC(3)==1)*AVec(:,3) + ...
                        (OA.xyzC(3)~=1)*[OA.OI(1);OA.OI(1);OA.OI(1)],1,2);
        arrowY = repmat((OA.xyzC(3)==2)*AVec(:,3) + ...
                        (OA.xyzC(3)~=2)*[OA.OI(2);OA.OI(2);OA.OI(2)],1,2);
        arrowZ = [OA.aEnds(1,3) OA.aEnds(2,3); ...
                  OA.oLims(1,3) OA.oLims(2,3); ...
                  OA.aEnds(1,3) OA.aEnds(2,3)];
end

         
%% Draw/update axis line and arrows
if isempty(hLine) || ~all(ishandle(hLine))
    delete(hLine)
    lineProps = {'Clipping','off',...
                 'HandleVisibility','on',...
                 'HitTest','off',...
                 'LineStyle','-',...
                 'Marker','none',...
                 'Parent',double(hGroup),...
                 'Tag',[ax 'AxisLine'],...
                 'Visible','off',...
                 'XLimInclude','off',...
                 'YLimInclude','off',...
                 'ZLimInclude','off'
                 };
    hLine = [line(lineProps{:}); line(lineProps{:}); line(lineProps{:})];
    
    % Store handles
    pName = ['h' ax 'Line'];
    set(OA,pName,hLine)
end
          
set(hLine(1),'Color',color,...
             'LineWidth',OA.LineWidth,...
             'XData',lineX,...
             'YData',lineY,...
             'ZData',lineZ)

set(hLine(2),'Color',color,...
             'LineWidth',OA.LineWidth,...
             'XData',arrowX(:,1),...
             'YData',arrowY(:,1),...
             'ZData',arrowZ(:,1))
         
set(hLine(3),'Color',color,...
             'LineWidth',OA.LineWidth,...
             'XData',arrowX(:,2),...
             'YData',arrowY(:,2),...
             'ZData',arrowZ(:,2))

% Hide arrows where axis is clipped or arrow is 'off';
isVis = [true; ~OA.clipMask(:,axID) & ~strcmp(OA.Arrow,'off')];
set(hLine(isVis),'Visible','on')
set(hLine(~isVis),'Visible','off')

%% Draw ticks and exit
drawTicks(OA,ax)

% End of function drawAxis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drawLabels(OA)
% Update axis label positions and alignment

%% Calculate axis label positions

if strcmp(OA.AxisLabelLocation,'side')
    % Axis labels are in same position as tick labels
    axLabelX = [OA.oLims(:,1) ...
                repmat(OA.OI(1)*~(OA.xyzC(2)==1) + ...
                       OA.tickLabelPos(2)*(OA.xyzC(2)==1),2,1) ...
                repmat(OA.OI(1)*~(OA.xyzC(3)==1) + ...
                       OA.tickLabelPos(3)*(OA.xyzC(3)==1),2,1)];
    axLabelY = [repmat(OA.OI(2)*~(OA.xyzC(1)==2) + ...
                       OA.tickLabelPos(1)*(OA.xyzC(1)==2),2,1) ...
                OA.oLims(:,2) ...
                repmat(OA.OI(2)*~(OA.xyzC(3)==2) + ...
                       OA.tickLabelPos(3)*(OA.xyzC(3)==2),2,1)];
    axLabelZ = [repmat(OA.OI(3)*~(OA.xyzC(1)==3) + ...
                       OA.tickLabelPos(1)*(OA.xyzC(1)==3),2,1) ...
                repmat(OA.OI(3)*~(OA.xyzC(2)==3) + ...
                       OA.tickLabelPos(2)*(OA.xyzC(2)==3),2,1) ...
                OA.oLims(:,3)];
else
    % Axis labels are at ends of axis lines
    len = OA.AxisLabelOffset./OA.d2px;
    axLabelPos = OA.oLims + [-len; len];
    
    % Handle log-scale axes
    for k = find(OA.logScale)
        axLabelPos(:,k) = 10.^(log10(OA.oLims(:,k)) + [-len(k); len(k)]);
    end
    
    axLabelX = [axLabelPos(:,1) [OA.OI(1); OA.OI(1)] [OA.OI(1); OA.OI(1)]];
    axLabelY = [[OA.OI(2); OA.OI(2)] axLabelPos(:,2) [OA.OI(2); OA.OI(2)]];
    axLabelZ = [[OA.OI(3); OA.OI(3)] [OA.OI(3); OA.OI(3)] axLabelPos(:,3)];
end

labelPos = [axLabelX(:) axLabelY(:) axLabelZ(:)];

%% Set up text alignment

% Get calculated label alignments
if strcmpi(OA.AxisLabelLocation,'side')
    axHA = [OA.tickHA; OA.tickHA];
    axVA = [OA.tickVA; OA.tickVA];
else
    axHA = OA.axHA;
    axVA = OA.axVA;
end

% Merge manual label alignment values into calculated values
manualH = [OA.XLabelHorizontalAlignment' ...
           OA.YLabelHorizontalAlignment' ...
           OA.ZLabelHorizontalAlignment'];
isManualH = ~strcmp('auto',manualH);
axHA(isManualH) = manualH(isManualH);

manualV = [OA.XLabelVerticalAlignment' ...
           OA.YLabelVerticalAlignment' ...
           OA.ZLabelVerticalAlignment'];
isManualV = ~strcmp('auto',manualV);
axVA(isManualV) = manualV(isManualV);


%% Update labels

h = [OA.hXLabel; OA.hYLabel; OA.hZLabel];

set(h,{'Position'},mat2cell(labelPos,ones(6,1)))
set(h,{'HorizontalAlignment'},axHA(:))
set(h,{'VerticalAlignment'},axVA(:))

% Hide labels where axis is clipped or axis line is hidden, unless
% 'AlwaysShowLabels' is 'on'.
hideIdx = (OA.clipMask | ~[OA.visibleAxes; OA.visibleAxes]) & ...
    ~strcmp(OA.AlwaysShowLabels,'on');
set(h(hideIdx(:)),'Visible','off')
set(h(~hideIdx(:)),'Visible','on')

% End of function drawLabels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drawMinorTicks(OA,axIdx,tickColor,tickParent,hName,mTicks)
% Draw minor ticks for log-scaled axes

%% Determine minor tick locations

% Calculate minor ticks if they weren't given as an argument
if isempty(mTicks)
    mVec = floor(log10(OA.cLims(1,axIdx))):ceil(log10(OA.cLims(2,axIdx)));
    mTicks = 10.^(sort(repmat(mVec,1,9)) + ...
        repmat(log10(1:9),1,length(mVec)));
end

% Remove ticks outside of limits
mTicks(mTicks < OA.cLims(1,axIdx)) = [];
mTicks(mTicks > OA.cLims(2,axIdx)) = [];

if isempty(mTicks) || OA.MinorTickLength == 0
    set(get(OA,hName),'Visible','off')
    return
end

%% Determine tick length
tLen = OA.labelDir(axIdx).*OA.TickLengthI.*OA.MinorTickLength./...
    OA.d2px(OA.xyzC(axIdx));

if OA.logScaleC(axIdx)
    % Log-scaled compliment axis
    tickEnds = 10.^(log10([OA.OC(axIdx); OA.OC(axIdx)]) + [-tLen; tLen]);
    tickEnds = real(tickEnds);
    tickEnds(isinf(tickEnds)) = NaN;
else
   % Compliment axis is normal scale
    tickEnds = [OA.OC(axIdx); OA.OC(axIdx)] + [-tLen; tLen];
end

%% Create U,V,W minor tick vectors
nTicks = length(mTicks);

% U axis: the principal axis along which the ticks are drawn
tickU = repmat(mTicks,2,1);

% V axis: the axis in which the ticks have length
tickV = repmat(tickEnds,1,nTicks);

% W axis: the unused axis
tickW = repmat(OA.OI(6-(axIdx + OA.xyzC(axIdx))),2,nTicks);


%% Permute UVW data into XYZ data
switch axIdx
    case 1
        tickX = tickU;
        if OA.xyzC(1) == 2
            tickY = tickV;
            tickZ = tickW;
        else
            tickY = tickW;
            tickZ = tickV;
        end
    case 2
        tickY = tickU;
        if OA.xyzC(2) == 1
            tickX = tickV;
            tickZ = tickW;
        else
            tickX = tickW;
            tickZ = tickV;
        end
    case 3
        tickZ = tickU;
        if OA.xyzC(3) == 1
            tickX = tickV;
            tickY = tickW;
        else
            tickX = tickW;
            tickY = tickV;
        end
end

%% Draw ticks/tick labels

nTicks = size(tickX,2);
hTick = get(OA,hName);

% Handle changed number of ticks
if length(hTick) > nTicks
    hTickP = hTick(1:nTicks);
    set(hTick(nTicks+1:end),'Visible','off')
elseif length(hTick) < nTicks
    newTickData = zeros(2,nTicks-length(hTick));
    newTicks = line(newTickData,...
        newTickData,...
        newTickData,...
        'Clipping','off',...
        'HandleVisibility','on',...
        'HitTest','off',...
        'LineStyle','-',...
        'Marker','none',...
        'Parent',tickParent,...
        'Tag','Tick',...
        'Visible','off',...
        'XLimInclude','off',...
        'YLimInclude','off',...
        'ZLimInclude','off');
    hTickP = [hTick; handle(newTicks)];
    set(OA,hName,hTickP)
else
    hTickP = hTick;
end

% Update tick properties
vec = ones(1,nTicks);
set(hTickP,{'XData'},mat2cell(tickX',vec))
set(hTickP,{'YData'},mat2cell(tickY',vec))
set(hTickP,{'ZData'},mat2cell(tickZ',vec))
set(hTickP,'Color',tickColor,...
    'LineWidth',OA.MinorTickLineWidth,...
    'Visible','on')

% End of function drawMinorTicks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drawTicks(OA,ax)
% Draw ticks and tick labels for a specified axis.

% Get axis-specific data
switch ax
    case 'X'
        scale = get(OA.hAx,'XScale');
        tName = 'XTick';
        tlName = 'XTickLabel';
        tmName = 'XTickMode';
        tlmName = 'XTickLabelMode';
        tickColor = OA.XColor;
        tickParent = double(OA.hX);
        hMinorTickName = 'hXMinorTick';
        hTickName = 'hXTick';
        hTickLabelName = 'hXTickLabel';
        axIdx = 1;
    case 'Y'
        scale = get(OA.hAx,'YScale');
        tName = 'YTick';
        tlName = 'YTickLabel';
        tmName = 'YTickMode';
        tlmName = 'YTickLabelMode';
        tickColor = OA.YColor;
        tickParent = double(OA.hY);
        hMinorTickName = 'hYMinorTick';
        hTickName = 'hYTick';
        hTickLabelName = 'hYTickLabel';
        axIdx = 2;
    case 'Z'
        scale = get(OA.hAx,'ZScale');
        tName = 'ZTick';
        tlName = 'ZTickLabel';
        tmName = 'ZTickMode';
        tlmName = 'ZTickLabelMode';
        tickColor = OA.ZColor;
        tickParent = double(OA.hZ);
        hMinorTickName = 'hZMinorTick';
        hTickName = 'hZTick';
        hTickLabelName = 'hZTickLabel';
        axIdx = 3;
end

% Get ticks based on X/Y/ZTickMode
tickMode = get(OA,tmName);
scaleStr = '';
mTicks = [];

switch tickMode
    case 'manual'
        ticks = get(OA,tName);
    case 'off'
        ticks = [];
    case 'parent'
        ticks = get(OA.hAx,tName);
    case 'auto'
                     
        % Determine orientation
        hv = abs(OA.rT(1,axIdx)) > 1.2*abs(OA.rT(2,axIdx));
        
        % Convert text size to data units
        if hv
            textSize = abs(OA.tickLabelTextWidth/OA.rT(1,axIdx));
            orientation = 'h';
        else
            textSize = abs(OA.tickLabelTextHeight/OA.rT(2,axIdx));
            orientation = 'v';
        end       
        
        % Handle log-scale
        if OA.logScale(axIdx)
            textSize = textSize/OA.sf(axIdx);
        end
        
        % Select limits to use for tick calculation
        if strcmp(get(OA,[ax 'LimMode']),'extend') || ...
                strcmp(OA.Arrow,'extend')
            lims = OA.cLims(:,axIdx);
        else
            lims = OA.oLims(:,axIdx);
        end
        
        % Call calcticks to get ticks and tick labels
        [ticks,tickLabel,scaleStr,mTicks] = calcticks(...
            lims',orientation,textSize,scale,true,...
            OA.ExpFontScale*OA.TickLabelFontSize);
        
end

% Get tick labels based on X/Y/ZTickLabelMode
switch get(OA,tlmName)
    case 'auto'
        if strcmp(tickMode,'auto')
            % Already have tickLabel from call to calcticks
        elseif strcmp(tickMode,'manual')
            tickLabel = strtrim(cellstr(num2str(ticks','%g')))';
        elseif strcmp(tickMode,'off')
            tickLabel = cell(1,length(ticks));
        elseif strcmp(tickMode,'parent')
            tickLabel = get(OA.hAx,tlName);
        end
    case 'manual'
        tickLabel = get(OA,tlName);
    case 'off'
        tickLabel = cell(1,length(ticks));
end

if ischar(tickLabel)
    tickLabel = strtrim(cellstr(tickLabel));
end

if size(tickLabel,1) > 1
    tickLabel = tickLabel';
end

% Store values in X/Y/ZTickI and X/Y/ZTickLabelI
pName = [ax 'TickI'];
set(OA,pName,ticks)
pName = [ax 'TickLabelI'];
set(OA,pName,tickLabel)

% If the axis lines are hidden or there are no ticks, return
if ~OA.visibleAxes(axIdx) || isempty(ticks)
    set(get(OA,hMinorTickName),'Visible','off');
    set(get(OA,hTickName),'Visible','off');
    set(get(OA,hTickLabelName),'Visible','off');
    return
end

% If there aren't enough tick labels, repeat them to match the number of
% ticks
if length(ticks) > length(tickLabel)
    n = ceil(length(ticks)/length(tickLabel));
    tickLabel = repmat(tickLabel,1,n);
end

% If there are too many tick labels, trim them to match the number of ticks
if length(ticks) < length(tickLabel)
    tickLabel = tickLabel(1:length(ticks));
end

% Convert tick labels to exponents for log-scaled axes
if OA.logScale(axIdx) && strcmp(get(OA,tlmName),'auto') && ...
        ~strcmp(get(OA,tmName),'auto')
    fSize = num2str(OA.ExpFontScale*OA.TickLabelFontSize);
    for k = 1:length(tickLabel)
        if ~isempty(tickLabel{k}) && ...
                abs(str2double(tickLabel{k})-log10(ticks(k))) < ...
                100*eps(ticks(k))
            tickLabel{k} = ['10^{\fontsize{' fSize '}' tickLabel{k} '}'];
        end
    end
end
      
%% Create data arrays to draw ticks/labels

nTicks = length(ticks);

% U axis: the principal axis along which the ticks are drawn
tickU = repmat(ticks,2,1);

% V axis: the axis in which the ticks have length
tickV = repmat(OA.tickEnds(:,axIdx),1,nTicks);

% W axis: the unused axis
tickW = repmat(OA.OI(6-(axIdx + OA.xyzC(axIdx))),2,nTicks);

% Tick label position in UVW order
tickLabelU = ticks;
tickLabelV = repmat(OA.tickLabelPos(axIdx),1,nTicks);
tickLabelW = repmat(OA.OI(6-(axIdx + OA.xyzC(axIdx))),1,nTicks);

%% Remove out-of-bounds and origin ticks/tick labels
% Filter out-of-bounds ticks
badTicks = (ticks < OA.cLims(1,axIdx)) | (ticks > OA.cLims(2,axIdx));

% Filter ticks at non-clipped origin
badTicks = badTicks | (~OA.clipC(axIdx) & (ticks == OA.OI(axIdx)));

badIdx = find(badTicks);

% Discard bad ticks
tickU(:,badIdx) = [];
tickV(:,badIdx) = [];
tickW(:,badIdx) = [];
tickLabel(badTicks) = [];
tickLabelU(badTicks) = [];
tickLabelV(badTicks) = [];
tickLabelW(badTicks) = [];

% Append scale string to last tickLabel if necessary
if ~OA.logScale(axIdx) && strcmp(get(OA,tlmName),'auto') && ...
        strcmp(get(OA,tmName),'auto') && ~isempty(scaleStr)
    tickLabel{end} = [tickLabel{end} ' ' scaleStr];
end

%% Permute UVW data into XYZ data
switch ax
    case 'X'
        tickX = tickU;
        tickLabelX = tickLabelU;
        if OA.xyzC(1) == 2
            tickY = tickV;
            tickZ = tickW;
            tickLabelY = tickLabelV;
            tickLabelZ = tickLabelW;
        else
            tickY = tickW;
            tickZ = tickV;
            tickLabelY = tickLabelW;
            tickLabelZ = tickLabelV;
        end
    case 'Y'
        tickY = tickU;
        tickLabelY = tickLabelU;
        if OA.xyzC(2) == 1
            tickX = tickV;
            tickZ = tickW;
            tickLabelX = tickLabelV;
            tickLabelZ = tickLabelW;
        else
            tickX = tickW;
            tickZ = tickV;
            tickLabelX = tickLabelW;
            tickLabelZ = tickLabelV;
        end
    case 'Z'
        tickZ = tickU;
        tickLabelZ = tickLabelU;
        if OA.xyzC(3) == 1
            tickX = tickV;
            tickY = tickW;
            tickLabelX = tickLabelV;
            tickLabelY = tickLabelW;
        else
            tickX = tickW;
            tickY = tickV;
            tickLabelX = tickLabelW;
            tickLabelY = tickLabelV;
        end
end

%% Draw ticks/tick labels

nTicks = size(tickX,2);
hTick = get(OA,hTickName);
hTickLabel = get(OA,hTickLabelName);

% Handle changed number of ticks
if length(hTick) > nTicks
    hTickP = hTick(1:nTicks);
    hTickLabelP = hTickLabel(1:nTicks);
    set(hTick(nTicks+1:end),'Visible','off')
    set(hTickLabel(nTicks+1:end),'Visible','off')
elseif length(hTick) < nTicks
    newTickData = zeros(2,nTicks-length(hTick));
    newTicks = line(newTickData,...
        newTickData,...
        newTickData,...
        'Clipping','off',...
        'HandleVisibility','on',...
        'HitTest','off',...
        'LineStyle','-',...
        'Marker','none',...
        'Parent',tickParent,...
        'Tag','Tick',...
        'Visible','off',...
        'XLimInclude','off',...
        'YLimInclude','off',...
        'ZLimInclude','off');
    hTickP = [hTick; handle(newTicks)];
    newLabelStr = cell(1,nTicks-length(hTick));
    newLabelPos = newTickData(1,:);
    newLabels = text(newLabelPos,...
        newLabelPos,...
        newLabelPos,...
        newLabelStr,...
        'Color',tickColor,...
        'FontUnits',OA.TickLabelFontUnits,...
        'FontAngle',OA.TickLabelFontAngle,...
        'FontName',OA.TickLabelFontName,...
        'FontSize',OA.TickLabelFontSize,...
        'FontWeight',OA.TickLabelFontWeight,...
        'HandleVisibility','on',...
        'HitTest','off',...
        'HorizontalAlignment',OA.tickHA{axIdx},...
        'Parent',tickParent,...
        'Tag','TickLabel',...
        'Visible','off',...
        'VerticalAlignment',OA.tickVA{axIdx},...
        'Units','data');
    hTickLabelP = [hTickLabel; handle(newLabels)];
    set(OA,hTickName,hTickP)
    set(OA,hTickLabelName,hTickLabelP)
else
    hTickP = hTick;
    hTickLabelP = hTickLabel;
end

% Update tick properties
vec = ones(1,nTicks);
set(hTickP,{'XData'},mat2cell(tickX',vec))
set(hTickP,{'YData'},mat2cell(tickY',vec))
set(hTickP,{'ZData'},mat2cell(tickZ',vec))
set(hTickP,'Color',tickColor,...
    'LineWidth',OA.LineWidth,...
    'Visible','on')

% Update tick label properties
tickPos = mat2cell([tickLabelX' tickLabelY' tickLabelZ'],vec); 
set(hTickLabelP,{'Position'},tickPos)
set(hTickLabelP,{'String'},tickLabel')
set(hTickLabelP,'Color',tickColor,...
    'FontUnits',OA.TickLabelFontUnits,...
    'FontAngle',OA.TickLabelFontAngle,...
    'FontName',OA.TickLabelFontName,...
    'FontSize',OA.TickLabelFontSize,...
    'FontWeight',OA.TickLabelFontWeight,...
    'HorizontalAlignment',OA.tickHA{axIdx},...
    'VerticalAlignment',OA.tickVA{axIdx},...
    'Visible','on')

% Create minor ticks for log-scale axis
if OA.logScale(axIdx)
    drawMinorTicks(OA,axIdx,tickColor,tickParent,hMinorTickName,mTicks);
else
    set(get(OA,hMinorTickName),'Visible','off')
end

% End of function drawTicks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function val = getPrivate(obj,pName)
% Gets the value of a private property
val = get(obj,pName);

% End of function getPrivate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hideParentAxes(OA)
% Controls visibility of the parent axes.

hideMode = OA.HideParentAxesMode;
isHidden = strcmp(OA.HideParentAxes,'on');

hAx = OA.hAx;

if isHidden
    if strcmp(hideMode,'visibility')
        % Set parent axes 'Visible' property to 'off'
        set(hAx,'Visible','off')

        % Keep the title visible
        set(get(hAx,'Title'),'Visible','on')

        % Restore the axes colors if necessary
        if ~isempty(OA.parentAxesColors)
            set(hAx,{'XColor','YColor','ZColor'},OA.parentAxesColors)
            OA.parentAxesColors = [];
        end          
    else
        % Save axes colors to restore later
        OA.parentAxesColors = get(hAx,{'XColor','YColor','ZColor'});

        % Now set the axes colors to the parent figure color
        figColor = get(get(hAx,'parent'),'color');
        set(hAx,'XColor',figColor,'YColor',figColor,'ZColor',figColor);

        % Restore parent axes' 'Visible' property
        set(hAx,'Visible','on')        
    end

else
    
    % Restore the axes colors if necessary
    if ~isempty(OA.parentAxesColors)
        set(hAx,{'XColor','YColor','ZColor'},OA.parentAxesColors)
        OA.parentAxesColors = [];
    end

    % Restore parent axes' 'Visible' property
    set(hAx,'Visible','on')

end

% End of function hideParentAxes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function setPrivate(obj,pName,val)
% Sets the value of a private property
set(obj,pName,val)

% End of function setPrivate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


