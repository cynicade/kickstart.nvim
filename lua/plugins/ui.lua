return {
  -- Which-key - keymap hints
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = "<Up> ",
          Down = "<Down> ",
          Left = "<Left> ",
          Right = "<Right> ",
          C = "<C-…> ",
          M = "<M-…> ",
          D = "<D-…> ",
          S = "<S-…> ",
          CR = "<CR> ",
          Esc = "<Esc> ",
          ScrollWheelDown = "<ScrollWheelDown> ",
          ScrollWheelUp = "<ScrollWheelUp> ",
          NL = "<NL> ",
          BS = "<BS> ",
          Space = "<Space> ",
          Tab = "<Tab> ",
        },
      },
      spec = {
        { "<leader>s", group = "[S]earch" },
        { "<leader>t", group = "[T]oggle" },
        { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
        { "<leader>n", group = "[N]eogit" },
        { "<leader>o", group = "[O]cto (GitHub)" },
      },
    },
  },

  -- Mini.nvim modules
  {
    "echasnovski/mini.nvim",
    config = function()
      -- Better text objects
      require("mini.ai").setup({ n_lines = 500 })

      -- Surround operations
      require("mini.surround").setup()

      -- Statusline
      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = vim.g.have_nerd_font })
      statusline.section_location = function()
        return "%2l:%-2v"
      end
    end,
  },

  -- Zen mode
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<CR>", desc = "Toggle [Z]en mode" },
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

  -- Tmux navigator
  {
    "christoomey/vim-tmux-navigator",
  },

  -- GitHub integration
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    opts = {
      picker = "telescope",
      enable_builtin = true,
    },
    keys = {
      { "<leader>oi", "<cmd>Octo issue list<CR>", desc = "List GitHub [I]ssues" },
      { "<leader>op", "<cmd>Octo pr list<CR>", desc = "List GitHub [P]Rs" },
      { "<leader>od", "<cmd>Octo discussion list<CR>", desc = "List GitHub [D]iscussions" },
      { "<leader>on", "<cmd>Octo notification list<CR>", desc = "List GitHub [N]otifications" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- Highlight TODOs in comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
}
