function [  ] = backup( from, to, def )
%BACKUP makes a backup of files and folders
%
%   stores the files in 'from' in the folder 'to'; includes subfolders
%   only saves files if they are younger than the ones in 'to'
%
%   CAUTION: default does NOT keep files/ folders in the backup folder
%       that are deleted in 'from'
%
%   INPUT
%   from: folder of which to create the backup
%   to:   folder where to create the backup
%   def:  structure defining how 'backup' works
%       def.max_size:   maximum size of files to be stored (1024^2 = 1Mb)
%       def.del_old:    logical indicating whether to delete files/ folders
%           (and files and subfolders within) if they are deleted in the
%           source folder. Default: [true] (!)
%       def.exclude:    file or folders, which are NOT to backed up.
%           Must be a cell with the folder/file names. For sub folders, use
%           again a cell within the cell (see example)
%           to exclude e.g. pdfs add: *.pdf (also excludes *.pdf.notPDF)
%           CAUTION: don't forget the file ending!
%
%   EXAMPLE
%   from = 'C:\...\Matlab';
%   to   = 'D:\...\Backup\Matlab';
%   def.max_size = Inf;
%   def.del_old  = false; %accumulates old files/folders
%   def.exclude = {'LargeFiles', {'A', 'Fold'}, 'File.m', {'A', 'File2.m'}}
%   this excludes the folders
%   'C:\...\Matlab\LargeFiles' and 'C:\...\Matlab\A\Fold'
%   and the files
%   'C:\...\Matlab\File.m' and 'C:\...\Matlab\A\File2.m' from the backup.
%
%   LIMITATIONS/ TO DO
%   -   issue warning (dialog box) if a file is deleted(?)
%   -   indicate files that are not copied due to size restraints(?)
%   -   there is no program to restore the data  (do it manually)
%   -   does not save information about the backup (e.g. time of execution)
%   -   does not allow to go back to an intermediate state
%   -   make it a real 'incremental' or 'differential' backup system
%   -   convert input to: from -> source; to -> destination (?)
%   -   convert input to: (source_root, destination_root, folder, def) (?)
%       source_root      = 'C:\...'
%       destination_root = 'D:\...\Backup'
%       folder           = 'Matlab'
%
%   Mathias Hauser @ MeteoSwiss
%
%   2013.05.14  mah     created
%   2013.05.15  mah     input parsing
%                       exclusion of folders
%                       delete nonexisting files or folders
%   2013.07.22  mah     replaced strcmp by regexp to exclude .pdf etc

%INPUT CHECKING/ PARSING

narginchk(3,3)
try
    [from, to, def] = parse_input(from, to, def);
catch exception
    throw(exception)
end
%END INPUT CHECKING/ PARSING
%call the backup function
loop_through_files_folders(from, to, def)

end


function loop_through_files_folders(from, to, def)
%recursive function to execute the backup

%get all files/folders at source
lst_from_whole_folder = dir(from);
no_of_lst = length(lst_from_whole_folder);

%get all files/folders at destination (do this only once per folder)
lst_to_whole_folder = dir(to);

