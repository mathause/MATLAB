function [ global_tot ] = global_total( R, map, lengthUnit )
%GLOBAL_TOTAL calculates the global total for a regular grid
%   [ global_tot ] = global_total( R, map )
%   R: georeference matrix or object
%   map: a lat x lon (x time) map
%   lengthUnit: optional = 'm', the length unit in which map is given,
%       e.g. 'km' for kg/km**2
%
%   global_total: area weighted total; size = [time 1]
%   
%
%   See also: makerefmat, referenceSphere, areaquad
% Mathias Hauser @ ETHZ Oct, 2012 (v1)


% OLD VERSION
% BW = true(size(map));
% earth = referenceSphere('earth', 'm');
% [A, cellarea] = areamat(BW, R,earth);
% weighted_map = zeros(size(map));
% for ii=1:size(map,1)
%     weighted_map(ii,:) = map(ii,:) * cellarea(ii);
% end
% global_tot = nansum(nansum(weighted_map));
% END OLD VERSION


%check if a lengthUnit is given
if ~exist('lengthUnit','var'); lengthUnit = 'm'; end

cellarea = area_of_grid( R,  lengthUnit);


%loop through latitude and multiply with area 
a = size(map,1);
for ii = 1:a
    map(ii,:,:) = cellarea(ii) * map(ii,:,:);
end
map(isnan(map)) = 0;
global_tot = sum(sum(map)); % is [1x1xtime] but we want [time x 1]
%therefore
global_tot = global_tot(:);

end


