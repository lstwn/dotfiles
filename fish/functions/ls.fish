function ls --description "List contents of directory"
    if type -q exa 
        command exa --group-directories-first $argv
    else
        command ls --group-directories-first --color=auto $argv
    end
end

