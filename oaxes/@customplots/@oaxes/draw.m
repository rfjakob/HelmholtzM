function draw(OA,disableListeners) 
% Update oaxes internal state and draw all oaxes graphics

% $$FileInfo
% $Filename: draw.m
% $Path: $toolboxroot/@customplots/@oaxes/
% $Product Name: oaxes
% $Product Release: 2.3
% $Revision: 1.0.8
% $Toolbox Name: Custom Plots Toolbox
% $$
%
% Copyright (c) 2010-2011 John Barber.
%

%% Handle listener enable state

if nargin == 1
    disableListeners = true;
end

if disableListeners
    % Disable listeners
    hL = [OA.hParentAxesListeners;
          OA.hInternalListeners];
    enableState = get(hL,'Enabled');
    set(hL,'Enabled','off')
end

%% Calculate internal oaxes state

% Calculate limits and origin location
calcLimits(OA,false)

% Determine compliment axes and related data
calcIJK(OA)
       
% Determine text box alignment for tick and axis labels
calcTextAlignment(OA)

%% Draw OAxes features

% Draw each axis 
OA.methods('drawAxis','X')
OA.methods('drawAxis','Y')
OA.methods('drawAxis','Z')

% Update label positions and alignment
OA.methods('drawLabels')

% Reenable listeners
if disableListeners
    set(hL,{'Enabled'},enableState)
end

% End of method oaxes.draw
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function calcIJK(OA)
% Compute I,J,K axes and related variables

% Check for reversed axes: (1=normal, -1=reverse)
OA.axDir = 1 - 2*strcmp('reverse',{get(OA.hAx,'XDir'), ...
    get(OA.hAx,'YDir'), get(OA.hAx,'ZDir')});

% From the transformation matrix, use the axes' projections onto screen x,y
t = OA.T(1:3,1:3).^2;

%% Find I (screen x), J (screen y) and K (screen z) axes from t

ijk = zeros(1,3);

% I is the axis with the strongest screen x projection
ijk(1) = find(t(1,:)==max(t(1,:)),1);

% J is the axis with the strongest screen y projection
ijk(2) = find(t(2,:)==max(t(2,:)),1,'last');

% Tiebreaker, just in case:
if ijk(1) == ijk(2)
    if (t(1,ijk(1)) >= t(2,ijk(1)))
        % ijk(1) = ijk(1);
        tt = t(2,:);
        tt(ijk(1)) = 0;
        ijk(2) = find(tt == max(tt));
    else
        % ijk(2) = ijk(2);
        tt = t(1,:);
        tt(ijk(2)) = 0;
        ijk(1) = find(tt == max(tt));
    end
end

% K is whatever axis is left
ijk(3) = 6 - sum(ijk);

% Store the new ijk value
OA.ijk = ijk;

% ijk is a lookup table:  ijk(1) is the I axis, etc.  The values of ijk are
% the x,y,z axes numbers (x=1,y=2,z=3).

% xyz is an index to sort vectors in ijk order to be in xyz order
[trash,OA.xyz] = sort(OA.ijk);  %#ok (Compatibility with old versions)


%% Select a compliment axis for each axis
% Now we choose a compliment axis for each of I,J,K.  The compliment axis
% defines the plane of the tick and arrow lines, as well as tick label
% placement.

% Thresholds for selecting I and K compliment axes
iTh = 0.0015;
kTh = 0.015;

ijkCIdx = zeros(1,3);

if ~strcmp(OA.TickOrientation,'auto')
    % Use specified values for the compliment axes
    useX = strfind(OA.TickOrientation,'x');
    useY = strfind(OA.TickOrientation,'y');
    useZ = strfind(OA.TickOrientation,'z');
    ijkCIdx(OA.xyz(useX)) = OA.xyz(1);
    ijkCIdx(OA.xyz(useY)) = OA.xyz(2);
    ijkCIdx(OA.xyz(useZ)) = OA.xyz(3); 
    
else
    % Determine best compliment axes values based on view

    % I axis compliment
    if (sum(t(1:2,OA.ijk(3)))*(t(1,OA.ijk(2))+t(3,OA.ijk(2)))^2 < ...
            iTh) || (t(1,OA.ijk(2)) > t(1,OA.ijk(3)))
        ijkCIdx(1) = 2;
    else
        ijkCIdx(1) = 3;
    end

    % J axis compliment: use I axis
    ijkCIdx(2) = 1;

    % K axis compliment

    if ijkCIdx(1) == 2 && (t(1,OA.ijk(3)) > kTh)
        ijkCIdx(3) = 2;
    else
        ijkCIdx(3) = 1;
    end
    
