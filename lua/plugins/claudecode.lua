return {
  "coder/claudecode.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("claudecode").setup({
      -- Configuration options for claudecode
      -- You can customize settings here as needed
    })

    -- Keymaps for Claude Code
    local map = vim.keymap.set

    map("n", "<leader>cc", "<cmd>ClaudeCode<CR>", { desc = "[C]laude [C]ode" })
    map("v", "<leader>cc", "<cmd>ClaudeCode<CR>", { desc = "[C]laude [C]ode" })
    map("t", "<leader>cc", "<cmd>ClaudeCode<CR>", { desc = "[C]laude [C]ode" })
    map("n", "<leader>ca", "<cmd>ClaudeCodeAsk<CR>", { desc = "[C]laude [A]sk" })
    map("n", "<leader>ct", "<cmd>ClaudeCodeToggle<CR>", { desc = "[C]laude [T]oggle" })
    map("t", "<leader>ct", "<cmd>ClaudeCodeToggle<CR>", { desc = "[C]laude [T]oggle" })
  end,
}
