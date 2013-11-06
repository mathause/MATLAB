function [obj, val] =  generic_arithmetic(a, b)
%GENERIC_ARITHMETIC generic function used for qcd/plus, qcd/times etc.
%
%For internal use only
%
%Syntax
%   [obj, val] = GENERIC_ARITHMETIC(a, b)
%
%Input
%   a, b can either be two qcd objects (with the same time) or one qcd
%       object and one scalar/matrix (with the same size as obj.data)
%       When giving one qcd object and one matrix the order is not
%       important,
%
%Output
%   obj is a qcd object (when giving two qcd objects obj.flag is the
%      combination of a.flag and b.flag)
%   val is either the scalar/matrix or the data of the second qcd object
%
%   Mathias Hauser @ MCH
%
%See Also
%qcd/flag_combine | qcd/plus | qcd/minus | qcd/times | qcd/mtimes

%at least one of a/b is a qcd object
if ~isqcd(b)
    obj = a;
    val = b;
elseif ~isqcd(a)
    obj = b;
    val = a;        
else %both are qcd
    assert(~ (isempty(a) | isempty(b)), 'qcd:gen_ari:qcd_empty', 'One (or both) qcd objects are empty.')
    if equal_time(a,b)
        obj = a;
        val = b.data;
        obj.flag = flag_combine([obj.flag, b.flag]);
    else
        error('qcd:gen_ari:qcd_ne_time', 'The two qcd objects do not have an equal time base.')
    end    
end



end