end

OA.ijkCIdx = ijkCIdx;

% We now have the following:
%
% ijk = [iAx jAx kAx]; for x=i,y=k,z=j, ijk=[1 3 2];
% ijkCIdx = [iC jC kC]; for ic=k,jc=i,kc=i, ijkCIdx=[3 1 1];
% % Inverse:
% [~,xyz] = sort(ijk);  for x=i,y=k,z=j, xyz=[1 3 2];
% for above, xyzC=[2 1 1] -> Cax for xyz is y x x

%% Get permutation index, permuted values and axis direction information

% Index into LUT to get vector of compliment axes in ijk order
ijkC = OA.ijk(OA.ijkCIdx);

% Sort the compliment axes vector to be in x,y,z order
OA.xyzC = ijkC(OA.xyz);

% Determine axis directions on the screen : depends on T, XYZDir
OA.hDir = sign(OA.axDir.*OA.T(1,1:3)); % + if axis increases to the right
OA.hDir(OA.hDir==0) = 1;
OA.vDir = sign(OA.axDir.*OA.T(2,1:3)); % + if axis increases going up
OA.vDir(OA.vDir==0) = 1;

% H and V directions for compliment axes:
hDirC = OA.hDir(OA.xyzC);
vDirC = OA.vDir(OA.xyzC);

% Determine if axis variation is larger in horizontal or vertical direction
% hv(n)=1 means axis n varies more in horizontal direction
OA.hv = (t(1,:) >= t(2,:));
OA.hvC = OA.hv(OA.xyzC);

% Compute compliment axis limits, direction etc. by applying xyzC
OA.limsC = OA.pLims(:,OA.xyzC); 
OA.OC = OA.OI(OA.xyzC); 
OA.logScaleC = OA.logScale(OA.xyzC);
OA.clipC = OA.clip(OA.xyzC);

% Test for label side flip
testLimsC = OA.oLims(:,OA.xyzC);
testLims = testLimsC(2-(OA.axDir(OA.xyzC)==-1)+[0 2 4]);
testSign = sign(OA.axDir(OA.xyzC));

OA.flipC = testSign.*(testLims - OA.OC) < OA.FlipMargin*diff(testLimsC);

% Handle log-scale axes
for k = find(OA.logScaleC)
    OA.flipC(k) = testSign(k).*(log10(testLims(k))-log10(OA.OC(k))) < ...
                   OA.FlipMargin*diff(log10(testLimsC(:,k)));
end

% Compute a direction for each compliment axis based on either horizontal
% or vertical direction.
ijkDirC = [0 0 0];
ijkDirC(1) = vDirC(OA.ijk(1));
ijkDirC(2) = hDirC(OA.ijk(2));
if OA.ijkCIdx(3) == 1
    ijkDirC(3) = hDirC(OA.ijk(3));
else
    ijkDirC(3) = vDirC(OA.ijk(3));
end

% Determines which side of the axis to draw the labels on
OA.labelDir = ijkDirC(OA.xyz);

%% Compute basic positions for ticks/tick labels/arrows/axis labels

TLSign = 1 - 2*OA.flipC; 

d2pxC = OA.d2px(OA.xyzC);
tickLen = OA.labelDir.*OA.tickLengthI./d2pxC;

% Normal axes:
OA.tickEnds = [OA.OC; OA.OC] + [-tickLen; tickLen];
OA.tickLabelPos = OA.OC - TLSign.*OA.TickLabelOffset.*tickLen;

% Log-scaled axes
for k = find(OA.logScaleC)
    len = tickLen(k);
    OA.tickEnds(:,k) = 10.^(log10([OA.OC(k); OA.OC(k)]) + [-len; len]);
    OA.tickLabelPos(:,k) = 10.^(log10(OA.OC(k)) - ...
                                TLSign(k).*OA.TickLabelOffset.*len);
    OA.tickEnds = real(OA.tickEnds);
    OA.tickLabelPos = real(OA.tickLabelPos);
    OA.tickEnds(isinf(OA.tickEnds)) = NaN;
    OA.tickLabelPos(isinf(OA.tickLabelPos)) = NaN;
