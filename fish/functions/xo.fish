function xo --description "Open files with the appropriate program"
    if type -q xdg-open
        command xdg-open $argv
    end
end
