function tf = isfunction( fct )
%isfunction true for functions (false for scripts)
%
%Syntax
%   tf = isfunction( fct )
%
%Usage
%   tf = isfunction( fct ) determines if fct is a function or a script
%
%Input
%   fct     can be a string (e.g. 'max') or a function handle (e.g. @max)
%
%Example
%   tf = isfunction(@isfunction)
%   tf = isfunction('name_of_script')
%
%With ideas from
%   http://stackoverflow.com/questions/15910210/
%
%TO DO
%   use which instead of exist(?)
%
%Version History
%   11.06.2013 Mathias Hauser   created
%   15.08.2013 Mathias Hauser   using nargin(fct), p-files, function_handle
%
%See Also
% function | script | function_handle


if isa( fct, 'function_handle')
    %using 'functions(fct)' could be better, however its use is discuraged
    fct = func2str(fct);
    assert( ~strcmp(fct(1), '@'), 'isfct:anonymous_fct', 'Anonymous Function')
end

assert(ischar(fct), 'isFct:not_str_or_fcn_hdl', ...
    'Input must be a string or a function handle.')


if strfind(fct, '.')
    if any(strcmp(fct(end-1:end), {'.m', '.p'} ))
    else
        error('isfct:wrngFileEnd', 'Wrong File ending')
    end
end


kind = exist( fct );

tf = true;
switch kind
    
    case 0
        error('isfunction:not_ex', 'The file %s does not exist', fct);
    case {2, 6} %m and p files
        try
            nargin(fct);
        catch err
            % If nargin throws an error and the error message does not match the specific one for script, then the input is neither script nor function.
            if( strcmp( err.identifier, 'MATLAB:nargin:isScript' ) )
                tf = false;
            end
        end

     case 5 %built-in function
    otherwise
        tf = false; 
end


end