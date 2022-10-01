if ($env | get --ignore-errors TMUX | is-empty) {
   exec /usr/local/bin/tmux
}
