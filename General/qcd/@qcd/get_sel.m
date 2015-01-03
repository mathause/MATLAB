function [sel, args] = get_sel(varargin)

tf = isqcd(varargin{:}); %get all qcd obj

if sum(tf) > 1
assert( equal_time(varargin{tf}), 'qcd:get_sel:eq_time', ...
    'All qcd objects must have equal time.') ;
end


%default values
valid = true;
comb = false;
%end default values



not_qcd = ~tf;

n_qcd = sum(tf);
IDX_qcd  = find(tf);
IDX_nqcd = find(not_qcd);
ndat = varargin{IDX_qcd(1)}.ndat;





sel_sel_args = IDX_nqcd < IDX_qcd(1);
lp = find(sel_sel_args); %find non qcds befor the first qcd

sel_input = true;


for ii = lp
    this = varargin{ii};
    if islogical(this)
        assert( isequal(length(this), ndat), 'qcd:gen_graph:log_eq_length', ...
            'The logical array, must have the same length than the qcd objects.')

        sel_input = sel_input & this;
    elseif strcmp(this, '-all')
        comb  = false;
        valid = false;
    elseif strcmp(this, '-val')
        comb  = false;
        valid = true;
    elseif strcmp(this, '-comb')
        comb = true;
        valid = true;
    else
        error('qcd:get_sel:prec', 'Only (a) an axes handle (b) ''-all'', ''-val'' or ''-comb'' or a logical array can precede the first qcd object in a plot.')
    end

end

tf = isqcd(varargin{:}); %get all qcd obj
IDX_qcd  = find(tf);


sel = true(ndat, n_qcd);
if valid || comb
    for ii = 1:n_qcd
        sel(:,ii) = gvf(varargin{IDX_qcd(ii)}) & sel_input;
    end
end

if comb
    sel_comb = all(sel, 2);
    sel = sel_comb(:, ones(1, n_qcd));
end


if nargout == 2
    args = varargin;
    args(lp) =[];
end
    
end
