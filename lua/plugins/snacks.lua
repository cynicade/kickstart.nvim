-- Two bottom terminals side-by-side + a float toggle
local function bottom_terms()
  local height = 15

  -- Create/reuse 2 distinct terminal buffers WITHOUT showing windows
  local t1 = Snacks.terminal.get(nil, {
    env = { SNACKS_TERM = '1' },
    win = { show = false },
  })
  local t2 = Snacks.terminal.get(nil, {
    env = { SNACKS_TERM = '2' },
    win = { show = false },
  })

  -- If we already have both terminals visible anywhere, just jump to the first one
  local wins = vim.api.nvim_list_wins()
  local w1, w2
  for _, w in ipairs(wins) do
    local b = vim.api.nvim_win_get_buf(w)
    if b == t1.buf then
      w1 = w
    end
    if b == t2.buf then
      w2 = w
    end
  end
  if w1 and w2 then
    vim.api.nvim_set_current_win(w1)
    vim.cmd 'startinsert'
    return
  end

  -- Otherwise: create exactly one bottom split, then vsplit inside it
  vim.cmd(('botright %dsplit'):format(height))
  local w_left = vim.api.nvim_get_current_win()
  vim.cmd 'vsplit'
  local w_right = vim.api.nvim_get_current_win()

  -- Put terminal buffers into those two windows (and nowhere else)
  vim.api.nvim_win_set_buf(w_left, t1.buf)
  vim.api.nvim_win_set_buf(w_right, t2.buf)

  vim.api.nvim_set_current_win(w_left)
  vim.cmd 'startinsert'
end

local function toggle_float_term()
  -- cmd provided => Snacks defaults to floating, but we also force float explicitly
  Snacks.terminal.toggle(vim.o.shell, {
    win = {
      position = 'float',
      width = 0.9,
      height = 0.85,
    },
  })
end

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    -- Core snacks modules
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },

    -- Picker configuration (replaces telescope)
    picker = { enabled = true },

    -- Git integration
    gitbrowse = { enabled = true },
    lazygit = { enabled = true },

    -- Terminal
    terminal = { enabled = true },
  },
  keys = {
    -- Picker keymaps (replaces telescope)
    {
      '<leader>sf',
      function()
        Snacks.picker.files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = '[S]earch by [G]rep',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = '[S]earch current [W]ord',
    },
    {
      '<leader><leader>',
      function()
        Snacks.picker.buffers()
      end,
      desc = '[ ] Find existing buffers',
    },
    {
      '<leader>sh',
      function()
        Snacks.picker.help()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = '[S]earch [K]eymaps',
    },
    {
      '<leader>sd',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = '[S]earch [D]iagnostics',
    },
    {
      '<leader>sr',
      function()
        Snacks.picker.resume()
      end,
      desc = '[S]earch [R]esume',
    },
    {
      '<leader>s.',
      function()
        Snacks.picker.recent()
      end,
      desc = '[S]earch Recent Files ("." for repeat)',
    },
    {
      '<leader>sn',
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim files',
    },
    {
      '<leader>/',
      function()
        Snacks.picker.lines()
      end,
      desc = '[/] Search in current buffer',
    },
    {
      '<leader>s/',
      function()
        Snacks.picker.grep { grep_open_files = true }
      end,
      desc = '[S]earch [/] in Open Files',
    },
    {
      '<leader>ss',
      function()
        Snacks.picker.pickers()
      end,
      desc = '[S]earch [S]elect Snacks Picker',
    },

    -- Git keymaps
    {
      '<leader>gc',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazygit',
    },
    {
      '<leader>gf',
      function()
        Snacks.lazygit.log_file()
      end,
      desc = 'Lazygit Current File History',
    },
    {
      '<leader>gl',
      function()
        Snacks.lazygit.log()
      end,
      desc = 'Lazygit Log',
    },
    {
      '<leader>gb',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git Browse',
    },

    -- Terminal
    -- bottom 2-up
    { '<leader>td', bottom_terms, desc = '[T]erminals Bottom 2-up' },

    -- focus each one quickly (optional but useful)
    {
      '<leader>t1',
      function()
        Snacks.terminal.toggle(nil, { env = { SNACKS_TERM = '1' }, win = { position = 'bottom', height = 15 } })
      end,
      desc = '[T]erminal 1 (bottom)',
    },
    {
      '<leader>t2',
      function()
        Snacks.terminal.toggle(nil, { env = { SNACKS_TERM = '2' }, win = { position = 'bottom', height = 15 } })
      end,
      desc = '[T]erminal 2 (bottom)',
    },
    -- float toggle
    { '<leader>tt', toggle_float_term, desc = '[T]erminal Floa[t]' },
    { '<leader>tt', toggle_float_term, desc = '[T]erminal Floa[t]', mode = 't' },
    -- Easy escape from terminal mode (double ESC)
    { '<Esc><Esc>', '<C-\\><C-n>', desc = 'Exit terminal mode', mode = 't' },
    -- Notifications
    {
      '<leader>un',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'Dismiss All Notifications',
    },
    {
      '<leader>nh',
      function()
        Snacks.notifier.show_history()
      end,
      desc = 'Notification History',
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Setup some globals for convenience
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd
      end,
    })
  end,
}
