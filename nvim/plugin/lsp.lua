vim.api.nvim_exec([[
function g:OnSave()
  if exists(":OrganizeImports")
    OrganizeImports
  endif
  lua vim.lsp.buf.formatting_sync(nil, 1000)
endfunction

augroup on_save
  autocmd!
  autocmd BufWritePre *.js,*.ts,*.rs,*.py,*.c,*.lua call g:OnSave()
augroup end
]], false)

local lspconfig = require("lspconfig")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    require("mappings").lsp(bufnr)
end

local eslint = {
    -- lintCommand = "./node_modules/.bin/eslint -f unix --stdin --stdin-filename ${INPUT}",
    lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %m"},
    lintIgnoreExitCode = true,
    formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
    formatStdin = true,
}

local prettier = {
    formatCommand = "./node_modules/.bin/prettier --stdin-filepath ${INPUT}",
    formatStdin = true,
}

local luafmt = {
    formatCommand = "lua-format --no-align-args --no-align-parameter --extra-sep-at-table-end --single-quote-to-double-quote",
    formatStdin = true,
}

local rustfmt = {formatCommand = "rustfmt", formatStdin = true}

local languages = {
    lua = {luafmt},
    typescript = {eslint, prettier},
    javascript = {eslint, prettier},
    typescriptreact = {eslint, prettier},
    javascriptreact = {eslint, prettier},
    yaml = {prettier},
    json = {prettier},
    html = {prettier},
    scss = {prettier},
    css = {prettier},
    markdown = {prettier},
    -- rust = {rustfmt},
}

lspconfig.efm.setup {
    init_options = {documentFormatting = true, codeAction = true},
    on_attach = on_attach,
    settings = {languages = languages},
    filetypes = vim.tbl_keys(languages),
}
lspconfig.rust_analyzer.setup {on_attach = on_attach}
lspconfig.tsserver.setup {
    settings = {documentFormatting = false},
    on_attach = function(client, bufnr)
        -- This makes sure tsserver is not used for formatting (I prefer prettier)
        client.resolved_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    commands = {
        OrganizeImports = {
            function()
                local method = "workspace/executeCommand"
                local bufnr = vim.api.nvim_get_current_buf()
                local params = {
                    command = "_typescript.organizeImports",
                    arguments = {vim.api.nvim_buf_get_name(0)},
                }
                vim.lsp.buf_request_sync(bufnr, method, params, 1000)
            end,
            description = "Organize Imports",
        },
    },
}
-- https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
local sumneko_root_path = vim.fn.stdpath("data") .. "/lua-language-server"
local sumneko_binary

if vim.fn.has("mac") == 1 then
    sumneko_binary = sumneko_root_path .. "/bin/macOS/lua-language-server"
elseif vim.fn.has("unix") == 1 then
    sumneko_binary = sumneko_root_path .. "/bin/Linux/lua-language-server"
else
    print("Unsupported system for sumneko")
end

lspconfig.sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = vim.split(package.path, ";"),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {"vim"},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
            },
        },
    },
}
lspconfig.pyright.setup {on_attach = on_attach}
lspconfig.html.setup {on_attach = on_attach}
lspconfig.cssls.setup {on_attach = on_attach}
lspconfig.jsonls.setup {on_attach = on_attach}
lspconfig.yamlls.setup {on_attach = on_attach}
lspconfig.vuels.setup {on_attach = on_attach}
lspconfig.graphql.setup {on_attach = on_attach}
lspconfig.prismals.setup {on_attach = on_attach}
lspconfig.bashls.setup {on_attach = on_attach}
lspconfig.vimls.setup {on_attach = on_attach}
lspconfig.texlab.setup {on_attach = on_attach}
