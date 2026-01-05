# Neovim Cleanup & Reconfiguration Guide

## Objective

Rebuild the Neovim configuration into a **modular, minimal, and durable setup** that survives future ecosystem shifts (Lua/LSP/lazy-loading churn) with **contained changes instead of rewrites**.

This is a cleanup and reconfig, not a feature hunt.

## Pre-Migration Checklist

Before starting the migration:

* [ ] Backup current config: `cp -r ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d)`
* [ ] Verify external dependencies: `which rg fd node npm git`
* [ ] Document current keybinds you actually use daily
* [ ] Create migration branch: `git checkout -b config-migration`
* [ ] Note: Current `init.lua` has uncommitted changes - commit or stash first

## Non-Goals

* Do **not** chase novelty or plugin trends.
* Do **not** introduce overlapping tools.
* Do **not** over-configure defaults unless a concrete annoyance exists.

## Design Principles

1. **One responsibility, one plugin**

   * Picker: Telescope
   * Explorer: Oil
   * LSP: mason + lspconfig
   * Completion: blink.cmp
   * Formatting: conform.nvim

2. **Churn isolation**

   * Core editor behavior must not depend on plugins.
   * Plugin changes should be isolated to single files.

3. **Delete first**

   * If unsure whether a plugin is needed, remove it.
   * Re-add only after missing it for real work.

4. **Defaults over cleverness**

   * Prefer upstream defaults.
   * Every non-default must justify its existence.

## Target Structure

```
~/.config/nvim/
  init.lua
  lua/
    core/
      options.lua
      keymaps.lua
      autocmds.lua
    plugins/
      init.lua
      telescope.lua
      oil.lua
      treesitter.lua
      lsp.lua
      completion.lua
      format.lua
      git.lua
      ui.lua
```

### Rules

* `core/*` **must not** require plugins.
* `plugins/*` contains **only lazy.nvim specs**.
* Plugin-specific keymaps live with the plugin.
* Global muscle-memory keymaps live in `core/keymaps.lua`.
* Remove `lua/kickstart/` and `lua/custom/` directories (replaced by new structure).

## Migration Decisions

### Current Config Conflicts

The existing config violates several design principles:

**Plugins to Remove:**
* `snacks.nvim` - Mega-suite plugin (contradicts "one responsibility, one plugin")
* `dashboard.nvim` - Redundant with snacks.dashboard (duplication)
* Multiple colorschemes (7 installed, keep max 2-3):
  - Keep: moonfly, kanagawa
  - Remove: lackluster, oxocarbon, vscode, poimandres, rose-pine

**Plugins Requiring Decisions:**
* Git tools overlap: gitsigns (keep), neogit (?), diffview (dependency), octo.nvim (?)
* Text object plugins: mini.ai, mini.surround, nvim-treesitter-textobjects
* Decide: Do you use GitHub integration (octo.nvim) daily?
* Decide: Do you use vim-tmux-navigator daily?

**Keybinds to Preserve:**
* `jk` → escape (muscle memory - keep)
* `,,` → append comma (decide: keep or drop?)
* `;;` → append semicolon (decide: keep or drop?)
* `<C-h/j/k/l>` → window navigation (keep)

## Migration Plan

### Phase 1 — Stabilize

* Create the folder structure above.
* Remove `lua/kickstart/` and `lua/custom/` directories.
* Delete `lazy-lock.json` (will regenerate).
* Reduce `init.lua` to a loader only.
* Bootstrap lazy.nvim and verify startup.

**Validation Checklist:**
* [ ] Neovim starts without errors
* [ ] `:checkhealth lazy` shows no critical issues
* [ ] Lazy.nvim UI opens with `:Lazy`

### Phase 2 — Core Editor

* Move all options into `core/options.lua`.
* Move global keymaps into `core/keymaps.lua`.
* Move autocmds into `core/autocmds.lua`.
* Ensure Neovim works **without any plugins enabled**.

**Validation Checklist:**
* [ ] Neovim starts without errors (plugins disabled)
* [ ] Can create, edit, and save files
* [ ] Leader key (`<space>`) works
* [ ] Window navigation (`<C-h/j/k/l>`) works
* [ ] `jk` escapes to normal mode
* [ ] Options like line numbers, relative numbers visible
* [ ] `:checkhealth` shows no core issues

### Phase 3 — Spine Plugins (in order)

Add plugins one file at a time:

1. **Telescope** (picker spine) - `plugins/telescope.lua`
   - [ ] Can find files (`<leader>sf`)
   - [ ] Can grep (`<leader>sg`)
   - [ ] Can switch buffers (`<leader><leader>`)

2. **Oil** (file explorer) - `plugins/oil.lua`
   - [ ] Opens with `<leader>e`
   - [ ] Can navigate and edit filesystem

3. **Treesitter** - `plugins/treesitter.lua`
   - [ ] Syntax highlighting works
   - [ ] `:checkhealth nvim-treesitter` passes

