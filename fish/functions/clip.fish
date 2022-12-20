function clip --description "Copy to clipboard"
    if type -q pbcopy
        command pbcopy
    else if type -q xclip
        command xclip -sel clip $argv
        return
    else if type -q wl-copy
        command wl-copy "$argv" 2>/dev/null
        return
    end
end

