function h = oaxes(varargin)
% Draw central axis lines through an origin point
%
% SYNTAX
%
%   OAXES
%   OAXES(ORIGIN)
%   OAXES(ORIGIN,'property1',value1,...,'propertyN',valueN)
%   OAXES('property1',value1,...,'propertyN',valueN)
%   OAXES(H,...)
%   OAXES(OA,...)
%   OAXES delete
%   OAXES draw
%   OAXES enable
%   OAXES freeze
%   OAXES toggle
%   OA = OAXES(...)
%
% DESCRIPTION
%
% OAXES   Draw a central axes graphic, consisting of axis lines, ticks,
% ticklabels, arrows and axis labels, through an origin at the center of
% the current axes. 
%
% OAXES(ORIGIN)   Use the location specified in the 1x3 vector ORIGIN as
% the OAXES origin.  Note that all three values [Ox,Oy,Oz] must be
% specified, even for a 2D plot.  A value of NaN for a given axis will
% result in the center of the axis limits being used as the origin, and
% that axis will remain centered if the limits change. See the REMARKS
% section for a description of properties that control the OAXES' origin
% behavior.
%
% OAXES(ORIGIN,'Property1',value1,...,'PropertyN',valueN)
% OAXES('Property1',value1,...,'PropertyN',valueN)   Create an OAXES with
% the specified properties, or, if an OAXES already exists in the current
% axes, update it with the specified properties.  ORIGIN can be specified
% either as the first argument (without a property name string preceeding
% it), or as a property/value pair (i.e. 'Origin',[Ox Oy Oz]).
%
% OAXES(H,...)   Use the axes specified by the handle H instead of the
% current axes.
%
% OAXES(OA,...)   Use the OAXES object specified by the handle OA instead
% of the OAXES in the current axes.
%
% OAXES delete
% OAXES('delete')   Delete the OAXES object.
%
% OAXES draw
% OAXES('draw')   Force a redraw of the OAXES object.  This is useful to
% update the OAXES when the listeners have been disabled using
% OAXES('freeze') in order to improve responsiveness of the parent axes.
%
% OAXES enable 
% OAXES('enable')   Enable the listeners that are attached to various
% properties of the parent axes in order to keep the OAXES coordinated with
% the parent axes.
%
% OAXES freeze
% OAXES('freeze')   Disable the parent axes property listeners to prevent
% automatic changes to the OAXES when the parent axes is modified.  
%
% OAXES toggle
% OAXES('toggle')   Toggle the state of the parent axes property listeners.
%
% OA = OAXES(...)   Return a handle to the OAXES object.  If called on an
% axes with an existing OAXES object, return its handle.
%
%
% REMARKS
%
% Please install the latest version of OAXES for best results. See 
% http://www.mathworks.com/matlabcentral/fileexchange/30018 to obtain the 
% latest version.
%
% Controlling OAXES properties:
%
% During initialization, OAXES mirrors many of the parent axes' properties,
% including font properties, color and linewidth.  Properties supplied in
% the form of property/value pairs as inputs will override the default
% mirrored values.  After initialization, the OAXES properties are not
% linked to the parent axes' properties.
%
% You can set and query OAXES object properties in three ways:
%    * (Set/query) Using the set and get commands.
%    * (Set/query) Using dot notation and a handle to the OAXES object: 
%          oa.PropertyName = value
%    * (Set only) Calling OAXES with a list of property/value pairs as 
%       arguments.
%
% The values of OAXES properties can be obtained by calling
% get(OA,'PropertyName'), where OA is a handle to the OAXES object. Calling
% get(OA) with no property names specified will return a list of all
% properties of the OAXES object.
%
%
% OAXES Properties
%
% Arrow
%     {'end'} | 'extend' | 'off'
%     Arrow location. Controls the location and visibility of arrowheads at
%     the ends of the axis lines. The default value, 'end', draws
%     arrowheads at the ends of the axis lines, using a portion of the
%     axes' data range. A value of 'extend' will draw the arrowheads
%     outside of the normal plot area, to allow the ticks and tick labels
%     to be printed along the entire data range of the axis. Setting
%     'Arrow' to 'off' will suppress the drawing of arrowheads.
%
% ArrowAspectRatio
%     scalar, default value: 2
%     Arrowhead aspect ratio. Controls the length of the arrowhead relative
%     to the width. Arrowhead width is determined by the 'TickLength'
%     property.
%
% AxisExtend
%     scalar, default value: 0.75
%     Arrow extension length. Additional distance, measured in arrow
%     lengths, to extend the axis lines when 'Arrow' is set to 'extend'.
%     The axis lines will be extended by a total of (1 + AxisExtend) arrow
%     lengths past the normal axes limits.
%
% AxisLabelLocation
%     {'end'} | 'side'
%     Axis label placement. Determines placement of axis labels. A value of
%     'end' places labels at the ends of the axis lines. A value of 'side'
%     places labels to the side or below the ends of the axis lines,
%     similar to the locations of tick labels.
%
% AxisLabelOffset
%     scalar, default value: 3
%     Label offset in pixels. Distance to offset the axis labels from the
%     ends of the axis lines when 'AxisLabelLocation' is 'end'. When
%     'AxisLabelLocation' is 'side', this property has no effect.
%
% HideParentAxes
%     {'on'} | 'off' 
%     Parent axes visibility. Controls the visibility of the parent axes.
%     By default, OAXES does not display the parent axes. Setting this
%     value to 'off' will leave the parent axes visible.
%
% HideParentAxesMode
%     {'visibility'} | 'color'
%     Method used by OAXES to hide the parent axes. The default value,
%     'visibility', causes OAXES to set the parent axes' 'Visible' property
%     to 'off'. Setting this property to 'color' causes OAXES to set the
%     parent axes' 'XColor', etc. properties to the figure's background
%     color. The parent axes' visibility is controlled by the OAXES
%     'HideParentAxes' property.
%
% hXLabel, hYLabel, hZLabel
%     handle vector (read only)
%     Axis label handles. Handles to the X, Y and Z axis labels. Use these
%     handles to set properties such as font size for the axis labels. To
%     set the label strings, set the OAXES 'XLabel', 'YLabel', and 'ZLabel'
%     properties. Note that there are two labels (with corresponding
%     handles) for each axis.
%
% LineWidth
%     scalar, default value: 1.5
%     Line width in points. Controls the line width of axis and tick lines.
%
% ListenersEnabled
%     {'on'} | 'off'
%     Oaxes listener state. By default, OAXES updates itself whenever the
%     parent axes is redrawn, or when OAXES properties are changed.
%     Frequent updates can adversely affect graphics performance. Setting
%     the 'ListenersEnabled' property to 'off' will disable the OAXES
%     property and event listeners, preventing OAXES redraws. This behavior
%     can also be controlled by the OAXES('enable'), OAXES('freeze') and
%     OAXES('toggle') function calls, or the OAXES.freeze, OAXES.enable and
%     OAXES.toggle methods.
%
% Origin
%     [Ox Oy Oz]
%     Origin location. Setting the value of 'Origin' will place the OAXES
%     origin in the specified location instead of being centered to the
%     data limits. Setting the 'Origin' property will set the 'OriginMode'
%     property to {'manual','manual','manual'}. However, setting any of the
%     three origin points to NaN will set the corresponding value of
%     'OriginMode' to 'auto'.
% 
%     Note:  For an axis where the corresponding value of [Ox Oy Oz] is
%     outside of the axes data limits, the OAXES axis lines will be drawn
%     at the limit closest to the specified origin.
% 
%     Note:  The individual '(X/Y/Z)Origin' and '(X/Y/Z)OriginMode'
%     properties can be used to control the origin and behavior of each
%     axis individually.
%
% OriginMode
%     1x3 cell array containing 'auto' and/or 'manual'
%     Origin behavior. When 'OriginMode' is 'auto' (the default), OAXES
%     draws the axis lines through an origin centered to the parent axes'
%     data limits. When the limits change, the OAXES origin will
%     automatically be moved to the center of the new limits. When
%     'OriginMode' is 'manual', the OAXES origin will remain in the
%     location specified in 'Origin'.
%
% TickLabelFontAngle
% TickLabelFontName 
% TickLabelFontSize
% TickLabelFontUnits
% TickLabelFontWeight
% TickLabelInterpreter
%     Tick label text properties. The initial values for tick label font
%     properties are copied from the parent axes. The default text
%     interpreter is 'Tex'. See Text_Properties for more information.
%
% TickLength
%     1x2 vector, default value: [6 8]
%     Tick length (in pixels). The value in 'TickLength(1)' is used for 2D
%     views, and the value in 'TickLength(2)' is used for 3D views. This
%     property also determines the width of the axis line arrowheads.
%
% TickOrientation
%     {'auto'} | 'yxx','zxy',etc.
%     Tick line orientation. A value of 'auto' causes OAXES to calculate
%     the tick directions based on the camera settings. To manually specify
%     the orientation, use a value such as 'yxx', where the first character
%     controls the 'XTick' direction, etc. The ticks for a particular axis
%     must be perpendicular to the axis (e.g. a value of 'zyx' is invalid
%     because the 'YTick' lines cannot run in the y direction).
%
% Title
%     string, default: ''
%     Title string. The OAXES 'Title' property allows the parent axes title
%     string to be set as if it were an OAXES property. The value of
%     'Title' is copied to the 'String' property of the parent axes' title
%     object. To modify other properties of the parent axes' title object,
%     first obtain the object's handle, then set its properties directly.
%
% XAxisLine, YAxisLine, ZAxisLine
%     {'on'} | 'off'
%     Display axis line. The '(X/Y/Z)AxisLine' properties control the
%     display of the graphics associated with an axis, including the axis
%     line, arrowheads and ticks and tick labels.
%
% XColor, YColor, ZColor
%     ColorSpec, default value copied from parent axes
%     Axis line color.  Determines the color of axis lines, ticks, and tick
%     marks.  Can be either an RGB triple or a valid MATLAB named color.
%
% XLabel, YLabel, ZLabel
%     1x2 cell array, default value: {'\it{-x}','\it{x}'}
%     Axis label string. '(X/Y/Z)Label' must be specified as a 1x2 cell
%     containing the labels to be placed at the lower and upper axis
%     limits. Use the empty string, '', to suppress an axis label.
% 
%     Note: The OAXES '(X/Y/Z)Label' properties determine the corresponding
%     axis labels' strings. This behavior is unlike the '(X/Y/Z)Label'
%     properties for normal axes, which are handles to the actual label
%     objects. To set properties for the OAXES axis labels, first get the
%     handles stored in 'hXLabel', etc. (which are analogous to the
%     '(X/Y/Z)Label' properties for normal axes), then set the desired
%     property values on these handles.
%
% XLabelHorizontalAlignment, 
% YLabelHorizontalAlignment, 
% ZLabelHorizontalAlignment
%     1x2 cell array, default value: {'auto','auto'}
%     Horizontal text alignment for axis labels. A 1x2 cell array
%     specifying the horizontal alignment of the lower and upper axis
%     labels. A value of 'auto' means that OAXES will determine the text
%     alignment, otherwise the value must be a valid text
%     'HorizontalAlignment' property type.
%
% XLabelVerticalAlignment,
% YLabelVerticalAlignment, 
% ZLabelVerticalAlignment
%     1x2 cell array, default value: {'auto','auto'}
%     Vertical text alignment for axis labels. A 1x2 cell array specifying
%     the vertical alignment of the two axis labels for the specified axis.
%     A value of 'auto' means that OAXES will determine the text alignment,
%     otherwise the value must be a valid text 'VerticalAlignment' property
%     type.
%
% XLim, YLim, ZLim
%     [minimum maximum]
%     Axis limits. Controls the drawn length of the axis lines. See below
%     for a discussion of the '(X/Y/Z)Lim' and '(X/Y/Z)LimMode' properties
%     and how their behavior differs from the corresponding axes
%     properties. Setting the value of '(X/Y/Z)Lim' will set the
%     corresponding '(X/Y/Z)LimMode' to 'manual'.
%
% XLimMode, YLimMode, ZLimMode
%     {'auto'} | 'extend' | 'manual'
%     Axis limits mode. When set to 'auto' (the default), OAXES will draw
%     axis lines to the full extent of the parent axes' data limits. When
%     '(X/Y/Z)LimMode' is 'manual', the corresponding axis line will be
%     drawn out from the origin in both directions to the closer of the
%     values in '(X/Y/Z)Lim' and the parent axes' '(X/Y/Z)Lim'.
% 
%     Setting '(X/Y/Z)LimMode' to 'extend' will cause the axis lines to be
%     drawn past the normal axis data limits to the edges of the box
%     defined by the screen projection of the 3D axes plot cube. For 2D
%     views, setting the limit mode to 'extend' has no effect because the
%     screen projection is identical to the 2D axes plot box.
% 
%     Note:  The OAXES '(X/Y/Z)Lim' and '(X/Y/Z)LimMode' properties are not
%     equivalent to the axes properties with the same names. Specifically,
%     the OAXES properties determine the extent of the OAXES axis lines,
%     and do not determine the extent of the visible plot region. The plot
%     box data limits are still determined by the parent axes'
%     '(X/Y/Z)Lim', 'DataAspectRatio' and 'PlotBoxAspectRatio' properties.
%     See Axes_Properties and Understanding_Axes_Aspect_Ratio for more
%     information.
%
% XTick, YTick, ZTick
%     vector, default value: []
%     Tick locations. A vector of locations for tick marks along the x,y,
%     or z axis. To suppress display of ticks for an axis, either set the
%     corresponding '(X/Y/Z)Tick' property to the empty vector, or set the
%     corresponding '(X/Y/Z)TickMode' property to 'off'. Note that setting
%     the value of '(X/Y/Z)Tick' for an axis will automatically set the
%     corresponding '(X/Y/Z)TickMode' property to 'manual'.
%
% XTickMode, YTickMode, ZTickMode
%     {'parent'} | 'auto' | 'manual' | 'off'
%     Tick mode. When set to 'parent' (the default), OAXES will copy the
%     tick values from the parent axes. If set to 'manual', the values in
%     the corresponding OAXES '(X/Y/Z)Tick' property will be used instead
%     of the parent axes values. Setting '(X/Y/Z)TickMode' to 'off' for an
%     axis will suppress the display of ticks and tick labels for that
%     axis.
% 
%     Setting the tick mode to 'auto' will cause OAXES to calculate its own
%     values for tick locations, using the File Exchange submission
%     calcticks. This allows ticks to be determined for axis lines outside
%     of the parent axes limits (see 'X/Y/ZLimMode'). If calcticks is not
%     installed, OAXES will issue a warning and set the tick mode to
%     'parent'.
%
% XTickLabel, YTickLabel, ZTickLabel
%     cell array of strings
%     Tick labels. A cell array of strings to use as labels for tick marks
%     along the respective axis instead of the automatically calculated
%     tick labels. If you do not specify enough labels for all of the tick
%     marks, the labels will be repeated to match the number of displayed
%     tick marks. Note that unlike axes tick labels, OAXES tick labels can
%     have TeX or LaTeX markup. Setting the '(X/Y/Z)TickLabel' property
%     will set the corresponding '(X/Y/Z)TickLabelMode' to 'manual'.
%
% XTickLabelMode, YTickLabelMode, ZTickLabelMode
%     {'auto'} | 'manual' | 'off'
%     Tick label mode. The default '(X/Y/Z)TickLabelMode', 'auto', will
%     copy the tick labels from the parent axes, if '(X/Y/Z)TickMode' is
%     'parent', or use the tick labels supplied by calcticks, if
%     '(X/Y/Z)TickMode' is 'auto', or use string representations of the
%     tick locations, if '(X/Y/Z)TickMode' is 'manual'. If
%     '(X/Y/Z)TickLabelMode' is set to 'manual', OAXES will use the values
%     in the corresponding '(X/Y/Z)TickLabel' property as tick labels.
%
% OAXES Behavior:
%
% The OAXES listeners  may reduce the responsiveness of the parent axes and
% figure.  Use OAXES('freeze') to temporarily disable the listeners to
% improve performance.  Additionally, some changes to the parent axes may
% not immediately be reflected in the OAXES object.  In this case, call
% OAXES('draw') to force an update.  One known example of this behavior is
% setting the axes to a 2D view from a 3D view by calling 'view(2)'.  In
% this case, the z-axis sometimes remains visible until the OAXES is
% redrawn by calling OAXES('draw'), or perfoming any action that triggers a
% redraw of the parent axes.
%
% Implementation Notes:
%
% The OAXES object is not an instance of the MATLAB 'axes' class, but
% rather is a subclass ('customplots.oaxes') of the 'hggroup' class.  OAXES
% is implemented using the UDD (schema) class system, which is
% undocumented and not officially supported.
%
% Although the customplots.oaxes class is a subclass of the hggroup class,
% it is not recommended to use the OAXES object as a parent for other plot
% objects - they should be created in the parent axes.  Use the 'NextPlot'
% property (controlled by the HOLD command) to add additional plot objects
% to an axes without deleting the previous contents.
%
% OAXES uses a number of undocumented and unsupported features of MATLAB.
% Some of these features may prevent OAXES from functioning properly on
% some versions of MATLAB.  OAXES was developed and tested using version
% 7.1.10 (R2010a).
% 
% Known Issues:
% 
% The current version of OAXES is not serializable.  Trying to
% open a saved figure containing an OAXES object will result in
% errors.  
%
% The MATLAB OpenGL renderer does not appear to fully support the
% 'clipping' graphics object property.  By default, OAXES does not draw
% outside of the plot cube, so the 'clipping' property has no effect.  When
% 'Arrow' is set to 'extend', or any of X/Y/ZLimMode are set to 'extend',
% the OAXES axis lines will be drawn outside of the normal axes plot
% box/cube.  In some cases when the MATLAB OpenGL renderer is in use,
% portions of the OAXES axis lines may not be visible.  The workarounds are
% to either use a different renderer, or avoid the use of 'extend' mode for
% either 'Arrow' or any of X/Y/ZLimMode.
%
% The MATLAB OpenGL renderer does not support log-scaled axes.  If the
% renderer is OpenGL and any of the axes are set to 'log' scale, the
% displayed graphics will not be correct.
%
%
% EXAMPLES
%
% EXAMPLE 1 - 2D Plot
%
% %% Create a plot
% figure
% x = linspace(-7,7,1001);
% y = sin(2*pi*x/3) + cos(2*pi*x/4);
% plot(x,y)
% 
% %% Create the oaxes
% oa = oaxes;
% 
% %% Modify oaxes properties:
% % By calling oaxes with property/value pairs:
% oaxes('YColor',[0 0.5 0])
% 
% % Using set():
% set(oa,'XLabel',{'-time','time'})
% set(get(oa,'hXLabel'),'FontSize',12)
% set(get(oa,'hYLabel'),'FontSize',12)
% 
% % Using dot notation and the oaxes handle:
% oa.XColor = 'b';
% 
% %% Add a second curve:
% hold all
% plot(x+4,y.^2,'color','r')
% 
% %% Set the origin to [0 0 0] instead of centered to the axes limits:
% oa.Origin = [0 0 0];
% 
% 
% EXAMPLE 2 - 3D Plot
%
% %% Create a 3D plot
% figure
% t = linspace(0,20*pi,1001);
% x = cos(pi*t/6);
% y = sin(pi*t/6);
% z = linspace(-2,2,1001);
% plot3(x,y,z,'linewidth',0.5);
% view(3)
% grid on
% 
% %% Create an OAXES object with default values
% oa = oaxes;
% 
% %% Modify the oaxes colors and linewidth and un-hide the parent axes
% set(oa,'XColor','b','YColor',[0 .5 0],'ZColor','r','Linewidth',2,...
% 'HideParentAxes','off')
%
%
% See Also
% AXES AXES_PROPERTIES CALCTICKS
%
%

