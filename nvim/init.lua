vim.o.showmatch=true              -- show matching 
vim.o.ignorecase=true             -- case insensitive 
vim.o.mouse=v                      -- middle-click paste with 
vim.o.hlsearch=true               -- highlight search 
vim.o.incsearch=true              -- incremental search
vim.o.tabstop=2                    -- number of columns occupied by a tab 
vim.o.softtabstop=2                -- see multiple spaces as tabstops so <BS> does the right thing
vim.o.smarttab=true
vim.o.expandtab=true              -- converts tabs to white space
vim.o.shiftwidth=2                 -- width for autoindents
vim.o.autoindent=true             -- indent a new line the same amount as the line just typed
vim.o.number=true                 -- add line numbers

vim.o.wrap=true
vim.o.linebreak=true

vim.o.smartcase=true
vim.o.cursorline=true
vim.o.selectmode="key"

-- default to UTF-8 encoding
vim.o.encoding="utf8"
vim.o.fileencoding="utf8"
-- enable visible whitespace
vim.opt.listchars = {
  tab = '»·',
  trail = '.',
  precedes = '<',
  extends = '>'
}
vim.o.list=true

vim.opt.wildmode = {
  "longest",
  "list"
} -- get bash-like tab completions
-- vim.o.cc=80                   -- vim.o.an 80 column border for good coding style
vim.o.mouse="a"                 -- enable mouse click
vim.o.clipboard="unnamedplus"   -- using system clipboard
vim.o.cursorline=true              -- highlight current cursorline
vim.o.ttyfast=true                 -- Speed up scrolling in Vim

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup plugins
require("lazy").setup({
  spec = {
    "sainnhe/everforest",
    "sainnhe/gruvbox-material",
    "sainnhe/sonokai",
    "navarasu/onedark.nvim",
    "nvim-treesitter/nvim-treesitter",
    "HiPhish/rainbow-delimiters.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    { "nvim-neo-tree/neo-tree.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

require("config")

-- color scheme
vim.g.gruvbox_material_background="hard"
vim.cmd.colorscheme("gruvbox-material")

