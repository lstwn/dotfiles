function less --description "The less terminal pager"
    if type -q less
        command less --RAW-CONTROL-CHARS $argv
    end
end

