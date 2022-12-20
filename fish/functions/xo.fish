function xo --description "Open files with the appropriate system program"
    if type -q open
        command open $argv
    else if type -q xdg-open
        command xdg-open $argv
    end
end
