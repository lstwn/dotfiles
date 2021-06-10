function fish_prompt --description 'Write out the prompt'
	#Save the return status of the previous command
    set stat $status

    function __fish_prompt_wrap_item;
        if test (count $argv) -eq 1
            printf " %s " "$argv[1]"
        end
    end

    function __fish_prompt_coat
        if test "$argv[3]" != ""
            printf "%s%s%s" (set_color --background $argv[1] $argv[2]) $argv[3] (set_color normal)
        else
            echo -s ""
        end
    end

    function __fish_prompt_exit_status --inherit-variable stat --description "Print the exit status of the previous command";
        if test $stat -gt 0
            __fish_prompt_wrap_item $stat
        end
    end

    function __fish_prompt_time --description "Print the current time";
        __fish_prompt_wrap_item (date "+%H:%M:%S")
    end

    function __fish_prompt_user --description "Print the current user";
        __fish_prompt_wrap_item $USER
    end

    function __fish_prompt_hostname --description "Print the hostname";
        __fish_prompt_wrap_item (hostname)
    end

    function __fish_prompt_working_dir --description "Print the current working directory";
        __fish_prompt_wrap_item (prompt_pwd)
    end

    function __fish_prompt_git_branch --description "Print the git branch of the current folder" --argument-names 'max_len';
        if test -n "$max_len"
            set MAX_BRANCH_LEN $max_len
        else
            set MAX_BRANCH_LEN 20
        end

        set branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if test -z $branch
            return
        end

        if test (string length $branch) -ge $MAX_BRANCH_LEN
            set branch (string sub --length $MAX_BRANCH_LEN $branch)
        end
        set git_info $branch

        set basedir         (git rev-parse --show-toplevel 2>/dev/null)
        set untracked_files (string trim (git ls-files -o --exclude-standard $basedir 2>/dev/null | wc -l))
        if test $untracked_files -gt 0
            set git_info $git_info "$untracked_files untracked"
        end
        set unstaged_files  (string trim (git diff --name-only 2>/dev/null | wc -l))
        if test $unstaged_files -gt 0
            set git_info $git_info "$unstaged_files unstaged"
        end
        set staged_files    (string trim (git diff --name-only --cached 2>/dev/null | wc -l))
        if test $staged_files -gt 0
            set git_info $git_info "$staged_files staged"
        end
        set conflict_files  (string trim (git diff --name-only --diff-filter=U 2>/dev/null | wc -l))
        if test $conflict_files -gt 0
            set git_info $git_info "$conflict_files conflicted"
        end
        set amount_stashs   (string trim (git stash list | wc -l))
        if test $amount_stashs -gt 0
            set git_info $git_info "$amount_stashs stashed"
        end

        set string $git_info[1]
        if test (count $git_info) -gt 1
            set string "$string $git_info[2]"
            if test (count $git_info) -gt 2
                for info in $git_info[3..-1]
                    set string "$string $info"
                end
            end
        end

        __fish_prompt_wrap_item $string
    end

    function __fish_prompt_command_prefix --description "Print chars before the command";
        __fish_prompt_wrap_item ">"
    end

    set prompt (printf "%s%s%s%s%s%s" \
       (__fish_prompt_time) \
       (__fish_prompt_user) \
       (__fish_prompt_hostname) \
       (__fish_prompt_working_dir) \
       (__fish_prompt_git_branch) \
       (__fish_prompt_exit_status))
    set mode_prompt_length (string length (__fish_mode_prompt))
    set prompt_length (string length (echo $prompt))

    if test (math $mode_prompt_length + $prompt_length + 1) -gt $COLUMNS
        printf "%s%s%s\f\r%s" \
           (__fish_prompt_coat blue black (__fish_prompt_working_dir)) \
           (__fish_prompt_coat yellow black (__fish_prompt_git_branch 20)) \
           (__fish_prompt_coat red black (__fish_prompt_exit_status)) \
           (__fish_prompt_coat normal yellow (__fish_prompt_command_prefix))
    else
        printf "%s%s%s%s%s%s\f\r%s" \
           (__fish_prompt_coat brblack white (__fish_prompt_time)) \
           (__fish_prompt_coat green black (__fish_prompt_user)) \
           (__fish_prompt_coat red black (__fish_prompt_hostname)) \
           (__fish_prompt_coat blue black (__fish_prompt_working_dir)) \
           (__fish_prompt_coat yellow black (__fish_prompt_git_branch 20)) \
           (__fish_prompt_coat red black (__fish_prompt_exit_status)) \
           (__fish_prompt_coat normal yellow (__fish_prompt_command_prefix))
    end

    return
end
