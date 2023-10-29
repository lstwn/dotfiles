vim.g.broot_replace_netrw = true
vim.g.broot_open_command = "open"
vim.g.broot_shell_command = "sh -c"
vim.g.broot_command = "broot --sort-by-type-dirs-first"
vim.g.broot_redirect_command = ">"
vim.g.broot_vim_conf = {
    'default_flags = "gh"',
    '',
    '[[verbs]]',
    'key = "enter"',
    'external = "echo +{line} {file}"',
    'apply_to = "file"',
}
