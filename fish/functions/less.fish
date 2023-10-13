function less --description "The less terminal pager"
    if type -q less
        command less --mouse --RAW-CONTROL-CHARS $argv
    end
end

