return {
  -- FZF-lua for plugins that need a picker (octo, neogit)
  {
    'ibhagwan/fzf-lua',
    lazy = true,
  },

  -- Which-key - keymap hints
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
        },
      },
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>n', group = '[N]eogit/[N]otifications' },
        { '<leader>o', group = '[O]cto (GitHub)' },
        { '<leader>g', group = '[G]it' },
        { '<leader>c', group = '[C]laude Code' },
        { '<leader>u', group = '[U]I/Notifications' },
      },
    },
  },

  -- Mini.nvim modules
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better text objects
      require('mini.ai').setup { n_lines = 500 }

      -- Surround operations (using gs prefix to preserve native s behavior)
      require('mini.surround').setup({
        mappings = {
          add = 'gsa',            -- Add surrounding
          delete = 'gsd',         -- Delete surrounding
          find = 'gsf',           -- Find surrounding (to the right)
          find_left = 'gsF',      -- Find surrounding (to the left)
          highlight = 'gsh',      -- Highlight surrounding
          replace = 'gsr',        -- Replace surrounding
          update_n_lines = 'gsn', -- Update `n_lines`
        },
      })

      -- Statusline
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  -- Zen mode
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    keys = {
      { '<leader>z', '<cmd>ZenMode<CR>', desc = 'Toggle [Z]en mode' },
    },
    opts = {
      window = {
        width = 120,
        options = {
          number = true,
          relativenumber = true,
        },
      },
    },
  },
  -- GitHub integration
  {
    'pwntester/octo.nvim',
    cmd = 'Octo',
    opts = {
      picker = 'fzf-lua', -- Use fzf-lua as fallback (octo doesn't support snacks picker yet)
      enable_builtin = true,
    },
    keys = {
      { '<leader>oi', '<cmd>Octo issue list<CR>', desc = 'List GitHub [I]ssues' },
      { '<leader>op', '<cmd>Octo pr list<CR>', desc = 'List GitHub [P]Rs' },
      { '<leader>od', '<cmd>Octo discussion list<CR>', desc = 'List GitHub [D]iscussions' },
      { '<leader>on', '<cmd>Octo notification list<CR>', desc = 'List GitHub [N]otifications' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'ibhagwan/fzf-lua',
      'nvim-tree/nvim-web-devicons',
    },
  },

  -- Highlight TODOs in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  -- Sessions
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {
      dir = vim.fn.stdpath 'state' .. '/sessions/',
    },
    keys = {
      {
        '<leader>qs',
        function()
          require('persistence').load()
        end,
        desc = 'Restore Session',
      },
      {
        '<leader>qS',
        function()
          require('persistence').select()
        end,
        desc = 'Select Session',
      },
      {
        '<leader>ql',
        function()
          require('persistence').load { last = true }
        end,
        desc = 'Restore Last Session',
      },
    },
  },
}
