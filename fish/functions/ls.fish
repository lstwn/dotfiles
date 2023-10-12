function ls --description "List contents of directory"
    if type -q eza 
        command eza --long --git --group --group-directories-first \
            --color=always --time-style=relative $argv | \
            less --quit-if-one-screen
    else
        command ls --group-directories-first --color=auto $argv
    end
end

