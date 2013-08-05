function [ output_args ] = generic_graph(allow_several, return_time, varargin )
%GENERIC_GRAPH Summary of this function goes here
%   Detailed explanation goes here

[cax,args,nargs] = axescheck(varargin{:});

tf = isqcd(args{:});
parseValidity(tf, args{:})

error

n_qcd = sum(tf);

if ~allow_several
    assert( n_qcd == 1, 'qcd:gen_graph:only1qcdInp', 'Only one qcd input allowed')
end

if return_time
    to_plot = cell(2*n_qcd + (nargin - n_qcd) ,1);
else
    to_plot = cell(1*n_qcd + (nargin - n_qcd) ,1);
end
    
    
    
kk = 1;
for ii = 1:nargin
    if tf(ii)
        if return_time
            to_plot{kk}     = args{ii}.time;
            kk = kk + 1;
        end
        to_plot{kk} = args{ii}.data;
        kk = kk + 1;
    else
        to_plot{kk} = args{ii};
        kk = kk + 1;
    end
end





end


