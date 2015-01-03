function cords_out = mch_world2ch(lon, lat, z, opp)
% NAME:
%	mch_world2ch
%
% PURPOSE:
% This function converts world cordinate system (longitude and latitude) to
% the CH-Coordinate system.
% if opp == 'y' the conversion is done the otherway 'round -> lon,lat
% assumed as ch-x, ch-y and output is lon/lat
%
% CALLING SEQUENCE:
% cords_out = mch_world2ch(lon, lat, z, opp)
%
% EXAMPLE:
% ch_cords = mch_world2ch([9.2333, 7.4000, 7.2667], [46.4333, 46.3333, 47.0667], [], 'n')
%
% INPUTS:
% lon/lat:  two arrays containing the longitude and latitude in
%           decimal-degrees.
% z:        Altitude in WGS84-system (ellipsoidal), optional
% opp:      char opposite direction conversion ([y]/n), optional
%
% OPTIONAL INPUT PARAMETERS:
%
% OUTPUTS:
%   gtopo:  structure with all the data
%
% MISCELLANEOUS:
%  The formulas and constants are taken from:
%   Swisstopo, Näherungsläsungen für die direkte Transformation 
%   CH1903 <->  WGS84
%   http://www.swisstopo.ch/pub/down/basics/geo/system/ch1903_wgs84_de.pdf
%
% MODIFICATION HISTORY:
% Laurent Vuilleumier  16 March 2011    Minor changed (optional input,
%                                       input check + cosmetics)
% Daniel Walker        09. August 2006
%
% SETTINGS:
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize
give_z = false;
give_o = false;
wrld2ch = true;

%% Tests and interprets input

error( nargchk( 2, 4, nargin, 'struct') )

if ~isnumeric( lon ),
    error( 'Input longitude (or X) should be a numerical array' );
elseif ~isnumeric( lat ),
    error( 'Input Latitude (or Y) should be a numerical array' );
end

if nargin > 2,
    if isnumeric( z ),
        give_z = true;
    elseif ischar( z ),
        if     strcmpi( z, 'y' ),
            wrld2ch = false;
            give_o = true;
        elseif strcmpi( z, 'n' ),
            give_o = true;
        else
            error( 'Opposite direction should be y or n' );
        end
    end
end

if nargin > 3,
    if isnumeric( opp ),
        if give_z,
            error( 'Numerical inputs 3 and 4 could be interpreted as z' )
        else
            z = opp;
            give_z = true;
        end
    elseif ischar( opp ),
        if give_o,
            error( 'Char inputs 3 and 4 could be interpreted as opp' )
        elseif strcmpi( opp, 'y' ),
            wrld2ch = false;
        else
            error( 'Opposite direction should be y or n' );
        end
    end
end

if ~give_z,
    z = [];
else
    warning('luv:NoConv',...
        'Altitude-data conversion between (WGS84, CH1903) not implemented')
end

%% Performs conversion

if wrld2ch,
    
    % 1) Transform decimal-degree in seconds:
    lon = lon*3600; lat=lat*3600;
    
    % 2) build relative cordinates to Berne
    c_lon_r = 26782.5;     c_lat_r = 169028.66;
    lon_r = (lon - c_lon_r)/10000;
    lat_r = (lat - c_lat_r)/10000;
    
    % 3) Conversion to Swiss-Cordinates:
    cy1 = +600072.37;
    cy2 = +211455.93;
    cy3 =  -10938.51;
    cy4 =      -0.36;
    cy5 =     -44.54;
    
    cx1 = +200147.07;
    cx2 = +308807.95;
    cx3 =   +3745.25;
    cx4 =     +76.63;
    cx5 =    -194.56;
    cx6 =    +119.79;
    
    h1 = -49.55;
    h2 =  +2.73;
    h3 =  +6.94;
    
    y = cy1 + cy2.*lon_r + cy3.*lon_r.*lat_r + cy4.*lon_r.*lat_r.^2 + cy5.*lon_r.^3;
    x = cx1 + cx2.*lat_r + cx3.*lon_r.^2 + cx4.*lat_r.^2 + cx5.*lon_r.^2.*lat_r + cx6.*lat_r.^3;
    
    % z = WGS84,  h = CH
    if ~isempty(z)
        h = z + h1 + h2.*lon_r + h3.*lat_r;
    else
        h = nan(size(x));
    end % calculate h
    
    % in manual: y is "Rechtswert" and x is "Hochwert"
    cords_out.y = x;
    cords_out.x = y;
    cords_out.z = h;
    
else
    
    % 1) rename variables:
    y = lon;   x = lat;  % strange, but for Swisstopo: y is Rechtswert (horizontal)
    
    % 2) build relative cordinates to Berne
    c_y_r = 600000;  c_x_r = 200000;
    y_r = (y-c_y_r)/1000000;
    x_r = (x-c_x_r)/1000000;
    
    % 3) Conversion to lat/lon :
    clon1 = +2.6779094;
    clon2 = +4.728982;
    clon3 = +0.791484;
    clon4 = +0.1306;
    clon5 = -0.0436;
    
    clat1 = +16.9023892;
    clat2 =  +3.238272;
    clat3 =  -0.270978;
    clat4 =  -0.002528;
    clat5 =  -0.0447;
    clat6 =  -0.0140;
    
    h1 = +49.55;
    h2 =  -12.6;
    h3 = -22.64;
    
    lon_r = clon1 + clon2.*y_r + clon3.*y_r.*x_r + clon4.*y_r.*x_r.^2 + clon5.*y_r.^3 ;
    lat_r = clat1 + clat2.*x_r + clat3.*y_r.^2 + clat4.*x_r.^2 + clat5.*y_r.^2.*x_r + clat6.*x_r.^3 ;
    
    % 4) Transform to lat/lon
    lon = lon_r*100/36;
    lat = lat_r*100/36;
    
    % rename it for (internal) consistency:
    % z = WGS84,  h = CH
    h = z;
    if ~isempty(h)
        z = h + h1 + h2.*y_r + h3.*x_r;
    else
        z = nan(size(lon));
    end % calculate h
    
    cords_out.lon = lon;
    cords_out.lat = lat;
    cords_out.alt = z;
    
end

%keyboard