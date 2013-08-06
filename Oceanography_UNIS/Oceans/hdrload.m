function [header, data] = hdrload(file)
fid=fopen(file);

if nargin < 1
   error ('Function requires one input argument');
elseif ~isstr(file)
   error ('Input argument must be a string representing a filename');
end
fid=fopen(file);
if fid==-1
   error('File not found or permission denied');
end

no_lines=0;
max_line=0;
ncols=0;

data=[];

line=fgetl(fid);
if ~isstr(line)
   disp('Warning: file contains no header and no data')
end;
[data, ncols, errmsg, nxtindex] = sscanf(line, '%f');

while isempty(data)|(nxtindex==1)
   no_lines = no_lines+1;
   max_line=max([max_line, length(line)]);
   eval(['line',num2str(no_lines),'=line;']);
   line=fgetl(fid);
   if ~isstr(line)
      disp('Warning : file contains no data')
      break
   end;
   [data,ncols,errmsg,nxtindex]=sscanf(line,'%f');
end 
data=[data; fscanf(fid,'%f')];
%data=[data; csvread(file)];

fclose(fid);
header =setstr(' '*ones(no_lines, max_line));
for i=1:no_lines
   varname = ['line' num2str(i)];
%   eval(['header(i, 1:length(' varname '))=' varname ';']);
end
eval('data = reshape(data, ncols, length(data)/ncols)'';', '');
