function la --description "List contents of directory, including hidden files in directory using long format"
    if type -q eza
        command eza --long --all --git --group --group-directories-first \
            --color=always --time-style=relative $argv | \
            less --quit-if-one-screen
    else
        command ls -la --group-directories-first --color=auto $argv
    end
end
