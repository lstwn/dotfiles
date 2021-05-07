function fish_prompt --description 'Write out the prompt'
	#Save the return status of the previous command
    set stat $status

    function __fish_prompt_exit_status --inherit-variable stat --description "Print the exit status of the previous command";
        if test $stat -gt 0
            echo (set_color --background red black) $stat (set_color normal)
        else
            echo (set_color normal)
        end
    end

    function __fish_prompt_time --description "Print the current time";
        echo (set_color --background brblack; set_color white) (date "+%H:%M:%S") (set_color normal)
    end

    function __fish_prompt_user --description "Print the current user";
        switch "$USER"
            case root toor
                echo (set_color --background yellow black) $USER (set_color normal)
            case '*'
                echo (set_color --background green black) $USER (set_color normal)
        end
    end

    function __fish_prompt_hostname --description "Print the hostname";
        echo (set_color --background red black) (hostname) (set_color normal)
    end

    function __fish_prompt_working_dir --description "Print the current working directory";
        echo (set_color --background blue black) (prompt_pwd) (set_color normal)
    end

    function __fish_prompt_git_branch --description "Print the git branch of the current folder" --argument-names 'max_len';
        if test -n "$max_len"
            set MAX_BRANCH_LEN $max_len
        else
            set MAX_BRANCH_LEN 20
        end

        set branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if test -z $branch
            echo (set_color normal)
            return
        end
        if test (string length $branch) -ge $MAX_BRANCH_LEN
            set branch (string sub --length $MAX_BRANCH_LEN $branch)
        end
        set git_info $branch

        set basedir         (git rev-parse --show-toplevel 2>/dev/null)
        set untracked_files (string trim (git ls-files -o --exclude-from=.gitignore $basedir 2>/dev/null | wc -l))
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

        echo (set_color --background yellow black) $string (set_color normal)
    end

    function __fish_prompt_command_prefix --description "Print chars before the command";
        echo (set_color -o yellow)" > "(set_color normal)
    end

    set prompt (printf '%s%s%s%s%s%s\f\r%s' \
        (__fish_prompt_time) \
        (__fish_prompt_user) \
        (__fish_prompt_hostname) \
        (__fish_prompt_working_dir) \
        (__fish_prompt_git_branch) \
        (__fish_prompt_exit_status) \
        (__fish_prompt_command_prefix))

    # TODO: rewrite such that functions return just content strings
    # add function that "coats" the content with spaces
    # add function that "coats" the spaced content with colors
    # assemble and echo based on length of spaced contents

    # set visible_length (string length (echo $prompt | sed 's/\x1B\[[0-9;]*[JKmsu]//g'))

    # if test $visible_length -gt $COLUMNS
    #     set prompt (printf '%s%s%s\f\r%s' \
    #         (__fish_prompt_working_dir) \
    #         (__fish_prompt_git_branch 20) \
    #         (__fish_prompt_exit_status) \
    #         (__fish_prompt_command_prefix))
    # end

    echo $prompt
end

