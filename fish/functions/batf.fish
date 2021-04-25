function batf --description "Follow files with syntax highlighting of bat"
    if set -q $argv[1]
        echo "Missing file path argument"
        return
    end
    set FILE_PATH $argv[1]
    set FILE_EXTENSION (string split --right --max 1 . $FILE_PATH)
    if set -q $argv[2]
        set LINES 10
    else
        set LINES $argv[2]
    end
    if type -q tail && type -q bat
        tail -f -n $LINES $FILE_PATH | bat --paging=never --language=$FILE_EXTENSION
    end
end