end

% End of function calcIJK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function calcLimits(OA,isRecursive)
% Determine limits and origin location

%% Initial calculations

% Get axes data
axData = get(OA.hAx);

% Check for log-scaled axes
OA.logScale = strcmp('log',{axData.XScale,axData.YScale,axData.ZScale});

% Get axes transform
T = get(OA.hAx,'XForm');

% Find the current visible axes
isVisibleAxis = any(abs(T(1:2,1:3)) > 100*eps);
OA.visibleAxes = isVisibleAxis | strcmp(OA.Force3D,'on');

% Test for 2D/3D view
is2d = (length(find(OA.visibleAxes)) == 2);

% Select tick length depending on view
if is2d
    OA.TickLengthI = OA.TickLength(1);
else
    OA.TickLengthI = OA.TickLength(2);
end

%% Calculate OAxes limits
% We use several different sets of limits:
%
% pLims: Data limits of parent axes.
% oLims: Outer limits of oaxes plot objects, including arrowheads and
%        extension length. Can be outside of parent axes limits if 'Arrow'
%        is 'extend'.  Can be inside of parent axes' limits if the
%        X/Y/ZLimsMode is 'manual' and the values of OA.X/Y/ZLim are inside
%        of the parent axes' limits.  
% cLims: Limits of oaxes plot objects, excluding arrowheads and extension 
%        length. Will always be inside of or equal to oLims. cLims are used
%        as clipping limits for ticks and arrowheads - values outside of
%        cLims will not be displayed.
% kLims: Hard clipping limit, a combination of values from oLims and cLims,
%        depending on the values of OA.Arrow and OA.X/Y/ZLimMode.  The 
%        oaxes origin will always be inside of kLims.
% tLims: Limits for calculating ticks when X/Y/ZTickMode is 'auto'.  Set to
%        pLims when X/Y/ZLimMode is 'auto'.  Set to cLims when X/Y/ZLimMode
%        is 'manual' or 'extend'.  When X/Y/ZTickMode is not 'auto', tLims
%        are not used.  Not an actual property.
%

