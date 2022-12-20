function ls --description "List contents of directory"
    if type -q exa 
        command exa --long --group --git --group-directories-first --color=always $argv | \
            less --quit-if-one-screen
    else
        command ls --group-directories-first --color=auto $argv
    end
end

