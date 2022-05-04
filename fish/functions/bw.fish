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
                    switch (uname)
                        case Linux
                            wl-copy "$PASSWORD$TOTP"
                            printf "%s" "$PASSWORD$TOTP" | xsel -ib
                        case Darwin
                            printf "%s" "$PASSWORD$TOTP" | pbcopy
                    end
                    return
                end
            case '*'
                command bw $argv
        end
    else
        command bw
        echo "INFO: bw enable bw copy are custom aliases"
    end
end

function is_bw_enabled
    if not set -q BW_SESSION
    or not set -q BW_SESSION[1]
        return 1
    end
    return 0
end

