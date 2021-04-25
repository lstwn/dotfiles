function ll --description "List contents of directory using long format"
    if type -q exa 
        command exa -lg --group-directories-first --color=always --git $argv | less --quit-if-one-screen
    else
        command ls -lh --group-directories-first --color=auto $argv
    end
end

