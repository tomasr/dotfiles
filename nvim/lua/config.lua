require 'nvim-treesitter.install'.compilers = { "cl", "gcc", "cc" }
require('nvim-treesitter.configs').setup({
    ensure_installed = {
      "c", "c_sharp","java", 
      "html", "lua", "markdown",
      "powershell", "bash", "xml",
      "make", "javascript", "json",
      "go"
    }, -- one of 'all', 'maintained' (parsers with maintainers), or a list of languages
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
    indent = {
        enable = true,
    },
    matchup = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<CR>',
            scope_incremental = '<CR>',
            node_incremental = '<TAB>',
            node_decremental = '<S-TAB>',
        },
    },
})

