# The fish_mode_prompt function is prepended to the prompt
function fish_mode_prompt
    set_color --background brwhite black
    echo " "
    switch $fish_bind_mode
        case default
            echo N
        case insert
            echo I
        case replace_one
        case replace
            echo R
        case visual
            echo V
        case '*'
            echo '?'
    end
    echo " "
    set_color normal
end
