function fish_user_key_bindings --description "Place all user keybindings in here"
    bind --mode insert \ca accept-autosuggestion
    bind --mode insert \cs forward-word
    bind --mode insert \cp history-search-backward
    bind --mode insert \cn history-search-forward
end

