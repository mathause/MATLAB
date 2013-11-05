function status_string(status, total, method, erase)
%STATUS_STRING displays string indicating progress in the command window
%
%Syntax
%   STATUS_STRING(status, total)
%   STATUS_STRING(status, total, method)
%   STATUS_STRING(status, total, method, erase)
%   STATUS_STRING(status, total, [], erase)
%
%Usage
%   STATUS_STRING(status, total) displays a string indicating the progress
%       in the command window
%   STATUS_STRING(status, total, method)  choose the method to display the
%       progress
%   STATUS_STRING(status, total, method, erase) choose if the message gets 
%       erased at the last step
%   STATUS_STRING(status, total, [], erase) dito, using default method
%
%Input
%   status  [positive number .le. total]
%   total   [positive number]
%   erase   [{true} | false]
%   method  [{'pluses'} | 'number' | 'percent']
%
%Example
%   STATUS_STRING   %use included example
%
%   for ii= 1:10; pause(0.1); STATUS_STRING(ii, 10, 'number',false); end
%
%Caveats/ Warnings
%   - cannot run more than one status information at the same time
%   - if invoking program ended with an error, this function might delete
%       some text on the command window
%   - the invoking function is not allowed to display any text on the
%       command window (during the loop in which STATUS_STRING is used)
%
%Version History
%   21.10.2013  MathiasHauser@MCH
%
%See Also
%   fprintf | waitbar

%use persistent variables to get info about last call
persistent msg status_last total_last

% EXAMPLE CALL (no input)
if nargin == 0
    warning('staus_str:tst_mode', 'No input. Entering test/ demo mode.')
    tot  = 255;
    for stat= 1:tot
        pause(0.002)
        status_string(stat, tot)
    end
    return
end
% END EXAMPLE CALL (no input)


%assign defaults
if nargin < 3 || isempty(method); method = 'pluses'; end
if nargin < 4; erase = true;      end


% INPUT CHECKS
if status > total
    warning('status_string:status_gt_total', ...
        'status (%f) is bigger than total (%f)', status, total)
end

attr = {'scalar', 'real', 'nonnegative'};
validateattributes(status, {'numeric'}, attr, mfilename, 'status')
validateattributes(total, {'numeric'}, attr, mfilename, 'total')

validStrings = {'number', 'percent', 'pluses', 'point_perc'};

if ~any(strcmpi(method, validStrings)) %faster than validatestring
    error('status_string:nonval_string', 'method must be any of:\n %s', sprintf('''%s'' ', validStrings{:}))
end

% END INPUT CHECKS

%check if a status_string is called in a new loop without properly
%terminating the last time
if ~isempty(status_last)
   if status_last > status || total_last ~= total 
    msg = [];
   end
end
status_last = status; total_last = total;

%which msg to display
msg_function = str2func(method);


msg_new = msg_function(status, total);


if ~strcmp(msg, msg_new) %only rewrite msg if it is a new one
    %display progress
    msg_del = repmat('\b',1,length(msg));
    fprintf(msg_del); %erase msg
    msg = msg_new;
    fprintf('%s', msg); %print msg
end

%last time step
if status == total 
    if erase
        fprintf(repmat('\b',1,length(msg))); %erase msg
    else
        fprintf('\n')
    end
    msg = [];
end
 
 


end


function msg = number(status, total) %#ok<DEFNU>
% 145 of 1253
msg=sprintf('%i of %i', status,total); %create msg
end

function msg = percent(status, total) %#ok<DEFNU>
% 13.2 %
msg=sprintf('%4.1f %%', status/total*100); %create msg
end

function msg = point_perc(status, total) %#ok<DEFNU>
% .. 25 % -> ... 30 %
n_points = ceil(status/total*9)+1;
pt = repmat('.', 1, n_points);
msg=sprintf('%s %4.1f %%', pt, status/total*100); %create msg
end

function msg = pluses(status, total) %#ok<DEFNU>
% |++++       |

n_signs = 50;
sign = '+';


n_signs_ii = floor(status/total*n_signs);

msg = ['|' rm(sign, n_signs_ii) rm(' ', n_signs-n_signs_ii) '|'];
end


function B = rm(A, n)
    B = repmat(A, 1, n);
end
