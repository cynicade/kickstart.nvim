return {
  -- Moonfly colorscheme
  {
    "bluz71/vim-moonfly-colors",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme moonfly")
    end,
  },

  -- Kanagawa colorscheme (alternative)
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
  },
}
