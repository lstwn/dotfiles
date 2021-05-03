function fish_user_key_bindings --description "Place all user keybindings in here"
    bind -M insert \ck history-search-backward
    bind -M insert \cj history-search-forward
    bind -M insert \ca accept-autosuggestion
    bind -M insert \cn forward-word
end

