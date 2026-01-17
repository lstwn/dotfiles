function fish_prompt
    # Save last status before doing anything that might affect it.
    set -l last_status $status

    set user (set_color --background green black)" $USER "

    set host (set_color --background red black)" $(prompt_hostname) "

    set cwd (set_color --background blue black)" $(prompt_pwd --full-length-dirs 2) "

    # Prompt status only if it's not 0.
    set -l stat
    if test $last_status -ne 0
        set stat (set_color --background red black)" $last_status "
    end

    # Prompt git branch only if we are in a git repository.
    set -l git
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set git (set_color --background yellow black)" $(git rev-parse --abbrev-ref HEAD) "
    end

    if test $COLUMNS -gt 64
        string join '' -- $user $host $cwd $git $stat (set_color normal) ' '
    else if test $COLUMNS -gt 48
        string join '' -- $cwd $git $stat (set_color normal) ' '
    else if test $COLUMNS -gt 32
        string join '' -- $cwd $stat (set_color normal) ' '
    else
        string join '' -- $stat (set_color normal) ' '
    end
end
