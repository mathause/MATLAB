function [ varargout ] = profiler( fct,  varargin )
%PROFILER profile functions requiring input (i.e. can not be run by 'F5')
%
%Syntax
%   PROFILER(fhandle, x1, ..., xn)
%   PROFILER(fname, x1, ..., xn)
%   [y1, y2, ...] = PROFILER(...)
%
%Usage
%   PROFILER(fhandle, x1, ..., xn) runs the PROFILER for the function given
%       in fhandle using arguments x1 through xn. If fhandle needs no
%       input, x1 through xn can be left out.
%   PROFILER(fname, x1, ..., xn) dito, but fname is a quoted string
%       containing the name of the function that is to execute.
%   [y1, y2, ...] = PROFILER(...) also returns output. If y1 is not given
%      the standard output is supressed.
%
%Examples
%   PROFILER( @peaks )
%   PROFILER( @std, rand(1000,1))
%   Z = PROFILER( @peaks, 5 );
%
%Version History
%   Mathias Hauser @ ETHZ
%   Autumn 2012 v0.85   created
%   Spring 2013 v1.00   error handling
%   2013.05.27  v1.20   output arguments included
%   2013.06.10  v1.50   handling of 'scripts' (which would not be neccesary
%                       as they could be run without input)
%   2013.07.20  v1.6    moved profile off and error handling to end of fct
%   2013.08.15  v1.7    use new isfunction fct, handling of function_handle
%                       of scripts, doc
%   2013.11.05  v1.8    introduced onCleanup object
%
%Known Issues
%   when terminating input('promt', 's'); with CTRL + C try does not work
%       correctly and the onCleanup object is not evaluated (i.e. profiling
%       does not stop; this is not really an issue of the PROFILER but of 
%       Matlab)
%
% See Also
% profile | feval | evalin | isfunction

exception = [];

cleanupObj = onCleanup(@cleanup);

if nargin == 1 && ~isfunction(fct) %determine if fct is a script
    if isa( fct, 'function_handle'), fct = func2str(fct); end
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
            varargout = cell(1, nargout);
            [varargout{:}] = feval(fct, varargin{:});
        end
    catch exception %still stop profiling and show profiler if an error occurs
    end
end


if ~isempty(exception)
    rethrow(exception)
end

    function cleanup
        profile off
        profile viewer
    end
end
