function [ h ] = surfmm( Z,R,varargin )
%plots a geographic grid correctly
%pads NaN right and at the bottom, such that a geographic projection plots
%the map correctly
%   
%   Mathias Hauser @ETHZ, Autumn 2012



if ~isobject(R)
    R = refmatToGeoRasterReference(R, size(Z));
end

latlim = R.Latlim;
lonlim = R.Lonlim;
%latlim(2) = latlim(2) + R.DeltaLat;
%lonlim(2) = lonlim(2) + R.DeltaLon;


assert(isequal(size(Z), R.RasterSize), 'surfmm:wrongRasterSZ', ...
    'Wrong Raster Size of Z / R.RasterSize');

[LAT, LON] = meshgrat(latlim, lonlim, size(Z) + 1);

LON(LON == 180) = 180 - 10^-10;


Z = [Z, NaN(size(Z,1),1)];
Z = [Z; NaN(1,size(Z,2))];

if nargout == 0
    surfm(LAT,LON, ones(size(Z)), 'CData', Z);
    %surfacem(LAT,LON, ones(size(Z)), 'CData', Z,'Clipping','Off');
else
    h = surfm(LAT,LON, zeros(size(Z)), 'CData', Z);
end
    
    
end

