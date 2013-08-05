function [ tf ] = equal_time( varargin )
%EQUAL_TIME Summary of this function goes here
%   Detailed explanation goes here

%about 20 - 30 times faster than comparing the actual time vectors

if nargin == 2
    tf = isequal( varargin{1}.time_hash, varargin{2}.time_hash);
else
    tm = cellfun( @(x) x.time_hash, varargin, 'UniformOutput', false);
    tf = isequal( tm{:});
end



end

