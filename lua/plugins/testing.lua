return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      -- Adapters
      'marilari88/neotest-vitest',
      'adrigzr/neotest-mocha',
    },
    keys = {
      { '<leader>tr', function() require('neotest').run.run() end, desc = '[T]est [R]un nearest' },
      { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = '[T]est [F]ile' },
      { '<leader>ts', function() require('neotest').summary.toggle() end, desc = '[T]est [S]ummary' },
      { '<leader>to', function() require('neotest').output.open({ enter = true }) end, desc = '[T]est [O]utput' },
      { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = '[T]est Output Panel' },
      { '<leader>tw', function() require('neotest').watch.toggle(vim.fn.expand('%')) end, desc = '[T]est [W]atch' },
      { '<leader>tS', function() require('neotest').run.stop() end, desc = '[T]est [S]top' },
      { '[t', function() require('neotest').jump.prev({ status = 'failed' }) end, desc = 'Prev failed test' },
      { ']t', function() require('neotest').jump.next({ status = 'failed' }) end, desc = 'Next failed test' },
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-vitest'),
          require('neotest-mocha')({
            command = 'npx mocha',
            env = { CI = 'true' },
            cwd = function() return vim.fn.getcwd() end,
          }),
        },
        status = {
          virtual_text = true,
          signs = true,
        },
        output = {
          open_on_run = false,
        },
        quickfix = {
          open = false,
        },
      })
    end,
  },
}
