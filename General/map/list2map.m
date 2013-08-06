function [ map, R ] = list2map( lat, lon, data, R )
%list2map converts a list of geographic data to a map
%
%   Warning: At the moment is assumes that lat lon is at the lower left
%   edge of the grid cell! (or is it rather the middle)
%
%   lat1, lon1, datapoint11, datapoint12...
%   ...
%   latN, lonN, datapointN1, datapointN2...
%
%   to a georeferenced map
%
%   data can be a N x M matrix, where M is a number of dates
%
%   R is optional; if not provided, it is constructed from data
%
%   Mathias Hauser @ETHZ; Oct 2012 (v1)


%check input
classes = {'numeric'};
validateattributes(lat, classes, {'column'})
a = size(lat,1);
validateattributes(lon, classes,{'size', [a 1]})
validateattributes(data, classes,{'size', [a NaN]})


if ~exist('R','var') %estimate R from data
    dLat = mode(diff(unique(lat))); %the most often occuring distance
    dLon = mode(diff(unique(lon))); %is estimated as dLat & dLon
    
    a = 180/dLat; b = 360/dLon; %find the number of gridcells; a:lat b:lon
    
    latlim = [-90 90]; %always the same
    lonlim = [0 360]; %ialways the same beacause lon will be wrapped
    
    %Create GeoRasterReference
    R = spatialref.GeoRasterReference;
    R.RasterSize = [a b];
    R.Latlim = latlim;
    R.Lonlim = lonlim;
else %a GeorasterReference is given
    if ~isobject(R) %if it is not an GRR object; make one
        R = refmatToGeoRasterReference(R, [180/R(1,2) 360/R(2,1)]);
    end
    %get delta Lat / Lon and grid size from R
    dLat = R.DeltaLat; dLon = R.DeltaLon;
    a = diff(R.Latlim)/dLat; b = diff(R.Lonlim)/dLon;
end

%end input check

lon = wrapTo360(lon); %convert e.g. -17N° to 343N°

%the smallest latitude has to be 0
add_lat = R.Latlim(1);
if mod(add_lat,dLat) == dLat/2; %the lat/lon is interpreted as the middle of the grid cell
    add_lat = add_lat + dLat/2; 
end


%get indices of the grid
lat_ind = (lat - add_lat) / dLat + 1;
lon_ind = (lon) / dLon + 1; %nothing added because wrapped
%convert to a liner index
linearInd = lat_ind + (lon_ind - 1) * a;

%check if a lat/lon combination is given twice
if length(linearInd) ~= length(unique(linearInd))
    linearInd_sort = sort(linearInd);
    sel = ~[1; diff(linearInd_sort)];
    [row, col] = ind2sub(R.RasterSize,linearInd_sort(sel));
    [lat, lon] = pix2latlon(R,row,col);
    warning('list2map:doubleEntry','The following lat/ long values appear more than once')
    disp([lat, lon])
end


c = size(data,2);

map_single = NaN(a,b);
map = NaN(a,b,c);

%loop through all the given data columns
for ii = 1:c
    map_single(linearInd) = data(:,ii);
    map(:,:,ii) = map_single;
    map_single = NaN(a,b);
end


end