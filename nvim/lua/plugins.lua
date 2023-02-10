local install_path = vim.fn.stdpath("data") ..
                         "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({
        "git", "clone", "--depth", "1",
        "https://github.com/wbthomason/packer.nvim", install_path,
    })
end

-- automatically install new plugins whenever this file is changed
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require("packer").startup(function(use)
    -- packer.nvim can manage itself
    use "wbthomason/packer.nvim"
    -- syntactic lang support
    use "rust-lang/rust.vim"
    use "pantharshit00/vim-prisma"
    use "martinda/Jenkinsfile-vim-syntax"
    use "lervag/vimtex"
    use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
    -- semantic lang support
    use "neovim/nvim-lspconfig"
    use "SirVer/ultisnips"
    use "honza/vim-snippets"
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline", "quangnguyen30192/cmp-nvim-ultisnips",
            "hrsh7th/cmp-nvim-lua",
        },
    }
    -- fuzzy finder
    use "nvim-lua/popup.nvim"
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            {"nvim-lua/plenary.nvim"}, {"kyazdani42/nvim-web-devicons"},
            {"nvim-telescope/telescope-ui-select.nvim"},
        },
    }
    -- vim sane defaults
    use "tpope/vim-commentary"
    use "tpope/vim-unimpaired"
    use "tpope/vim-eunuch"
    use "tpope/vim-surround"
    -- git and files
    use "tpope/vim-fugitive"
    use {"lewis6991/gitsigns.nvim", requires = {"nvim-lua/plenary.nvim"}}
    -- use "lstwn/broot.vim"
    use "~/Projects/broot.vim"
    -- ux improvements
    -- use "lstwn/terminal.vim"
    use "~/Projects/terminal.vim"
    use "~/Projects/galaxyline.nvim"
    use "tpope/vim-abolish"
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })
end)
