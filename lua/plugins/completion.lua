return {
  "saghen/blink.cmp",
  event = "VimEnter",
  version = "1.*",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      version = "2.*",
      build = (function()
        if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
      dependencies = {
        {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
          end,
        },
      },
      opts = {},
    },
    "folke/lazydev.nvim",
  },
  opts = {
    keymap = {
      preset = "default", -- <c-y> to accept, <tab>/<s-tab> for snippets
    },
    completion = {
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },
    sources = {
      default = { "lsp", "path", "snippets", "lazydev" },
      providers = {
        lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
      },
    },
    snippets = { preset = "luasnip" },
    fuzzy = { implementation = "lua" },
    signature = { enabled = true },
  },
  -- Update LSP capabilities after blink.cmp loads
  config = function(_, opts)
    local blink = require("blink.cmp")
    blink.setup(opts)

    -- Update LSP servers with blink.cmp capabilities
    local capabilities = blink.get_lsp_capabilities()
    local lspconfig = require("lspconfig")

    -- Update any already-running LSP servers
    for _, server in ipairs({ "clangd", "gopls", "rust_analyzer", "lua_ls" }) do
      if lspconfig[server] then
        local config = lspconfig[server]
        if config.manager and config.manager.config then
          config.manager.config.capabilities = vim.tbl_deep_extend("force", config.manager.config.capabilities or {}, capabilities)
        end
      end
    end
  end,
}
