function [st, message] = qcd_check_integrity( obj, to_check )




st = 0;
message = '';
if ~isequal(length(obj.time),length(obj.data))
    st = 1;
end

flag = obj.flag_intern;
if ~isequal(size(flag), [1 1]) && length(obj.time) ~= length(flag)
    st = st + 2;
end

if st
    
    if nargin == 1; to_check = st; end
    
    switch to_check
        
        case 'time'
            message = 'time must have the same length as the existing data.';
        case 'data'
            message = 'data must have the same length as the existing time.';
            
        case {'flag', 2}
            message = 'flag must either be scalar or have the same length as the existing data/time.';
            
        case 1
            
            
            message = 'data and time must have the same length.';
            
        case 3
            message = 'data and time must have the same length. flag must either be scalar or have the same length as data/time.';
            
            
            
        otherwise
            
            
    end

    
    error('qcd:check_integr', message)
    
    
end





end