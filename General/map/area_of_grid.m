function [ cellarea, earth ] = area_of_grid( R,  lengthUnit)
%AREA_OF_GRID calculates the area of the grid cells as specified in R
%   R: georeference matrix or object
%   lengthUnit: optional = 'm', the length desired for output,
%       e.g. 'km' for km**2
%
%   cellarea: a column vector with the size of each gridcell, starting from
%   the smalles latituede (e.g. -90�)
%
%   Detailed explanation goes here


%check if a lengthUnit is given
if ~exist('lengthUnit','var'); lengthUnit = 'm'; end


if ~isobject(R)
    R = refmatToGeoRasterReference(R, size(map));
end

latlim = R.Latlim;
earth = referenceEllipsoid('wgs84', lengthUnit);

%earth = referenceSphere('earth', lengthUnit);


edgelats = linspace(latlim(1), latlim(2), 1 + R.RasterSize(1))';
lat1 = edgelats(1:end-1);
lat2 = edgelats(2:end);
lon1 = zeros(size(lat1));
lon2 = lon1 + abs(R.DeltaLonNumerator / R.DeltaLonDenominator);

%find area of a grid cell
cellarea = areaquad(lat1, lon1, lat2, lon2, earth, 'degrees' );



end

