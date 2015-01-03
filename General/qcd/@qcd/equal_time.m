function [ tf ] = equal_time( varargin )
%EQUAL_TIME checks if time vectors are equal for qcd objects
%   compares the time hash for speed

%about 20 - 30 times faster than comparing the actual time vectors


if nargin == 2 %fast version for n = 2
    tf = isequal( varargin{1}.time_hash, varargin{2}.time_hash);    
else
    if nargin == 1 %expects a matrix of qcd objects
       tm = {varargin{1}.time_hash}; 
    else %several single qcd objects as input
        tm = cellfun(@(x) x.time_hash, varargin, 'UniformOutput', false);
    end
    tf = isequal(tm{:});
end



end