%logical array to check which files exist in 'to' that do not exist in
%'from'
%assume all are deleted (this is not a good assumption, I would like to do
%it the other way around but it's easier this way)
to_file_exists_not_in_from = true(size(lst_to_whole_folder));

%get rid of 'folder' ('.') and folder above ('..')
sel = strcmp({lst_to_whole_folder(:).name}, {'.'}) | strcmp({lst_to_whole_folder(:).name}, {'..'});
to_file_exists_not_in_from(sel) = false;

%loop through files/ folders that are (potentially) to copy
for ii = 1:no_of_lst
    %lst_from is the current lst entry
    lst_from = lst_from_whole_folder(ii);
    
    %skip if it is the current folder ('.') or the folder above ('..')
    if any(strcmp(lst_from.name, {'.', '..'})); continue; end
    
    %get the path of the file and the destination path
    curr_from = fullfile(from, lst_from.name);
    
    %if the file/folder 'curr_from' is in the 'exclude' list, skip it
    %replace the escape sequence of regexp (\) by /
    if isfield(def, 'exclude') && any(~cellfun( @isempty, regexp(strrep( curr_from, '\', '/'), def.exclude))) % was: any(strcmp(curr_from, def.exclude));
        continue;
    end
    
    %full path in backup folder
    curr_to = fullfile(to, lst_from.name);
    
    %check if the file/folder already exists in the backup folder
    sel = strcmp(lst_from.name, {lst_to_whole_folder(:).name});
    if any(sel) %it exists
        lst_to = lst_to_whole_folder(sel);
        %indicate that this file exists in 'from'
        to_file_exists_not_in_from(sel) = false;
    else %it does not exist
        lst_to = [];
    end
    
    %if the current file is a folder
    if lst_from.isdir
        
        %create folder in 'to' if it does not exist
        if isempty(lst_to)
            [success, message] = mkdir(curr_to);
            if ~success
                error('backup:mkdir', 'The folder ''%s'' could not be created.\n%s', curr_to, message)
            end
        end
        
        %recursively call this function to go through the subfolder
        loop_through_files_folders(curr_from, curr_to, def)
        
    else %it is a file
        
        %this may have to be changed in a future version, to leave more
        %possibilities for customisation
        
        %copy the file only if
        % (1) it does not exist in the backup
        % - or -
        % (2) it is newer than the one in the backup
        % - and -
        % (3) it is smaller than the defined def.max_size
        % i.e.: ((1) || (2)) && (3)
        % ((1) || (2)) -> explanation: if (1) is true, (2) can not be
        % evaluated (because 'lst_to.datenum' does not exist), then the
        % Short-Circuit Logical OR (||) ensures that (2) is not evaluated
        % and thus it does not throw an error
        
        if (isempty(lst_to) || lst_from.datenum > lst_to.datenum)  && lst_from.bytes <= def.max_size
            %copy the files
            [success, message] = copyfile(curr_from, curr_to);
            if ~success
                %replace by warning?
                error('backup:copyfile', 'Could not copy file (%s) to (%s).\n%s', curr_from, to, message)
            end
            %copyfile is faster than dos('copy ...')
        else
            
            
        end %if
        
    end %if dir
end %for


%delete files in 'to' if they do not exist in 'from' any more
%   only if
%   (1) def.del_old
%   - and -
%   (2) there are files to be deleted
if def.del_old && any(to_file_exists_not_in_from)
    %find the files that have to be deleted
    IDX = find(to_file_exists_not_in_from);
    %loop through them
    for ii = IDX'
        %assign to 'local structure'
        lst_to = lst_to_whole_folder(ii);
        %create full name
        curr_to = fullfile(to, lst_to.name);
        if lst_to.isdir
            rmdir(curr_to, 's'); %delete folder and its content!
        else
            delete(curr_to);
        end %if
    end %for    
end %if


end

function [from, to, def] = parse_input(from, to, def)
%check and parse the input

validateattributes(from,{'char'},{'nonempty'}, mfilename, 'from')
validateattributes(to,{'char'},{'nonempty'}, mfilename, 'to')
validateattributes(def,{'struct'},{}, mfilename, 'def')

assert(~isequal(from,to), 'backup:from_eq_to', 'The source and destination folder are equal (%s).', from)

lst = dir(from);
assert(~isempty(lst), 'backup:from_not_exist', 'The source folder (%s) does not exist.', from)

%if the destination folder does not exist, create it
%this surpasses the problem that if an empty folder is indicated for backup
%(or all content is 'excluded'), the main folder (from) is not created in
%the backup folder (to), which may be confusing.
lst = dir(to);
if isempty(lst)
    [success, message] = mkdir(to);
    if ~success
        error('backup:mkdir', 'The backup folder ''%s'' could not be created.\n%s', to, message)
    end
end


assert(isfield(def, 'max_size'), 'backup:mx_sz', ...
    'def must contain the field ''max_size'' (set to Inf to copy all files)');

validateattributes(def.max_size,{'numeric'},{'scalar', 'positive'}, mfilename, 'def.max_size')

if isfield(def, 'del_old')
    validateattributes(def.del_old,{'logical'},{'scalar'}, mfilename, 'def.del_old')
else
    %issue warning?
    def.del_old = true;
end


%input parsing of def.exclude
if isfield(def, 'exclude') %the field is not nessesary
    if isempty(def.exclude)
        %remove the field if it is empty -> faster
        def = rmfield(def, 'exclude');
    else %if
        validateattributes(def.exclude,{'cell'},{'nonempty'}, mfilename, 'def.exclude')
        no_of_excluded_fields = numel(def.exclude);
        %loop through the files/ folders that are excluded
        %create the FULL filenames of the folders that have to be excluded
        for ii = 1:no_of_excluded_fields
            if iscell(def.exclude{ii}) %if there are subfolders
                def.exclude{ii} = fullfile(from, def.exclude{ii}{:});
                %replace \ by /. \ is the escape sequence of regexp
                def.exclude{ii} = strrep( def.exclude{ii}, '\', '/');
            else %if
                %no subfolders
                if strfind( def.exclude{ii}, '*')
                    %keep as is
                    def.exclude{ii} = strrep( def.exclude{ii}, '*', '\w*');
                else
                    def.exclude{ii} = fullfile(from, def.exclude{ii});
                    %replace \ by /. \ is the escape sequence of regexp
                    def.exclude{ii} = strrep( def.exclude{ii}, '\', '/');
                end
            end %if
            %I feared that it would not back up the main folder if you
            %indicate '' as a folder to skip, however, this seems not to be
            %the case
%             if strcmp(from, def.exclude{ii})
%                 error('backup:excl:empty', 'def.exclude can not contain an empty string (''''). It would not backup anything at all.')
%                 
%             end

        end %for
    end %if

    
end %if
%END input parsing of def.exclude



end