% $$FileInfo
% $Filename: oaxes.m
% $Path: $toolboxroot/
% $Product Name: oaxes
% $Product Release: 2.2
% $Revision: 2.0.13
% $Toolbox Name: Custom Plots Toolbox
% $$
%
% Copyright (c) 2010-2011 John Barber.
%
% Release History:
% v 1.0 : 2011-Jan-13
%       - Initial release
% v 1.1 : 2011-Jan-18
%       - Added separate font properties for axis and tick labels
%       - Added TickOrientation property
%       - Added X/Y/ZLabel Horizontal and Vertical Alignment properties
%       - Added X/Y/ZAxisLine properties
%       - Enabled display of parent axes' title
%       - Improved automatic text alignment
%       - Improved control of parent axes visibility
%       - Improved input validation
%       - Improved handling of axis limits
%       - Fixed bug preventing refresh with listeners disabled
%       - Fixed display bug when changing 'Arrow' property to 'off'
%       - Fixed display bug when changing 'XTickMode' property to 'off'
%       - Fixed display bug when setting axis labels to empty
%       - Fixed bug with manual ticks and auto tick labels
% v 1.2 : 2011-Mar-10
%       - All properties can be accessed using calls to set() and get()
%       - OAxes class is now 'scribe.oaxes'
%       - OAxes responds automatically to changed property values
%       - Added OriginMode, X/Y/ZOrigin and X/Y/ZOriginMode properties
%       - Added X/Y/ZLimMode properties
%       - Added Force3D and AlwaysShowLabels properties
% v 2.0 : 2011-Mar-28
%       - Part of package 'customplots'
%       - oaxes class is customplots.oaxes.
%       - Added 'extend' axis limit mode
%       - Added 'auto' tick mode to internally calculate ticks (requires
%         calcticks.m)
%       - Added support for obliqueview.m
%       - Added 'Title' property to set parent axes title string
%       - Improved response time for axes redraw event
%       - Changed tick size and arrow length properties to use pixels as
%         unit of measure
%       - Added enable, freeze, draw, and toggle methods
%       - Removed X/Y/ZLabel text properties, added hX/Y/ZLabel properties
%         to expose handles of label text objects
%       - Moved into Custom Plots Toolbox 
% v 2.1 : 2011-Mar-31
%       - Fixed bug preventing some property updates from taking effect
%         after an oaxes.enable call
%       - Fixed bug in axis label listener
%       - Removed unneeded code from constructor
% v 2.2 : 2011-Apr-02
%       - Fixed bug preventing ticks and tick labels from being hidden when
%       'AxisLines' is off
% v 2.3 : 2011-Jun-06
%       - Fixed bug when setting 'Arrow' to 'off'
%       - Improved redraw speed
%       - Improved appearance of minor ticks


