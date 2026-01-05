-- Core keymaps (no plugin dependencies)
-- Plugin-specific keymaps live in their respective plugin files

local map = vim.keymap.set

-- Clear search highlight on Esc
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Quick escape from insert mode
map("i", "jk", "<Esc>", { desc = "Escape to normal mode" })

-- Append punctuation and return to normal mode
map("i", ",,", "<Esc>A,<Esc>", { desc = "Append comma" })
map("i", ";;", "<Esc>A;<Esc>", { desc = "Append semicolon" })

-- Window navigation (works with vim-tmux-navigator if installed)
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move to left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move to right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move to upper window" })

-- Terminal mode escape
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Diagnostic quickfix list
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix list" })
