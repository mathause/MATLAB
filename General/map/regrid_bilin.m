function [ ZI ] = regrid_bilin( Z, R, RI, method )
%REGRID_BILIN interpolates the Z from R to RI
%   [ ZI ] = regrid_bilin( Z, R, RI, method )
%
%   values are assumed to be in the middle of the grid point
%
%   Z:      original grid (may be a stack of maps (axbxc, loops through c))
%   R:      GeorasterReference Object of original grid
%   RI:     GeorasterReference Object of new grid
%   method: default = 'linear' -> see interp2
%
%   ZI:     new grid
%
%   See Also:
%   interp2
%
%   Mathias Hauser @ETHZ, Nov 2012, v1


if nargin == 3; method = 'linear'; end

%get RasterSize
[a, b, c] = size(Z);

%check if the two R are correct
assert(isobject(R) & isobject(RI), 'regrid:notObj', 'R and/ or RI is not a GeorasterReference Object');
%check if the RasterSize of Z is correct
assert(isequal([a b], R.RasterSize), 'regrid:wrongRasterSZ', ...
    'Wrong Raster Size of Z / R.RasterSize');



%create lat/lon mesh for old grid
[LAT, LON, IX] = create_meshgrat(R);


if ~issorted(IX(1,:))
    %the data was sorted, so we have to 
    A = Z;
    for ii = 1:size(A,2)
        Z(:,ii,:) = A(:,IX(1,ii),:); 
    end
end

%create lat/lon mesh for new grid
[LATI, LONI, IX] = create_meshgrat(RI);


%check if the old grid spans the entire 360°
if wrapTo360(R.Lonlim(1)) == wrapTo360(R.Lonlim(2) - 360)
    %if yes: make periodic
    LON = [LON(:,end) - 360, LON, 360 + LON(:,1)];
    LAT = [LAT(:,end), LAT LAT(:,1)];
    Z = [Z(:,end,:), Z, Z(:,1,:)];
else
    warning('regrid:not360', 'The old grid does not span 360°')
end

%interpolate
ZI = NaN([RI.RasterSize, c]);
for ii = 1:c
    ZI(:,:,ii) = interp2(LON, LAT, Z(:,:,ii), LONI, LATI, method);
end


if ~issorted(IX(1,:))
    %the data was sorted, so we have to 
    A = ZI;
    for ii = 1:size(A,2)
        ZI(:,ii,:) = A(:,IX(1,ii),:); 
    end
end


end


function [LAT, LON, IX] = create_meshgrat(R)
    latlim = R.Latlim;    lonlim = R.Lonlim;
    
    %the gridpoints are defined in the middle of the grid cell
    lat = latlim(1) + R.DeltaLat/2 : R.DeltaLat : latlim(2) - R.DeltaLat/2;
    lon = lonlim(1) + R.DeltaLon/2 : R.DeltaLon : lonlim(2) - R.DeltaLon/2;
    [LAT, LON] = meshgrat(lat,lon);

    %both grids heve to start from 0 and go to 360
    LON = wrapTo360(LON); [LON, IX] = sort(LON,2);

end






