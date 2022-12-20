function la --description "List contents of directory, including hidden files in directory using long format"
    if type -q exa
        command exa --long --all --group --group-directories-first \
            --color=always --git $argv | \
            less --quit-if-one-screen
    else
        command ls -la --group-directories-first --color=auto $argv
    end
end

