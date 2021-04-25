function tree --description "List contents of directory in tree format"
    if type -q exa
        command exa --tree --group-directories-first --color=always $argv | less --quit-if-one-screen
    else
        command tree $argv | less
    end
end

