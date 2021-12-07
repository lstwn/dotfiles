local M = {}

M.own = function()
    vim.g.mapleader = ","

    -- normal keymaps
    vim.api.nvim_set_keymap("n", "~", [[<cmd>Explore ~<cr>]], {noremap = true})
    vim.api.nvim_set_keymap("n", "-", [[<cmd>Explore %:p:h<cr>]],
        {noremap = true})
    vim.api.nvim_set_keymap("n", "<leader><tab>", [[<cmd>b#<cr>]],
        {noremap = true})
    vim.api.nvim_set_keymap("n", "<leader>R",
        [[<cmd>source $MYVIMRC<cr> <cmd>filetype detect<cr> <cmd>echo "Reloaded"<cr>]],
        {noremap = true})
    vim.api.nvim_set_keymap("n", "<C-w>c", [[<cmd>tabnew %<cr>]],
        {noremap = true})
    vim.api.nvim_set_keymap("n", "<C-w>n", [[<cmd>tabnext<cr>]],
        {noremap = true})
    vim.api.nvim_set_keymap("n", "<C-w>p", [[<cmd>tabprevious<cr>]],
        {noremap = true})

    -- terminal keymaps
    vim.api.nvim_set_keymap("t", "<C-w>N", [[<C-\><C-n>]], {noremap = true})
    vim.api.nvim_set_keymap("t", "<C-w>c", [[<C-\><C-n><C-w>c]],
        {noremap = true})
    vim.api.nvim_set_keymap("t", "<C-w>n", [[<cmd>tabnext<cr>]],
        {noremap = true})
    vim.api.nvim_set_keymap("t", "<C-w>p", [[<cmd>tabprevious<cr>]],
        {noremap = true})
    vim.api.nvim_set_keymap("t", "<C-w>q", [[<C-\><C-n><C-w>q]],
        {noremap = true})
    vim.api.nvim_set_keymap("t", "<C-w>l", [[<C-\><C-n><C-w>l]],
        {noremap = true})
    vim.api.nvim_set_keymap("t", "<C-w>h", [[<C-\><C-n><C-w>h]],
        {noremap = true})
    vim.api.nvim_set_keymap("t", "<C-w>k", [[<C-\><C-n><C-w>k]],
        {noremap = true})
    vim.api.nvim_set_keymap("t", "<C-w>j", [[<C-\><C-n><C-w>j]],
        {noremap = true})
end

M.lsp = function(bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    local keymap_options = {noremap = true, silent = true}
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>",
        keymap_options)
    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>",
        keymap_options)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>",
        keymap_options)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>",
        keymap_options)
    buf_set_keymap("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>",
        keymap_options)
    buf_set_keymap("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", keymap_options)
    buf_set_keymap("n", "gH", "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        keymap_options)
    buf_set_keymap("n", "gl",
        "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>",
        keymap_options)
    buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>",
        keymap_options)
    buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
        keymap_options)
    buf_set_keymap("n", "<leader>wa",
        "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", keymap_options)
    buf_set_keymap("n", "<leader>wr",
        "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", keymap_options)
    buf_set_keymap("n", "<leader>wl",
        "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
        keymap_options)
    buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>",
        keymap_options)
    buf_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>",
        keymap_options)
    buf_set_keymap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>",
        keymap_options)
    buf_set_keymap("n", "<leader>q",
        "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", keymap_options)
end

M.telescope = function()
    vim.api.nvim_exec([[
    nnoremap <leader>ff  <cmd>Telescope find_files<cr>
    tnoremap <leader>ff  <cmd>Telescope find_files<cr>
    nnoremap <leader>fb  <cmd>Telescope buffers<cr>
    tnoremap <leader>fb  <cmd>Telescope buffers<cr>
    nnoremap <leader>fc  <cmd>Telescope commands<cr>

    nnoremap <leader>fq  <cmd>Telescope quickfix<cr>
    nnoremap <leader>fl  <cmd>Telescope loclist<cr>
    nnoremap <leader>fh  <cmd>Telescope help_tags<cr>

    nnoremap <leader>fgw <cmd>Telescope live_grep<cr>
    nnoremap <leader>fgb <cmd>Telescope current_buffer_fuzzy_find<cr>

    nnoremap <leader>fdw <cmd>Telescope lsp_workspace_diagnostics<cr>
    nnoremap <leader>fdb <cmd>Telescope lsp_document_diagnostics<cr>
    nnoremap <leader>fsw <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
    nnoremap <leader>fsb <cmd>Telescope lsp_document_symbols<cr>

    nnoremap <leader>gcw <cmd>Telescope git_commits<cr>
    nnoremap <leader>gcb <cmd>Telescope git_bcommits<cr>
    nnoremap <leader>gs  <cmd>Telescope git_status<cr>
    nnoremap <leader>gb  <cmd>Telescope git_branches<cr>
    ]], false)
end

return M
