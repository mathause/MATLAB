function [ h ] = plot( varargin )
%PLOT Summary of this function goes here
%   Detailed explanation goes here

tf = isqcd(varargin{:});





n_qcd = sum(tf);

to_plot = cell(2*n_qcd + (nargin - n_qcd) ,1);

kk = 1;
for ii = 1:nargin
    if tf(ii)
        to_plot{kk}     = varargin{ii}.time;
        to_plot{kk + 1} = varargin{ii}.data;
        kk = kk + 2;
    else
        to_plot{kk} = varargin{ii};
        kk = kk + 1;
    end
end
    
if nargout == 0
    plot(to_plot{:})
else
    h = plot(to_plot{:});
end


end

