function [ sel ] = gvf( qcd, valid_flags, invert )
%GVF select valid flags (default valid flags = [0, -1, -2, 3])
%
%CAUTION
%   flag 3: not ok for SWabsc
%
%Syntax
%   sel = GVF( flag )
%   sel = GVF( flag, valid_flags )
%   sel = GVF( flag, [], invert )
%   sel = GVF( flag, valid_flags, invert )
%
%Usage
%   sel = GVF( flag ) returns logical array that is true for valid flags
%   sel = GVF( flag, valid_flags ) dito but specifing the valid flags
%       manually
%   sel = GVF( flag, [], invert ) as above but returns false for valid flags
%   sel = GVF( flag, valid_flags, invert )  dito, specifing the valid flags
%
%Example
%   sel_dir  = gvf( SWdir(:,3));
%   sel_absc = gvf( SWabsc(:,3), [0, -1, -2]);
%
%Version History
%   12.06.2013 mah  created
%   27.06.2013 mah  adapted for outlier_flag = -4
%   04.07.2013 mah  added flag -3
%
%See Also
%qc_flag_combine

%assert( size(flag, 2) == 1, 'val_flag:wrngDim', 'Only give the column with the flags as input');

flag = qcd.flag;

default_valid_flags = [0, -1, -2, 3 -3];

if nargin == 1 || isempty(valid_flags)
    valid_flags = default_valid_flags;
end
if nargin < 3
    invert = false;
end


no_of_valid_flags = numel(valid_flags);

if invert
    sel = true( size(flag) );
    bool = false;
else
    sel = false( size(flag) );
    bool = true;
end



for ii = 1:no_of_valid_flags
    sel_t = flag == valid_flags(ii);
    sel(sel_t) = bool;
end


end

