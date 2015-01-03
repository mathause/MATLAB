function qc_comb = flag_combine(flags, flag_unmatched,flag_order)
%QC_FLAG_COMBINE determines the qc flag when combining two measurements
%
%Syntax
%   qc_comb = QC_FLAG_COMBINE ( flags )
%   QC_FLAG_COMBINE(flags, flag_unmatched)
%   QC_FLAG_COMBINE(flags, [], flag_order)
%   QC_FLAG_COMBINE(flags, flag_unmatched, flag_order)
%
%Description
%   qc_comb = QC_FLAG_COMBINE( flags ) selects for every time step
%   the qc flag with the higher precedence, using the default precedence
%   order and throws an error if there are unmatched flags in the data
%
%   QC_FLAG_COMBINE(flags, flag_unmatched) dito, however, does not
%   throw an error if unmached flags are in the data but replaces them with
%   flag_unmached
%
%   QC_FLAG_COMBINE(flags, [], flag_order) dito but using the
%   indicated 'flag_order' instead of the default
%
%   QC_FLAG_COMBINE(flags, flag_unmatched, flag_order) dito using 
%   flag_order and replacing unmatched flags
%
%Input
%   flags
%       a [n x col] matrix of flags
%       [flag1 flag2]
%   flag_unmatched
%       [ [] ] | element of flag_order
%   flag_order
%       [2  1  8  -4 -3  3 -2 -1 0] | flag_order
%
%QC FLAGS
%   QC flag default order (i.e. 2 has precedence over 1 etc.)
%   [2  1  8  -4  3 -2 -1 0]
%   QC flag information is the following:
%       -4*: outlier (compare eval_calig_chg)
%       -2 : test not possible (a priori valid but no way to test)
%       -3*: thermal offset correction missing
%       -1*: valid but only one instrument in composite
%        0 : valid measurements
%        1 : suspicious meassurements
%        2 : invalid meassurements
%        3 : invalid meassurements set to 0 from constraints (solar direct)
%        8 : conflicting tests with valid/invalid assessment
%   *only used for/ during the calibration
%
%Example
%   qc_comb = qc_flag_combine([SWglo(:,3), SWdif(:,3)])
%
%
%Algorithm
%   1. replace the flags by its precedence (i.e. 2 -> 1, 1 -> 2, 8 -> 3)
%  (2. check for flags in data but not in flag_order -> problem handling
%   3. throw error or replace by flag_unmatched)
%   4. get the min of the precedence for every time step
%   5. replace the precedence again by the flag
%
%Version History
%   12.06.2013 Mathias Hauser: created
%   27.06.2013 mah             adapted for outlier_flag = -4
%
%See Also
%gvf

%set the default precedence order of the flags
default_flag_order = [2  1  8  -4 -3  3 -2 -1 0];

%VALIDATE/ PARSE INPUT
narginchk(1,3)

if nargin == 1
    flag_unmatched = [];
end

if nargin < 3
    flag_order = default_flag_order;
else
    validateattributes(flag_order, {'numeric'}, {'2d', 'nonempty', 'integer', 'real'}, mfilename, 'flag_order')
end

if isempty(flag_unmatched) %no flag_unmatched is given
    %return an error if wrong flags are in data
else %replace wrong flags in data
    %check validity of flag_unmatched
    validateattributes(flag_unmatched, {'numeric'}, {'scalar'}, mfilename, 'flag_unmatched')
    assert( any( flag_unmatched == flag_order), 'qcF_comb:wrng_flag_unmatched', ...
        '''flag_unmatched'' must be one of ''flag_order'' (%s), instead it was %g.', num2str(flag_order), flag_unmatched)
end

% qc1 = get_qc(data1);
% qc2 = get_qc(data2);
% 
% assert( isequal( size(qc1), size(qc2) ), 'qcF_comb:lt_not_eq', ...
%     'Input data must be equal in length');
%END VALIDATE/ PARSE INPUT

no_of_flags = length(flag_order);



%create the 'precedence' matrix: replace flag by their position in
%'flag_order'
qc_ordered = NaN( size(flags) );
for ii = 1:no_of_flags
    sel = flags == flag_order(ii);
    qc_ordered(sel) = ii;
end

%check if any flags are not yet assigned a precedence
if any( any( isnan(qc_ordered) ) )
    if isempty(flag_unmatched) %-> throw an error
        no_of_col = size(flags,2);
        str = cell(no_of_col, 1);
        for ii = 1:no_of_col
            str{ii} = get_num_str( flags(:,ii), flag_order, ii );
        end
        error('qcF_com:fl_missing', 'There are flags in the data that are not given in flag_order.\n%s', [str{:}])
    else %-> replace unmatched flags by 'flag_unmatched'
        sel = isnan(qc_ordered);
        str_n_flg = num2str(sum(sel), '%i,'); str_n_flg(end) = [];
        warning( 'qcF_com:fl_missing', '%s unknown flags replaced by %g',str_n_flg , flag_unmatched);
        %find the precedence of the replacement flag
        rep_flag = find( flag_unmatched == flag_order);
        %rep_flag is a number (not []) because flag_unmatched is required
        %to be an element of flag_order
        qc_ordered(sel) = rep_flag;
    end
end


%get the flag with the higher precedence
qc = min(qc_ordered, [], 2);

qc_comb = NaN( size(flags,1), 1 );

%replace the precedence by the flag again
for ii = 1:no_of_flags
    sel = qc == ii;
    qc_comb(sel) = flag_order(ii);
end




end

% function qc = get_qc(data)
% %determine wheter a [n x 1] or a [n x 3] matrix is given and return the
% %flag
% sz = size(data, 2);
% if sz == 3
%     qc = data(:,3);
% elseif sz == 1
%     qc = data;
% else
%     error('qcF_comb:wrng_sz_of_data', 'Data must be a [n x 1] or [n x 3] vector');
% end
% end


function num_str = get_num_str( qc, flag_order, ii )
%create the string for the error message
uq = unique(qc);
%find which flags are in qc but not in flag_order
C = setdiff( uq, flag_order);
%create string
if isempty( C )
    num_str = 'none';
elseif length(C) > 5
    num_str = sprintf('%g, %g... totally %i', C(1), C(2), length(C));
else
    num_str = num2str(C', ' %g,');
    num_str(end) = []; %remove trailing ,
end

num_str = sprintf('For column %i that are: %s\n', ii, num_str);
end
