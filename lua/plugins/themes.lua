return {
  -- Catpuccin colorscheme
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      vim.cmd 'colorscheme catppuccin'
    end,
  },
  {
    'nyoom-engineering/oxocarbon.nvim',
    -- config = function()
    --   vim.opt.background = 'light'
    --   vim.cmd.colorscheme 'oxocarbon'
    -- end,
  },
  -- Moonfly colorscheme (alternative)
  {
    'bluz71/vim-moonfly-colors',
    priority = 1000,
  },

  -- Kanagawa colorscheme (alternative)
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
  },
}
