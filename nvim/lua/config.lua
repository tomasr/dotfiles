require 'nvim-treesitter.install'.compilers = { "cl", "gcc", "cc" }
require('nvim-treesitter.config').setup({
    ensure_installed = {
      "c", "c_sharp","java", 
      "html", "lua", "markdown",
      "powershell", "bash", "xml",
      "make", "javascript", "json",
      "go", "luadoc", "vimdoc"
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

require('neo-tree').setup({
  -- options go here
})

require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'codedark',
    section_separators = {
      left = '\u{E0BC}',
      right = '\u{E0BA}'
    },
    component_separators = {
      left = '\u{E0BD}',
      right = '\u{E0BD}'
    }
  },
  tabline = {
    lualine_a = {'buffers'},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {'tabs'}
  }
})

