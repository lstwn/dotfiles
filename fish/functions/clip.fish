function clip --description "Copy to clipboard"
    if type -q xclip
        command xclip -sel clip $argv
    end
    if type -q wl-copy
        command wl-copy "$argv" 2>/dev/null
    end
end

