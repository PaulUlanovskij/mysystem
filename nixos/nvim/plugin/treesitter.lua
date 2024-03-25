vim.opt.runtimepath:append("~/mysystem/nixos/nvim/non-build/tree-sitter-parsers")


require('nvim-treesitter.configs').setup {
    
    parser_install_dir = "~/mysystem/nixos/nvim/non-build/tree-sitter-parsers",

    ensure_installed = { 'vim', 'vimdoc', 'lua', 'cpp' },

    auto_install = true,

    highlight = { enable = true },

    indent = { enable = true },
}
