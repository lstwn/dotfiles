fish_vi_key_bindings
set -g fish_prompt_pwd_dir_length 1
set fish_greeting

set -x TERM "screen-256color"
set -x BAT_THEME "base16"
set -x LESS_TERMCAP_md (tput bold; tput setaf 3)               # begin bold
set -x LESS_TERMCAP_me (tput sgr0)                             # reset bold/blink
set -x LESS_TERMCAP_so (tput bold; tput setaf 0; tput setab 1) # begin search
set -x LESS_TERMCAP_se (tput rmso; tput sgr0)                  # reset search
set -x LESS_TERMCAP_us (tput smul; tput bold; tput setaf 15)   # begin underline
set -x LESS_TERMCAP_ue (tput rmul; tput sgr0)                  # reset underline
set -x GROFF_NO_SGR 1                                          # show colors in manpages
# In case Bitwarden's SSH Agent should be used:
# set -x SSH_AUTH_SOCK ~/.bitwarden-ssh-agent.sock

set -g fish_color_normal white # the default color
set -g fish_color_command yellow --bold                                  # the color for commands
set -g fish_color_quote cyan                                         # the color for quoted blocks of text
set -g fish_color_redirection white --bold                           # the color for IO redirections
set -g fish_color_end white --bold                                            # the color for process separators like ';' and '&'
set -g fish_color_error red --bold                                  # the color used to highlight potential errors
set -g fish_color_param blue --bold                                        # the color for regular command parameters
set -g fish_color_comment brblack                                         # the color used for code comments
#set fish_color_match                                          # the color used to highlight matching parenthesis
#set fish_color_selection                            # the color used when selecting text (in vi visual mode)
#set -g fish_color_search_match -b cyan # used to highlight history search matches and the selected pager item (must be a background)
set -g fish_color_operator red --bold                                         # the color for parameter expansion operators like '*' and '~'
set -g fish_color_escape green                                         # the color used to highlight character escapes like '\n' and '\x70'
#set fish_color_cwd                                              # the color used for the current working directory in the default prompt
set -g fish_color_autosuggestion brblack # the color used for autosuggestions
#set fish_color_user                                              # the color used to print the current username in some of fish default prompts
#set fish_color_host                                              # the color used to print the current host system in some of fish default prompts
#set fish_color_cancel                                          # the color for the '^C' indicator on a canceled command

# Additionally, the following variables are available to change the highlighting in the completion pager:
set -g fish_pager_color_prefix white --bold      # the color of the prefix string, i.e. the string that is to be completed
set -g fish_pager_color_completion blue --bold            # the color of the completion itself
set -g fish_pager_color_description white             # the color of the completion description
#set -g fish_pager_color_progress              # the color of the progress bar at the bottom left corner
#set -g fish_pager_color_secondary              # the background color of the every second completion

# brew path
if not test (type --query brew)
    set --global --export HOMEBREW_PREFIX "/opt/homebrew";
    set --global --export HOMEBREW_CELLAR "/opt/homebrew/Cellar";
    set --global --export HOMEBREW_REPOSITORY "/opt/homebrew";
    fish_add_path --global --move --path "/opt/homebrew/bin" "/opt/homebrew/sbin";
    if test -n "$MANPATH[1]"; set --global --export MANPATH '' $MANPATH; end;
    if not contains "/opt/homebrew/share/info" $INFOPATH; set --global --export INFOPATH "/opt/homebrew/share/info" $INFOPATH; end;
end

# rust path
if test -d ~/.cargo/bin
    fish_add_path "$HOME/.cargo/bin"
end

# python path
if test -d ~/.local/bin
    fish_add_path "$HOME/.local/bin"
end

# anaconda path
if test -d /usr/local/anaconda3/bin
    fish_add_path "/usr/local/anaconda3/bin"
end

# npm path
if test (type --query npm)
    set -x NPM_GLOBAL_DIR "$HOME/.npm/global"
    fish_add_path "$NPM_GLOBAL_DIR/bin"
    set -e MANPATH
    set -x MANPATH "$NPM_GLOBAL_DIR/share/man:"(manpath)
end

# pnpm
set -gx PNPM_HOME "/Users/lstwn/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /usr/local/anaconda3/bin/conda
    eval /usr/local/anaconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<

function __is_within_vscode
    # if launched from shell
    string match -q "$TERM_PROGRAM" "vscode"
    # if launched from GUI
    or set -q VSCODE_PID
end

function __is_within_zed
    set -q ZED
end

function __is_within_tmux
    set -q TMUX
end

function __is_mac
    test (uname) = "Darwin"
end

set -x EDITOR "nvim"
set -x VISUAL "$EDITOR"
set -x PAGER "less"

# setup interactive sessions
if status --is-interactive
    # load starship prompt
    starship init fish | source

    # automatically load ssh keys from keychain in interactive session
    if test (type --query ssh-add) -a (__is_mac)
        ssh-add --apple-load-keychain &> /dev/null
    end

    if __is_within_vscode
        # setup vs code options
        set -x EDITOR "code --wait"
        set -x VISUAL "$EDITOR"
        . (code --locate-shell-integration-path fish)
        return
    end

    if __is_within_zed
        # setup zed options
        set -x EDITOR "zed --wait"
        set -x VISUAL "$EDITOR"
        return
    end

    if __is_within_tmux
        # no nesting of tmux sessions
        return
    end

    # otherwise, launch tmux automagically
    exec tmux
end
