function bw --description "Bitwarden wrapper to make unlocking Bitwarden for the current terminal easier"
    if not type -q -f bw
        echo "Error: Bitwarden not installed"
        return
    end
    if test (count $argv) -ge 1
        switch "$argv[1]"
            case 'enable'
                while not is_bw_enabled
                    set -x -g BW_SESSION (command bw unlock --raw)
                end
                command bw sync
                return
            case 'copy'
                if test (count $argv) -ge 2
                    bw enable
                    if test "$argv[2]" = "passwordtotp"
                        set PASSWORD (command bw get password $argv[3..(count $argv)])
                        set TOTP (bw get totp $argv[3..(count $argv)])
                    else
                        set PASSWORD (command bw get $argv[2..(count $argv)])
                    end
                    wl-copy "$PASSWORD$TOTP"
                    printf "%s" "$PASSWORD$TOTP" | xsel -ib
                    return
                end
            case 'note'
                if test (count $argv) -ge 2
                    bw enable
                    if not set ITEM (command bw get item $argv[2])
                    or not type -q -f jq
                        return
                    end
                    set ID (echo "$ITEM" | jq -r '.id')
                    set TMP_PATH "/tmp/bw_$ID"
                    echo "$ITEM" | jq -r '.notes' > "$TMP_PATH"
                    echo (date +'%Y-%m-%d|%H:%M ') >> "$TMP_PATH"
                    $EDITOR "$TMP_PATH"
                    set NEW_NOTE (cat "$TMP_PATH")
                    for LINE in $NEW_NOTE
                        set STRING "$STRING$LINE\n"
                    end
                    set STRING (string trim --chars=\\n "$STRING")
                    set UPDATED (echo "$ITEM" | jq -r ".notes = \"$STRING\"" | bw encode)
                    command bw edit item "$ID" "$UPDATED" > /dev/null && rm "$TMP_PATH"
                    return
                end
            case '*'
                command bw $argv
        end
    else
        command bw
        echo "INFO: bw enable bw copy and bw note are custom aliases"
    end
end

function is_bw_enabled
    if not set -q BW_SESSION
    or not set -q BW_SESSION[1]
        return 1
    end
    return 0
end

