function maphelper#apply(key, command, modes, noremap)
    let mapping_command = a:noremap ? 'noremap' : 'map'
    if a:modes =~ 'n'
        " normal mode
        exec 'n' . mapping_command . ' ' . a:key . ' ' . a:command
    endif
    if a:modes =~ 'i'
        " insert mode
        exec 'i' . mapping_command . ' ' . a:key . ' <C-O>' . a:command
    endif
    if a:modes =~ 't'
        " terminal mode
        exec 't' . mapping_command . ' ' . a:key . ' <C-W>' . a:command
    endif
    if a:modes =~ 'v'
        " visual mode
        exec 'x' . mapping_command . ' ' . a:key . ' ' . a:command
    endif
    if a:modes =~ 's'
        " select mode
        exec 's' . mapping_command . ' ' . a:key . ' ' . a:command
    endif
    if a:modes =~ 'o'
        " operator pending mode
        exec 'o' . mapping_command . ' ' . a:key . ' ' . a:command
    endif
    if a:modes =~ 'c'
        " command-line mode
        exec 'c' . mapping_command . ' ' . a:key . ' ' . a:command
    endif
endfunction

function maphelper#toggle_command(option)
    return ':set ' . a:option . '! \| set ' . a:option . "?\<CR>"
endfunction

