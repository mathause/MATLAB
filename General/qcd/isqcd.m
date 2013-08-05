function tf = isqcd( varargin )
%ISQCD Summary of this function goes here
%   Detailed explanation goes here


if nargin == 1
    tf = isa(varargin{1}, 'qcd');
else
    tf = cellfun(@isa, varargin, repmat({'qcd'},1,nargin));
end


end