4. **LSP** (mason + lspconfig) - `plugins/lsp.lua`
   - [ ] Mason installs servers
   - [ ] LSP attaches to files (check `:LspInfo`)
   - [ ] Go to definition works (`grd`)
   - [ ] Hover documentation works (`K`)

5. **Completion** (blink.cmp) - `plugins/completion.lua`
   - [ ] Completions appear in insert mode
   - [ ] Can accept with `<C-y>`
   - [ ] LSP completions work

6. **Formatting** (conform.nvim) - `plugins/format.lua`
   - [ ] Format on save works
   - [ ] Manual format works (`<leader>f`)

After each step: Restart Neovim, verify checklist, commit

### Phase 4 — Nice-to-Haves

Only after the spine is stable:

* **Git UI** - `plugins/git.lua`
  - gitsigns (git signs in gutter)
  - Decide: neogit vs fugitive vs lazygit.nvim

* **UI enhancements** - `plugins/ui.lua`
  - which-key (keymap hints)
  - mini.statusline OR lualine (not both)
  - Decide: zen-mode vs no-neck-pain

* **Themes** - `plugins/themes.lua`
  - Max 2-3: moonfly, kanagawa

* **Optional tools** (add only if needed):
  - octo.nvim (GitHub integration) - requires daily use to justify
  - vim-tmux-navigator - only if using tmux daily
  - persistence.nvim (session management) - only if you use sessions

**Validation:**
* [ ] Each plugin serves one clear purpose
* [ ] No duplicated functionality
* [ ] Can explain why each plugin is essential

## Plugin Hygiene Rules

* No mega-suite plugins unless they fully replace existing tools.
* No duplicated explorers, pickers, dashboards, or statuslines.
* Pin versions with `lazy-lock.json`.
* Update plugins on a schedule, not continuously.

## External Dependencies

Required for plugins to work:

* `ripgrep` - Telescope grep functionality
* `fd` - Telescope file finding (optional but recommended)
* `node` + `npm` - Some LSP servers require Node.js
* `git` - lazy.nvim and gitsigns

Verify installation: `which rg fd node npm git`

## Rollback Strategy

If a phase breaks:

1. **If committed:** `git reset --hard HEAD~1` (or specific commit)
2. **If not committed:** `git checkout .` to discard changes
3. **Nuclear option:** `rm -rf ~/.config/nvim && cp -r ~/.config/nvim.backup.<date> ~/.config/nvim`
4. Fix the issue on a separate branch before re-attempting

## Maintenance Policy

* Updates happen on a branch.
* Expect breakage during updates.
* Fix once, commit, move on.
* If a plugin causes repeated churn, remove it.
* Review plugins quarterly - delete what you haven't used.

## Success Criteria

* Any behavior can be located in <30 seconds.
* Adding/removing a plugin touches one file.
* A Neovim update no longer implies a rewrite.
* Plugin count stays under 15 total.

## Keybind Quick Reference

### Core (Muscle Memory) - `core/keymaps.lua`

| Key | Action | Notes |
|-----|--------|-------|
| `<space>` | Leader | Set before plugins load |
| `jk` | Escape to normal | Insert mode only |
| `<C-h/j/k/l>` | Window navigation | Works with vim-tmux-navigator if enabled |
| `<Esc>` | Clear search highlight | Normal mode |

### Plugins - Defined in respective plugin files

| Key | Action | Plugin | File |
|-----|--------|--------|------|
| `<leader>sf` | Find files | Telescope | `plugins/telescope.lua` |
| `<leader>sg` | Live grep | Telescope | `plugins/telescope.lua` |
| `<leader><leader>` | Find buffers | Telescope | `plugins/telescope.lua` |
| `<leader>e` | File explorer | Oil | `plugins/oil.lua` |
| `<leader>f` | Format buffer | Conform | `plugins/format.lua` |
| `grd` | Go to definition | LSP | `plugins/lsp.lua` |
| `grn` | Rename symbol | LSP | `plugins/lsp.lua` |
| `gra` | Code action | LSP | `plugins/lsp.lua` |
| `K` | Hover documentation | LSP | `plugins/lsp.lua` |

## Decision Log

Track plugin addition/removal decisions here:

* **2026-01-05** - Migration complete! Reduced from 30+ plugins to 14 modular plugins
* **2026-01-05** - Removed snacks.nvim (mega-suite, replaced with mini.nvim + dedicated tools)
* **2026-01-05** - Removed dashboard.nvim (not needed, Neovim starts fast enough)
* **2026-01-05** - Kept both gitsigns AND neogit (gitsigns for inline, neogit for complex operations)
* **2026-01-05** - Removed 5 colorschemes (lackluster, oxocarbon, vscode, poimandres, rose-pine)
* **2026-01-05** - Kept moonfly (primary) and kanagawa (alternative)
* **2026-01-05** - Kept octo.nvim (GitHub integration used regularly)
* **2026-01-05** - Kept vim-tmux-navigator (tmux used daily)
* **2026-01-05** - Kept `,,` and `;;` keybinds (used daily)

---

This config exists to support work, not become work.
