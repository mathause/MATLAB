function [ pt ] = pathFinder_generic( varargin )
%pathFinder_generic returns absolute paths, relative to this file
%
%Intended Use
%   Returns the absolute path of folders relative to this file to make
%   projects portable (to make programs/data accessible from various
%   computers). Works cross-platform.
%
%Syntax
%   pt = pathFinder_generic()
%   pt = pathFinder_generic(fb)
%   pt = pathFinder_generic('folder', ...)
%   pt = pathFinder_generic(fb, 'folder', ...)
%
%Usage
%   pt = pathFinder_generic() retutns absolute path going 'default_fb'
%       folders up the folder tree
%   pt = pathFinder_generic(fb) fb is the number of folders to go up the 
%       file tree
%       default: 1 (change in file)
%   pt = pathFinder_generic('folder', ...) appends 'folder' to the default
%       path. Specify as many folders as needed.
%   pt = pathFinder_generic(fb, 'folder', ...) set the number of folders to
%       go up the three and apppend 'folder'
%
%Examples
%   pt = pathFinder_generic(0); %return path of this file
%   pt = pathFinder_generic(2);
%   pt = pathFinder_generic('data');
%
%   Mathias Hauser @ ETHZ 04.04.2011
%   Version 3
%
%See Also
%   mfilename | fullfile | fileparts

%08.05.2012 automatic truncation 
%26.10.2012 addition of folders  
%29.04.2013 plausibility checks  
%26.07.2013 can add 'folder' as the first input// updated documentation

default_fb = 1;

if nargin == 0 || ischar(varargin{1})
    fb = default_fb;
    folders = varargin;
else
    fb = varargin{1};
    validateattributes(fb,{'numeric'},{'scalar', 'integer', 'nonnegative'}, mfilename, 'fb');
    folders = varargin(2:end);
end

assert(iscellstr(folders), 'pf:notCellstr', 'Folder names must be strings')


%get the filename and path of this file
pt=fileparts(mfilename('fullpath'));
%return to the folder above 'programs'
%path = path(1:end-9);



%determine how many folders you want to go up, from the point this file is saved
if fb ~= 0
    sep = strfind(pt,filesep); %find the folders
    %make sure the path exists
    assert(numel(sep) >= fb, 'pF:tooMayFolders', ...
        'You want to go %i folders up (fb), however there are only %i folders above this location (%s).', fb, numel(sep), pt)
    pt = pt(1:sep(end-(fb-1))); %truncate the full file name
end

if nargin  > 0
    pt = fullfile(pt, folders{:});
end

end


