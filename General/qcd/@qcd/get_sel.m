function [sel, sel_ind] = get_sel(varargin)

tf = isqcd(varargin{:});
assert( equal_time(varargin{tf}), 'qcd:get_sel:eq_time', ...
    'All qcd objects must have equal time.') ;


not_qcd = ~tf;

n_qcd = sum(tf);
IDX_q  = find(tf);
IDX_nq = find(not_qcd);
ndat = varargin{IDX_q(1)}.ndat;


all_valid = false;
comb = false;




lp = find( IDX_nq < IDX_q(1));

sel_input = true;

for ii = lp
    this = varargin{ii};
    if islogical(this)
        
        assert( isequal(length(this), ndat), 'qcd:gen_graph:log_eq_length', ...
            'The logical array, must have the same length than the qcd objects.')
        
        sel_input = sel_input & this;
        
        
    elseif strcmp(this, '-all')
        continue
        
    elseif strcmp(this, '-val')
        all_valid = true;
        comb = false;
    elseif strcmp(this, '-comb')
        comb = true;
    else
        continue
    end

end


sel_ind = true(ndat, n_qcd);
if all_valid || comb
    for ii = 1:n_qcd
        sel_ind(:,ii) = gvf( varargin{IDX_q(ii)}) & sel_input;
    end
end

if comb
    sel = all(sel_ind, 2);
    if nargout > 1
        sel_ind = sel(:, ones(1, n_qcd));
    end
end

if all_valid
   sel = []; 
end

% for ii = IDX_q
% 
%     
%     this = varargin{ii + 1};
%     
%     
%     
%     if islogical(this)
%         assert( length(this) == varargin{ii}.nbdat, 'qcd:gen_graph:nbdat', 'logical array must have the same length than the qcd object.') 
%     elseif strcmp(this, '-all')
%         continue
%     elseif strcmp(this, '-val') || all_val
%         this = gvf(varargin{ii});
%     else
%         continue
%     end
% 
%     
%     
%     
%     
% end
%     
%     
%     
%     
%     
%         
%         if islogical(this)
%             selection{1}.sel = this; 
%         end
%             
%             
%     strcmpi('-all', this)
%     strcmpi('-val', this)
%     strcmpi('-comb', this)
%     
    

% '-all'
% '-val'
% '-comb'



end
