-- Core Neovim options (no plugin dependencies)

-- Leader keys must be set before plugins load
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Mouse support
vim.opt.mouse = "a"

-- Don't show mode (will be in statusline later)
vim.opt.showmode = false

-- Performance
vim.opt.lazyredraw = true

-- Clipboard sync with OS
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Indentation
vim.opt.breakindent = true

-- Undo history
vim.opt.undofile = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- UI elements
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 10

-- Timing
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Live substitution preview
vim.opt.inccommand = "split"

-- Confirm unsaved changes instead of failing
vim.opt.confirm = true
