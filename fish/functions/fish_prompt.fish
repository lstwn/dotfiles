function fish_prompt
    # Save last status before doing anything that might affect it.
    set -l last_status $status

    # Prepare the elements of the prompt.
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
        set branch (git rev-parse --abbrev-ref HEAD | string shorten --max 20)
        set git (set_color --background yellow black)" $branch "
    end

    # Decide which elements to print according to
    # their priority and the available columns.
    set order $user $host $cwd $git $stat
    set active false false false false false
    set prios 5 3 4 1 2
    set used 3 # We account for the vim mode indicator.
    for prio in $prios
        set element $order[$prio]
        set length (string length --visible "$element")
        if test (math $used + $length) -gt $COLUMNS
            break
        end
        set active[$prio] true
        set used (math $used + $length)
    end

    # Print the surviving elements.
    for i in (seq 1 (count $order))
        if $active[$i]
            echo -n "$order[$i]"
        end
    end
    echo -e "$(set_color normal)\n"
end
