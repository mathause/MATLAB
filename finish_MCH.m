function finish
 
try
    backup_call_MCH
catch exception
    msg = sprintf('The backup program caused an error. Quit anyway?');
    yes = 'YES (Quit anyway)';
    no  = 'NO (Return to Matlab)';
    button = questdlg(msg,'Error',yes,no,yes);
    
    if strcmp(button, yes)    
        quit force
    else
        throw(exception)
    end
end 
    
    
    




end