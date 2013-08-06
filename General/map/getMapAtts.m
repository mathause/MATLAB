function [ R ] = getMapAtts( res )
%GETMAPATTS Summary of this function goes here
%   Detailed explanation goes here

if nargin == 0; res = 62; end

R = spatialref.GeoRasterReference;

if res == 62 || strcmp(res,'c')   %coarse resolution (T62)
    %top and bottom is only half the normal grid height
    dLat = 1.894736842105260;
    %only consider the whole ones
    R.Latlim = [-90 + dLat/2 90 - dLat/2];
    R.Lonlim = [0 360];
    R.RasterSize = [94 144];   %it would be [96 144] but I leave away the northern and southernmost
else    %fine resolution (0.5°)
    R.Latlim = [-90 90];
    R.Lonlim = [-180 180];
    R.RasterSize = [360 720];
end


end