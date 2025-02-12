vim.o.completeopt = "menu,menuone,noselect"

local cmp = require("cmp")

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

cmp.setup({
    window = {
        documentation = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        }),
        completion = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        }),
    },
    snippet = { expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end },
    mapping = {
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ["<C-a>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ["<C-n>"] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    vim.api.nvim_feedkeys(t("<Down>"), "n", true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    fallback()
                end
            end,
        }),
        ["<C-p>"] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    vim.api.nvim_feedkeys(t("<Up>"), "n", true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    fallback()
                end
            end,
        }),
    },
    sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "ultisnips" } },
        { { name = "buffer" } }, { { name = "nvim_lua" } }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})
