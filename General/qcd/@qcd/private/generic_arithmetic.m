function [obj, val] =  generic_arithmetic(a, b)

if ~isqcd(b)
    obj = a;
    val = b;

elseif ~isqcd(a)
    obj = b;
    val = a;        
else %both are qcd
    if equal_time(a,b)
        obj = a;
        val = b.data;
        obj.flag = flag_combine([obj.flag, b.flag]);
    else
        error('qcd:gen_ari:qcd_ne_time', 'The two qcd objects do not have an equal time base.')
    end    
end



end