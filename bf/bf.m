function bf(code, verbose)
%BF interpreter for brainfuck programs 
%
%Syntax
%   BF('code')
%   BF('source_file.bf')
%   BF(..., verbose)
%
%Usage
%   BF('code') run the brainfuck program given in 'code'
%   BF('source_file.bf') run the code given in the source file (see
%      examples)
%   BF(..., verbose) output the registers at every step
%
%Example
%   BF('>++++[>++++++<-]>-[[<+++++>>+<-]>-]<<[<]>>>>--.<<<-.>>>-.<.<.>---.<<+++.>>>++.<<---.[>]<<.')
%   BF('whatisbf.bf')
%
%The BrainFuck Programming Language
%   Character   Meaning
%   >           increment the data pointer (to point to the next cell to the right).
%   <           decrement the data pointer (to point to the next cell to the left).
%   +           increment (increase by one) the byte at the data pointer.
%   -           decrement (decrease by one) the byte at the data pointer.
%   .           output the byte at the data pointer.
%   ,           accept one byte of input, storing its value in the byte at the data pointer.
%   [           if the byte at the data pointer is zero, then instead of moving the instruction pointer forward to the next command, jump it forward to the command after the matching ] command.
%   ]           if the byte at the data pointer is nonzero, then instead of moving the instruction pointer forward to the next command, jump it back to the command after the matching [ command
%
%Version History
%   04.11.2013  mah
%
%See Also
%http://en.wikipedia.org/wiki/Brainfuck

if nargin == 1; verbose = false; end

%get file if it is given
if length(code) > 3 && strcmp(code(end-2:end), '.bf')
    fid = fopen(code, 'r');
    code = fscanf(fid, '%s');
    fclose(fid);
end
    
%clear all text that is not any of the bf commands
code = regexprep(code, '[^><+-.,\[\]]', '');


open  = regexp( code, '\[');
close = regexp( code, '\]');
assert( length(open) == length(close), 'Not equal number of opening and closing parentheses');

% >     <     +     -     .     ,     [     ]
% 62    60    43    45    46    44    91    93



bf_switch(code, verbose);


fprintf('\n');

end


function bf_switch(code, verbose)
pos = 1; %position in code
ptr = 1; %index (ptr) of current value
values = 0; 
l_code = length(code);
l_values = 1;
opening_paren = 0;
closing_paren = 0;

while true 
    
    cmd = code(pos);
    switch cmd
        case '>'
            ptr = ptr + 1;
            %initiate new field
            if l_values < ptr
                values(ptr) = 0;
                l_values = l_values + 1;
            end
        case '<'
            assert(ptr>1, 'you canno''t decrement pointer below 1')
            ptr = ptr - 1;
        case '+'
            values(ptr) = values(ptr) + 1;
        case '-'
            values(ptr) = values(ptr) - 1;
        case '.'
            fprintf('%s', char(values(ptr)))
        case ','
            while true
                res = input('Input one character: ', 's');
                if length(res) ~= 1
                    fprintf('Input character must have length 1!\n')
                else
                    break
                end
            end
            values(ptr) = double(res);
        case '['
            if values(ptr) == 0
                if pos == opening_paren %only find closing_paren if changed
                    pos = closing_paren;
                else
                    opening_paren = pos;
                    pos = findClosingParen(code, pos);
                    closing_paren = pos;
                end
                
            end 
            
        case ']'
            if values(ptr) ~= 0
                if pos == closing_paren
                    pos = opening_paren;
                else
                    closing_paren = pos;
                    pos = findOpeningParen(code, pos);
                    opening_paren = pos;
                end
            end
            
        otherwise
            fprintf('Unknown command (%s)', cmd);
    end
    
if pos >= l_code
    break
else
    pos = pos + 1;
end

    
if verbose
    disp(values);
    %disp(pos)
end
end








end

function close_pos = findClosingParen(code, open_pos)
%code = 'aö[d[jkgh]][7]';


close_pos = open_pos;

counter = 1;

while counter
    close_pos = close_pos + 1;
    if strcmp(code(close_pos), '[')
        counter = counter + 1;
    end
    if strcmp(code(close_pos), ']')
        counter = counter - 1;
    end
end


end




function open_pos = findOpeningParen(code, close_pos)
%code = 'aö[d[jkgh]][7]';


open_pos = close_pos;

counter = 1;

while counter
    open_pos = open_pos - 1;
    if strcmp(code(open_pos), ']')
        counter = counter + 1;
    end
    if strcmp(code(open_pos), '[')
        counter = counter - 1;
    end
end


end

