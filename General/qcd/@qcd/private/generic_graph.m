function [ cax, to_plot ] = generic_graph(allow_several, return_time, varargin )
%GENERIC_GRAPH Summary of this function goes here
%   Detailed explanation goes here
%
%See Also
% qcd/get_sel

[cax,args] = axescheck(varargin{:});

if isempty(cax)
    cax = gca;
end

assb(args)
[sel, args] = get_sel(args{:});


nargs = numel(args);


tf = isqcd(args{:});
%parseValidity(tf, args{:})

n_qcd = sum(tf);



if ~allow_several
    assert(n_qcd == 1, 'qcd:gen_graph:only1qcdInp', 'Only one qcd input allowed')
end



if return_time
    to_plot = cell(2*n_qcd + (nargs - n_qcd) ,1);
else
    to_plot = cell(1*n_qcd + (nargs - n_qcd) ,1);
end
    
    
kk = 1;
for ii = 1:numel(tf)
    if tf(ii)
        if return_time
            to_plot{kk}     = args{ii}.time;
            kk = kk + 1;
        end
        to_plot{kk} = args{ii}.data;
        to_plot{kk}(~sel(:,ii)) = NaN;
        kk = kk + 1;
    else
        to_plot{kk} = args{ii};
        kk = kk + 1;
    end
end





end


