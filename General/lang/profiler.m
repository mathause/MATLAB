function [ varargout ] = profiler( fct,  varargin )
%PROFILER for programs that can not be run by 'F5' (i.e. need input)
%
%   -memory -nomemory
%   -history
%   -timestamp
%   –detail mmex
%    profile '-detail' 'builtin'
%    profile '-detail' 'mmex'
%
%   Mathias Hauser @ ETHZ
%   Autumn 2012 v0.85   created
%   Spring 2013 v1.00   error handling
%   2013.05.27  v1.20   output arguments included
%   2013.06.10  v1.50   handling of 'scripts' (which would not be neccesary
%                       as they could be run without input)
%   2013.07.20  v1.6    moved profile off and error handling to end of fct

exception = [];

%determine if fct is a function
if ~isa( fct, 'function_handle') && nargin == 1 && ~isfunction(fct)
    profile on
    try
        evalin( 'base', fct)    
    catch exception
    end
else %its a function
    profile on
    try
        if nargout == 0
            feval(fct, varargin{:});
        else
            %nout = nargout(fct);
            varargout = cell(1, nargout);
            [varargout{:}] = feval(fct, varargin{:});
        end
    catch exception %still stop profiling and show profiler if an error occurs
    end
end

profile off
profile viewer
if ~isempty(exception)
    rethrow(exception)
end


end


