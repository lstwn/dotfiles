function sk --description "Fuzzy searcher"
    if type -q fdfind
        set -x SKIM_DEFAULT_COMMAND "fdfind"
    end
    set -x SKIM_DEFAULT_OPTIONS "--color=16,fg:08,bg:,current:01,current_bg:,matched:03,matched_bg:,current_match:01,current_match_bg:,marker:04,spinner:04,prompt:04,info:04,header:04"
   command sk $argv
end