% Get limits of parent axes
pLims = [axData.XLim' axData.YLim' axData.ZLim'];
OA.pLims = pLims;

% Use pLims as a starting point to calculate oLims
oLims = pLims;

% Find axes in 'auto', 'manual' and 'extend' modes
isAuto = strcmp('auto',{OA.XLimMode,OA.YLimMode,OA.ZLimMode});
isAuto = [isAuto; isAuto];
isManual = strcmp('manual',{OA.XLimMode,OA.YLimMode,OA.ZLimMode});
isManual = [isManual; isManual];
isExt = strcmp('extend',{OA.XLimMode, OA.YLimMode, OA.ZLimMode});

% Update oLims with manual values where needed
manualLims = [OA.XLimI' OA.YLimI' OA.ZLimI'];
oLims(isManual) = manualLims(isManual);

% Trim manual values that are outside of pLims
idx = ([-1 -1 -1; 1 1 1].*oLims) > ([-1 -1 -1; 1 1 1].*pLims);
oLims(idx) = pLims(idx);

%% Get data needed for tick and arrow length calculations

% Render transform
rT = get(OA.hAx,'x_RenderTransform');

% Handle case of being inside an 'ObliqueView' hgtransform by hacking the
% transforms and limits
if strcmp(get(get(OA,'Parent'),'Type'),'hgtransform')
    isObliqueView = true;
    hT = get(OA,'Parent');
    if isappdata(hT,'ObliqueViewInfo')
       OV = getappdata(hT,'ObliqueViewInfo');
       M = get(hT,'Matrix');
       KT = [rT(1,OV.I)*M(OV.I,OV.K); rT(2,OV.J)*M(OV.J,OV.K)];
       rT(1:2,OV.K) = KT;
       KT = [T(1,OV.I)*M(OV.I,OV.K); T(2,OV.J)*M(OV.J,OV.K)];
       T(1:2,OV.K) = KT;
       limVec = [oLims(1,1) OA.OI(2)   OA.OI(3)   1;...
                 oLims(2,1) OA.OI(2)   OA.OI(3)   1;...
                 OA.OI(1)   oLims(1,2) OA.OI(3)   1;...
                 OA.OI(1)   oLims(2,2) OA.OI(3)   1;...
                 OA.OI(1)   OA.OI(2)   oLims(1,3) 1;...
                 OA.OI(1)   OA.OI(2)   oLims(2,3) 1]';
       limVecT = M\limVec;
       oLims = [limVecT(1,1:2)' limVecT(2,3:4)' limVecT(3,5:6)'];
       limVec = [pLims(1,1) OA.OI(2)   OA.OI(3)   1;...
                 pLims(2,1) OA.OI(2)   OA.OI(3)   1;...
                 OA.OI(1)   pLims(1,2) OA.OI(3)   1;...
                 OA.OI(1)   pLims(2,2) OA.OI(3)   1;...
                 OA.OI(1)   OA.OI(2)   pLims(1,3) 1;...
                 OA.OI(1)   OA.OI(2)   pLims(2,3) 1]';
       limVecT = M*limVec;
       pLims = [limVecT(1,1:2)' limVecT(2,3:4)' limVecT(3,5:6)'];
    end
else
    isObliqueView = false;
end

% Store transforms
OA.rT = rT;
OA.T = T;

% Data units to pixels conversion factor
OA.d2px = sqrt(sum(rT(1:2,1:3).^2));
OA.d2px(OA.d2px == 0) = 1e200;

% Log-axes linearization scale factor
OA.sf = real(log10(abs(pLims(2,:)./pLims(1,:)))./(pLims(2,:)-pLims(1,:)));

% Get linearized versions of rT and OI for log-scaled axes
rTL = OA.rT;
OL = OA.OI;
for k = find(OA.logScale)
    rTL(:,k) = OA.sf(k)*rT(:,k);
    OL(k) = pLims(1,k)+real(log10(OA.OI(k))-log10(pLims(1,k)))/OA.sf(k);
end

%% Calculate extended limits for selected axes

% Define a vector containing the plot cube corners
vec = zeros(4,8);
vec(:,1) = [pLims(1,1); pLims(1,2); pLims(1,3); 1];
vec(:,2) = [pLims(2,1); pLims(1,2); pLims(1,3); 1];
vec(:,3) = [pLims(1,1); pLims(2,2); pLims(1,3); 1];
vec(:,4) = [pLims(2,1); pLims(2,2); pLims(1,3); 1];
vec(:,5) = [pLims(1,1); pLims(1,2); pLims(2,3); 1];
vec(:,6) = [pLims(2,1); pLims(1,2); pLims(2,3); 1];
vec(:,7) = [pLims(1,1); pLims(2,2); pLims(2,3); 1];
vec(:,8) = [pLims(2,1); pLims(2,2); pLims(2,3); 1];

for k = find(~isVisibleAxis)
    vec(k,:) = OA.OI(k);
end

% Compute the pixel coordinates and get extreme pixel values
scr = rTL*vec;
IMin = min(scr(1,:));
IMax = max(scr(1,:));
JMin = min(scr(2,:));
JMax = max(scr(2,:));

if isExt(1)
    
    % Get x positions at plot cube boundaries of lines through origin
    xMinI = (IMin-(rTL(1,2)*OL(2)+rTL(1,3)*OL(3)+rTL(1,4)))/rTL(1,1);
    xMinJ = (JMin-(rTL(2,2)*OL(2)+rTL(2,3)*OL(3)+rTL(2,4)))/rTL(2,1);
    xMaxI = (IMax-(rTL(1,2)*OL(2)+rTL(1,3)*OL(3)+rTL(1,4)))/rTL(1,1);
    xMaxJ = (JMax-(rTL(2,2)*OL(2)+rTL(2,3)*OL(3)+rTL(2,4)))/rTL(2,1);
    x1 = [xMinI xMaxJ];
    x2 = [xMaxI xMinJ];
    
    % Select the values closest to the origin to use as limits
    x1 = x1(abs(x1-OA.OI(1))==min(abs(x1-OA.OI(1))));
    x2 = x2(abs(x2-OA.OI(1))==min(abs(x2-OA.OI(1))));
    xLims = sort([x1(1); x2(1)]);

    % Handle log-scaled x-axis
    if OA.logScale(1)
        oLims(1,1) = real(10.^(log10(pLims(1,1)) - ...
            OA.sf(1)*(pLims(1,1)-xLims(1))));
        oLims(2,1) = real(10.^(log10(pLims(2,1)) - ...
            OA.sf(1)*(pLims(2,1)-xLims(2))));   
    else
        oLims(:,1) = xLims';
    end
end

if isExt(2)
       
    yMinI = (IMin-(rTL(1,1)*OL(1)+rTL(1,3)*OL(3)+rTL(1,4)))/rTL(1,2);
    yMinJ = (JMin-(rTL(2,1)*OL(1)+rTL(2,3)*OL(3)+rTL(2,4)))/rTL(2,2);
    yMaxI = (IMax-(rTL(1,1)*OL(1)+rTL(1,3)*OL(3)+rTL(1,4)))/rTL(1,2);
    yMaxJ = (JMax-(rTL(2,1)*OL(1)+rTL(2,3)*OL(3)+rTL(2,4)))/rTL(2,2);
    y1 = [yMinI yMaxJ];
    y2 = [yMaxI yMinJ];
    y1 = y1(abs(y1-OA.OI(2))==min(abs(y1-OA.OI(2))));
    y2 = y2(abs(y2-OA.OI(2))==min(abs(y2-OA.OI(2)))); 
    
    yLims = sort([y1(1); y2(1)]);

    if OA.logScale(2)
        oLims(1,2) = real(10.^(log10(pLims(1,2)) - ...
            OA.sf(2)*(pLims(1,2)-yLims(1))));
        oLims(2,2) = real(10.^(log10(pLims(2,2)) - ...
            OA.sf(2)*(pLims(2,2)-yLims(2))));   
    else
        oLims(:,2) = yLims';
    end
    
end

if isExt(3)
    zMinI = (IMin-(rTL(1,1)*OL(1)+rTL(1,2)*OL(2)+rTL(1,4)))/rTL(1,3);
    zMinJ = (JMin-(rTL(2,1)*OL(1)+rTL(2,2)*OL(2)+rTL(2,4)))/rTL(2,3);
    zMaxI = (IMax-(rTL(1,1)*OL(1)+rTL(1,2)*OL(2)+rTL(1,4)))/rTL(1,3);
    zMaxJ = (JMax-(rTL(2,1)*OL(1)+rTL(2,2)*OL(2)+rTL(2,4)))/rTL(2,3);
    z1 = [zMinI zMaxJ];
    z2 = [zMaxI zMinJ];
    z1 = z1(abs(z1-OA.OI(3))==min(abs(z1-OA.OI(3))));
    z2 = z2(abs(z2-OA.OI(3))==min(abs(z2-OA.OI(3)))); 

    zLims = sort([z1(1); z2(1)]);

    if OA.logScale(3)
        oLims(1,3) = real(10.^(log10(pLims(1,3)) - ...
            OA.sf(3)*(pLims(1,3)-zLims(1))));
        oLims(2,3) = real(10.^(log10(pLims(2,3)) - ...
            OA.sf(3)*(pLims(2,3)-zLims(2))));
    else
        oLims(:,3) = zLims';
    end
    
end

%% Modify axes limits based on arrow settings

% Initial clipping limits
cLims = oLims;

if strcmp(OA.Arrow,'extend') 
    % Arrows will be placed outside of oLims where possible.  Both oLims
    % and cLims get modified depending on the X/Y/ZLimModes.
    
    % Save temporary copies of oLims and cLims for the log-scaled cases
    tmpO = oLims;
    tmpC = cLims;
    
    % Length of arrowhead
    aLen = OA.TickLengthI.*OA.ArrowAspectRatio./OA.d2px;
    
    % Length to extend axis for Arrow = 'extend'
    eLen = (OA.AxisExtend+1)*aLen;
    
    % Grow axes limits to accomodate arrowheads.  Do not grow limits where
    % the X/Y/ZLimMode is 'extend'.
    canGrow = isAuto | isManual;
    oLims = oLims + [-eLen; eLen].*canGrow;
       
    % Get tail positions of arrowheads
    aEnds = oLims + [aLen; -aLen];

    % Shrink cLims to account for arrows where the limits did not grow
    cLims = cLims - [-aLen; aLen].*~canGrow;
    
    % Handle log-scaled axes
    for k = find(OA.logScale)
        % oLims,cLims
        len = [-eLen(k); eLen(k)];
        oLims(:,k) = real(10.^(log10(tmpO(:,k)) + len.*(canGrow(:,k))));
        cLims(:,k) = real(10.^(log10(tmpC(:,k)) - len.*(~canGrow(:,k))));
        
        % Tail position of arrowheads 
        len = [aLen(k); -aLen(k)];
        aEnds(:,k) = real(10.^(log10(oLims(:,k))+len));

    end    

    % Crude hack to keep cLims from overlapping if the arrow length is long
    for k = 1:3
        if cLims(1,k) >= cLims(2,k)
            len = oLims(2,k)-oLims(1,k);
            cLims(:,k) = oLims(:,k) + 0.1*[-len; len];
        end
    end
    
    % Use cLims to test for origin/axis clipping
    kLims = cLims;
    
elseif strcmp(OA.Arrow,'end')
    % Arrows will be placed at oLims, which don't get modified.  cLims get
    % pulled in to make room for arrows.
    
    % Save a copy of cLims for the log-scaled case
    tmpLims = cLims;
    
    % Axes outer limits don't change
    % oLims = oLims;
           
    % Shrink cLims by arrow length
    sLen = OA.TickLengthI.*OA.ArrowAspectRatio./OA.d2px;
    cLims = cLims - [-sLen; sLen];
    
    % Handle log-scaled axes
    for k = find(OA.logScale)
        len = sLen(k);
        cLims(:,k) = real(10.^(log10(tmpLims(:,k)) + [len; -len]));
    end
    
    % Crude hack to keep cLims from overlapping if the arrow length is long
    for k = 1:3
        if cLims(1,k) >= cLims(2,k)
            len = oLims(2,k)-oLims(1,k);
            cLims(:,k) = oLims(:,k) + 0.1*[-len; len];
        end
    end
    
    % Arrow ends
    aEnds = cLims;
    
    % Use oLims to test for origin/axis clipping
    kLims = oLims;
    
else
    % Do not draw arrows
    
    % Use oLims to test for origin/axis clipping
    kLims = oLims;
    
    % Arrow ends (will not be drawn, but set here as a placeholder) 
    aEnds = cLims;
end

% Expand cLims and kLims by 10*eps
cLims = cLims + [-1 -1 -1; 1 1 1].*eps(cLims); 
kLims = kLims + [-1 -1 -1; 1 1 1].*eps(kLims); 

%% Calculate origin placement

% Get the current origin
OI = OA.Origin;

% Check for 'auto'/'manual' OriginMode
autoOrigin = strcmp('auto',OA.OriginMode);

% Center origin to pLims(:,n) for axes with OriginMode = 'auto'
idx = autoOrigin | isnan(OI);
for k = find(idx)
    if OA.logScale(k)
        OI(k) = 10.^mean(log10(pLims(:,k)));
    else
        OI(k) = mean(pLims(:,k)); 
    end
end

% Store unclipped values in X/Y/ZOriginI (No change for manual axes)
OA.XOriginI = OI(1);
OA.YOriginI = OI(2);
OA.ZOriginI = OI(3);

% Clip the origin using kLims
clipMask = [-OI; OI] > ([-1 -1 -1; 1 1 1].*kLims);
clip = sum([-1 -1 -1; 1 1 1].*clipMask);
OI(logical(clip)) = kLims(clipMask);

% Make the 'soft' clip mask for ticks and arrows using cLims
OA.clipMask = [-OI; OI] >= ([-1 -1 -1; 1 1 1].*cLims);
OA.clip = sum([-1 -1 -1; 1 1 1].*OA.clipMask);

% Clip oLims where origin is clipped
oLims(OA.clipMask) = OI(logical(OA.clip));

% Store the new values
OA.OI = OI;
OA.cLims = cLims;
OA.oLims = oLims;
OA.pLims = pLims;
OA.aEnds = aEnds;

% If necessary, call this function recursively to get correct limits and
% origin placement
if ~isRecursive && (any(isExt) || isObliqueView)
    calcLimits(OA,true)
end

% End of function calcLimits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function calcTextAlignment(OA) 
% Calculate horizontal and vertical alignment for axis and tick labels

% Arrays of alignment values - will index into these later
HA = {'right','left','center';...
      'left','right','center'};
VA = {'bottom','top','middle';...
      'top','bottom','middle'};

%% Determine tick label alignment

% I axis
iHR = 2 - OA.flipC(OA.ijk(1));
if (OA.ijkCIdx(1) == 2) || (OA.hvC(OA.ijk(1)) == 0)
    iHC = 3;
else
    iHC = 1 + (OA.hDir(OA.ijk(1))*OA.vDir(OA.ijk(1)) == -1);
end
iVR = 2 - OA.flipC(OA.ijk(1));
iVC = 1;

% J axis
jHR = 2 - OA.flipC(OA.ijk(2));
jHC = 2;
jVR = 1;
jVC = 3;

% K axis
kHR = 2 - OA.flipC(OA.ijk(3));
kVR = 2 - OA.flipC(OA.ijk(3));
if OA.ijkCIdx(3) == 1
    kHC = 2;
    kVC = 3;
else
    kHC = 3;
    kVC = 1; 
end

tickHA = [HA(iHR,iHC) HA(jHR,jHC) HA(kHR,kHC)];
tickVA = [VA(iVR,iVC) VA(jVR,jVC) VA(kVR,kVC)];

% Sort from ijk order to xyz order and store values
OA.tickHA = tickHA(OA.xyz);
OA.tickVA = tickVA(OA.xyz);

%% Determine axis label alignment

if strcmpi(OA.AxisLabelLocation,'side')
    OA.axHA = [OA.tickHA; OA.tickHA];
    OA.axVA = [OA.tickVA; OA.tickVA];
    return
end

lHAR = ones(1,3);
lHAC = ones(1,3);
lVAR = ones(1,3);
lVAC = ones(1,3);
uHAR = ones(1,3);
uHAC = ones(1,3);
uVAR = ones(1,3);
uVAC = ones(1,3);

% I axis
lHAR(1) = 1;
uHAR(1) = lHAR(1);
lHAC(1) = 1 + (OA.hDir(OA.ijk(1)) == -1);
uHAC(1) = 2 - (OA.hDir(OA.ijk(1)) == -1);
lVAC(1) = 3;
uVAC(1) = 3;

% J axis
lHAC(2) = 3;
uHAC(2) = 3;
lVAR(2) = 1;% + (OA.axDir(OA.ijk(2)) == -1);
uVAR(2) = lVAR(2);
lVAC(2) = 2 - (OA.vDir(OA.ijk(2)) == -1);
uVAC(2) = 1 + (OA.vDir(OA.ijk(2)) == -1);

% K axis
lVAR(3) = 1;
uVAR(3) = lVAR(3);

if OA.hv(OA.ijk(3)) == 0
    lHAC(3) = 3;
    uHAC(3) = 3;
    lVAC(3) = 2 - (OA.vDir(OA.ijk(3)) == -1);
    uVAC(3) = 1 + (OA.vDir(OA.ijk(3)) == -1);
elseif OA.ijkCIdx(3) == 2
    lHAR(3) = 1; %+ (OA.axDir(OA.ijk(3)) == -1);
    uHAR(3) = lHAR(3);
    lHAC(3) = 1 + (OA.hDir(OA.ijk(3)) == -1);
    uHAC(3) = 2 - (OA.hDir(OA.ijk(3)) == -1);
    lVAC(3) = 3;
    uVAC(3) = 3;  
else
    lHAR(3) = 1 + (OA.axDir(OA.ijk(3)) == -1);
    uHAR(3) = lHAR(3);
    lHAC(3) = 3;
    uHAC(3) = 3;
    lVAC(3) = 2 - (OA.vDir(OA.ijk(3)) == -1);
    uVAC(3) = 1 + (OA.vDir(OA.ijk(3)) == -1);
end

% Create axis alignment arrays in XYZ order
HARInd = [lHAR(OA.xyz); uHAR(OA.xyz)];
HACInd = [lHAC(OA.xyz); uHAC(OA.xyz)];
VARInd = [lVAR(OA.xyz); uVAR(OA.xyz)];
VACInd = [lVAC(OA.xyz); uVAC(OA.xyz)];

% Store values
OA.axHA = HA(sub2ind([2 3],HARInd,HACInd));
OA.axVA = VA(sub2ind([2 3],VARInd,VACInd));

% End of function calcTextSize
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