%% Parse inputs

% Initialize with empty until we get valid objects
hAx = [];
OA = [];

% Check for axes or oaxes handle
if nargin == 0
    hAx = gca;
elseif ishandle(varargin{1}) 
    if strcmp(get(varargin{1},'Type'),'axes')
        hAx = varargin{1};
        varargin(1) = [];
    elseif strcmp(class(handle(varargin{1})),'customplots.oaxes')
        OA = varargin{1};
        hAx = double(get(OA,'hAx'));
        varargin(1) = [];
    end
end

% Check for action keyword and origin
if length(varargin) == 1
    if ischar(varargin{1})
        % Handle 'delete','freeze','draw','toggle'
        action = lower(varargin{1});
        varargin = [];
    elseif (isvector(varargin{1})) && (length(varargin{1}) == 3)
        % Handle oaxes(Origin)
        action = 'draw';
        varargin = {'Origin' varargin{1}};
    else
        eID = [mfilename ':InvalidInput'];
        eStr = ['Invalid or unrecognized input.  Type ''help ' ...
                mfilename ''' for more information.'];
        error(eID,eStr)
    end
elseif (length(varargin) > 1) && (isnumeric(varargin{1})) && ...
       (length(varargin{1}) == 3)
    % Handle oaxes(Origin,'PropertyName1',value1,...)
    action = 'draw';
    varargin = [{'Origin'} varargin];
else
    action = 'draw';
end

%% Get axes handle and determine action

% Get an axes handle if necessary
if isempty(hAx) || ~ishandle(hAx)
    hAx = gca;
end

% Look for an existing OAxes
if isempty(OA)
    OA = handle(findobj(hAx,'Tag','oaxes'));
    if all(size(OA) ~= [1 1]) || ~strcmp(class(OA),'customplots.oaxes');
        OA = [];
    end
end

% Test for 'create' mode or missing OAxes
if isempty(OA)
    if strcmp(action,'draw')
        action = 'create';
    else
        eID = [mfilename ':NoOAxes'];
        eStr = 'Could not locate an OAxes object in the specified axes';
        error(eID,eStr)
    end
end

% Reshape property name / value pairs
pvPairs = parsePVPairs(varargin);


%% Perform specified action

switch lower(action)
    case {'draw','refresh','redraw'}
        
        % Get current listener state
        enableState = OA.ListenersEnabled;
        
        % Disable listeners
        OA.ListenersEnabled = 'off';
        
        % Update OAxes properties with new values 
        for k = 1:size(pvPairs,1)
            set(OA,pvPairs{k,1},pvPairs{k,2})
        end
               
        % Force a redraw of the oaxes
        OA.draw
        
        % Restore prior listener state
        OA.ListenersEnabled = enableState;
        
    case 'enable'
               
        % Turn on property listeners       
        OA.enable
               
    case 'freeze'
        
        % Turn off property listeners       
        OA.freeze
        
    case 'toggle'
        
        % Toggle oaxes listeners
        OA.toggle
               
    case 'delete'
        % Delete the OAxes.  This will execute the deleteOAxes function to
        % restore the parent axes visibility.
        delete(OA)
        
    case 'create'
               
        OA = customplots.oaxes(hAx,pvPairs);

    otherwise
        eID = [mfilename ':UnknownCommand'];
        eStr = ['Unknown command: ''' action '''.'];
        error(eID,eStr)
end

% Set output value and exit
if nargout == 1
    h = OA;
end

% End of function oaxes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pvPairs = parsePVPairs(args)
% Split args into property/value pairs

% Check for empty input
if isempty(args)
    pvPairs = [];
    return
end
    
% Check for unbalanced input
if mod(length(args),2) == 1
    wID = [mfilename ':IgnoreUnbalancedInput'];
    wStr = 'Ignoring unbalanced input.';
    warning(wID,wStr)
    args(end) = [];
end

% Find and remove non-alpha property names
chars = cellfun('isclass',args,'char');
idx = (mod(((1:length(chars))-1),2) == 0);
nonAlpha = find(idx & ~chars);

for k = nonAlpha
    if isnumeric(args{k})
        pName = mat2str(args{k});
    elseif iscellstr(args{k})
        pName = args{k}{1};
    else
        pName = '???';
    end
    wID = [mfilename ':InvalidPropertyName']; 
    wStr = ['Invalid property name ''' pName ''' will be ignored.'];
    warning(wID,wStr)
end

% Remove non-alpha properties and values from input arguments
args([nonAlpha 1+nonAlpha]) = [];

% Get property/value pairs to output
if (length(args) < 2)
    % Return empty array
    pvPairs = [];
else
    % Make a cell array with rows: 'PropertyName',value 
    pvPairs = [args(1:2:end)' args(2:2:end)'];
end

% End of oaxes/parsePVPairs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%