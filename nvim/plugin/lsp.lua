vim.api.nvim_exec([[
function g:OnSave()
  if exists(":OrganizeImports")
    OrganizeImports
  endif
  lua vim.lsp.buf.format()
endfunction

augroup on_save
  autocmd!
  autocmd BufWritePre *.js,*.ts,*.vue,*.rs,*.py,*.c,*.lua,*.md,*.json,*.html,*.css call g:OnSave()
augroup end
]], false)

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp
.protocol
.make_client_capabilities())

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

-- NOTE: when having any problems with formatting/linting try running 'eslint_d restart'.
-- A failing eslint_d might affect prettier, too!
local eslint = {
    lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
    -- lintCommand = "./node_modules/.bin/eslint -f unix --stdin --stdin-filename ${INPUT}",
    lintStdin = true,
    lintFormats = { "%f:%l:%c: %m" },
    lintIgnoreExitCode = true,
    formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename ${INPUT}",
    -- formatCommand = "./node_modules/.bin/eslint --fix-to-stdout --stdin --stdin-filename ${INPUT}",
    formatStdin = true,
}

-- NOTE: when having any problems with formatting/linting try running 'eslint_d restart'.
-- A failing eslint_d might affect prettier, too!
local prettier = {
    formatCommand = "prettierd ${INPUT}",
    -- formatCommand = "./node_modules/.bin/prettier ${INPUT}",
    formatStdin = true,
    env = {
        string.format("PRETTIERD_DEFAULT_CONFIG=%s", vim.fn
        .expand("~/.config/nvim/utils/linter-config/.prettierrc.json")),
    },
}

local luafmt = {
    formatCommand = "lua-format --no-align-args --no-align-parameter --extra-sep-at-table-end --single-quote-to-double-quote",
    formatStdin = true,
}

local rustfmt = { formatCommand = "rustfmt", formatStdin = true }

local languages = {
    typescript = { eslint, prettier },
    javascript = { eslint, prettier },
    typescriptreact = { eslint, prettier },
    javascriptreact = { eslint, prettier },
    vue = { prettier, eslint },
    yaml = { prettier },
    json = { prettier },
    html = { prettier },
    scss = { prettier },
    css = { prettier },
    markdown = { prettier },
    -- rust = {rustfmt},
}

lspconfig.efm.setup {
    init_options = { documentFormatting = true, codeAction = true },
    on_attach = on_attach,
    settings = { rootMarkers = { ".git/", ".obsidian/" }, languages = languages },
    filetypes = vim.tbl_keys(languages),
    capabilities = capabilities,
}
lspconfig.rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
lspconfig.tsserver.setup {
    settings = { documentFormatting = false },
    on_attach = function(client, bufnr)
        -- This makes sure tsserver is not used for formatting (I prefer prettier)
        client.server_capabilities.documentFormattingProvider = false
        on_attach(client, bufnr)
    end,
    commands = {
        OrganizeImports = {
            function()
                if vim.bo.filetype ~= "typescript" then return end
                local method = "workspace/executeCommand"
                local bufnr = vim.api.nvim_get_current_buf()
                local params = {
                    command = "_typescript.organizeImports",
                    arguments = { vim.api.nvim_buf_get_name(0) },
                }
                vim.lsp.buf_request_sync(bufnr, method, params, 1000)
            end,
            description = "Organize Imports",
        },
    },
    capabilities = capabilities,
}

lspconfig.lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
        },
    },
}

lspconfig.pyright.setup { on_attach = on_attach, capabilities = capabilities }
lspconfig.html.setup { on_attach = on_attach, capabilities = capabilities }
lspconfig.cssls.setup { on_attach = on_attach, capabilities = capabilities }
lspconfig.jsonls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = { provideFormatter = false },
}
lspconfig.yamlls.setup { on_attach = on_attach, capabilities = capabilities }
-- lspconfig.vuels.setup {on_attach = on_attach, capabilities = capabilities}
lspconfig.volar.setup {
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormatting = false
    end,
    on_attach,
    capabilities = capabilities,
}
lspconfig.graphql.setup { on_attach = on_attach, capabilities = capabilities }
lspconfig.prismals.setup { on_attach = on_attach, capabilities = capabilities }
lspconfig.bashls.setup { on_attach = on_attach, capabilities = capabilities }
lspconfig.vimls.setup { on_attach = on_attach, capabilities = capabilities }
lspconfig.marksman.setup { on_attach = on_attach, capabilities = capabilities }
lspconfig.texlab.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        texlab = {
            build = {
                executable = "tectonic",
                args = { "-X", "build", "--keep-logs", "--keep-intermediates" },
                onSave = true,
            },
        },
    },
}
lspconfig.tailwindcss.setup { on_attach = on_attach, capabilities = capabilities }
lspconfig.jdtls.setup { on_attach = on_attach, capabilities = capabilities }
lspconfig.astro.setup { on_attach = on_attach, capabilities = capabilities }
lspconfig.clangd.setup { on_attach = on_attach, capabilities = capabilities }
