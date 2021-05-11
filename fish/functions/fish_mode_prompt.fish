# The fish_mode_prompt function is prepended to the prompt
function fish_mode_prompt --description "Displays the current mode"
    # Do nothing if not in vi mode
    function __fish_mode_prompt
        switch $fish_bind_mode
            case default
                echo ' N '
            case insert
                echo ' I '
            case replace_one
                echo ' R '
            case visual
                echo ' V '
        end
    end

    if test "$fish_key_bindings" = "fish_vi_key_bindings"
        or test "$fish_key_bindings" = "fish_hybrid_key_bindings"
        set_color --background white black
        __fish_mode_prompt
        set_color normal
    end
end

