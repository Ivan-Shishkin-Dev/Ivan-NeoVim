# CLAUDE.md

Project-level guidance for Claude Code when working in this repository.

## Overview

A personal Neovim configuration built on [lazy.nvim](https://github.com/folke/lazy.nvim) using idiomatic single-file-per-plugin specs. Structurally inspired by ThePrimeagen's "Neovim from scratch" tutorial but modernized for current plugin APIs (Packer → lazy.nvim, LSP-Zero → Mason+lspconfig+nvim-cmp, Harpoon → harpoon2, treesitter playground → core `:InspectTree`).

User-facing documentation lives in `README.md`. This file is for AI assistants and contributors who need to understand the codebase's structure and conventions.

## Update policy

**Every meaningful change to this config MUST update both `README.md` and `CLAUDE.md` in the same commit.**

Includes:
- Adding, removing, or replacing a plugin
- Adding or removing a language server from `lua/plugins/lsp.lua`
- Bumping Neovim or tooling version requirements
- Changing a public keybinding
- Restructuring directories or boot order
- Adopting a new API (e.g. the `vim.lsp.config` migration)

Skip for: typo fixes, comment-only edits, formatting, internal refactors with no behavior change.

When in doubt: update both. `README.md` is the user contract; `CLAUDE.md` is the AI/contributor contract. They drift fast if not maintained together.

## Architecture

```
~/.config/nvim/            (Windows: %LOCALAPPDATA%\nvim\)
├── init.lua                    Entry point — only 2 requires
├── lazy-lock.json              Plugin version lockfile (committed)
├── README.md                   User-facing setup docs
├── CLAUDE.md                   This file
└── lua/
    ├── config/
    │   └── lazy.lua            lazy.nvim bootstrap (clone + setup call)
    ├── ivan/                   Personal settings (namespace = user's name)
    │   ├── init.lua            Loads set → remap (order matters)
    │   ├── set.lua             vim.opt.* editor options + leader keys
    │   └── remap.lua           Personal keymaps (uses <leader>)
    └── plugins/                Auto-discovered by lazy via `{ import = "plugins" }`
        ├── tokyonight.lua      Colorscheme (Storm, transparent)
        ├── telescope.lua       Fuzzy finder + grep
        ├── treesitter.lua      Syntax highlighting (master branch pinned)
        ├── harpoon.lua         File pinning (harpoon2 branch pinned)
        ├── undotree.lua        Undo history viewer
        ├── fugitive.lua        Git integration
        ├── easy-align.lua      junegunn/vim-easy-align (lazy-loaded on `ga` / :EasyAlign)
        ├── autopairs.lua       windwp/nvim-autopairs (lazy-loaded on InsertEnter, cmp-integrated)
        └── lsp.lua             Mason + lspconfig + nvim-cmp + LuaSnip
```

There is **no `after/plugin/` directory**. All plugin configuration lives inline in `config = function()` blocks within `lua/plugins/<plugin>.lua`.

## Boot order

```
nvim starts
└── init.lua
    ├── require("ivan")                    → lua/ivan/init.lua
    │   ├── require("ivan.set")            → sets vim.opt.* AND vim.g.mapleader
    │   └── require("ivan.remap")          → vim.keymap.set("<leader>...", ...)
    └── require("config.lazy")             → bootstraps lazy + imports lua/plugins/*
```

### Critical invariants

1. **`ivan.set` must load before `ivan.remap`.** `vim.keymap.set("n", "<leader>X", ...)` resolves `<leader>` to whatever `vim.g.mapleader` is **at the moment the keymap is created**. If `mapleader` isn't set yet, the keymap binds to the default leader (`\`) instead of `<Space>`. The order in `lua/ivan/init.lua` is enforced for this reason.

2. **Leader keys must be set before lazy loads.** Plugin specs in `lua/plugins/*.lua` contain `<leader>X` keymaps that get bound when lazy processes them. `require("ivan")` runs before `require("config.lazy")` in `init.lua` to guarantee this.

3. **`vim.g.mapleader` is defined in exactly one place.** `lua/ivan/set.lua`. Do not re-set it in `lua/config/lazy.lua` or anywhere else — single source of truth.

## Plugin convention

Each plugin gets its own file under `lua/plugins/<plugin>.lua`. The file returns a table that lazy.nvim treats as a plugin spec:

```lua
return {
  "author/plugin-name",
  -- optional: branch, tag, dependencies, lazy, priority, build
  config = function()
    require("plugin-name").setup({ ... })
    -- keymaps that depend on the plugin go here
    vim.keymap.set("n", "<leader>x", ...)
  end,
}
```

**Why inline config:**
- Lazy.nvim runs `config` only after the plugin is actually loaded — no module-not-found errors at startup.
- Lazy catches errors inside `config` so one broken plugin doesn't take down the whole startup.
- Co-located: one file = install + config + keymaps for one plugin.

**Do not** create files under `after/plugin/`. The runtime would source them at startup before lazy has installed the plugin, causing `require()` failures.

## LSP stack

This project uses **Mason + nvim-lspconfig + nvim-cmp** (the modern standard). It does **not** use LSP-Zero (neither the v1 API in old tutorials nor the v3 preset wrapper). All LSP setup lives in `lua/plugins/lsp.lua`.

Activation uses **nvim 0.11+'s native `vim.lsp.config()` + `vim.lsp.enable()` API** rather than the deprecated `require("lspconfig").server.setup(...)` calls (which nvim-lspconfig will remove in v3.0.0). A single `vim.lsp.config("*", { capabilities = ... })` call sets defaults for every server; `vim.lsp.enable({ ... })` activates the list. Server configs themselves come from nvim-lspconfig's bundled `lsp/<server>.lua` files via runtime path — no explicit require needed.

The servers list appears twice in `lsp.lua` — `ensure_installed` (for Mason auto-install) and the `vim.lsp.enable({...})` call (for activation). Both must include any new server.

Keymaps are **not** overridden. Nvim 0.11+ ships built-in LSP keymaps that fire automatically when an LSP attaches:

| Key | Action |
|---|---|
| `K` | Hover docs |
| `grn` | Rename |
| `gra` | Code action |
| `grr` | References |
| `gri` | Implementation |
| `gO` | Document symbols |
| `[d` / `]d` | Prev / next diagnostic |
| `<C-]>` | Go to definition (via tagfunc) |
| `<C-S>` (insert) | Signature help |

Completion uses `cmp.mapping.preset.insert()` defaults — `<C-n>` / `<C-p>` navigate, `<C-y>` confirms, `<C-Space>` triggers, `<C-e>` cancels.

## How to extend

### Add a plugin
Create `lua/plugins/<name>.lua` returning a spec table. Restart nvim — lazy auto-discovers it.

### Add a language server
Edit `lua/plugins/lsp.lua`. Add the server's name to **both**:
1. `ensure_installed = { ... }` inside the `mason-lspconfig` setup
2. The `vim.lsp.enable({ ... })` list below it

Restart nvim. Mason installs the binary in the background; status visible via `:Mason`.

### Add a keymap
- Personal/global: append a `vim.keymap.set(...)` line to `lua/ivan/remap.lua`.
- Plugin-specific: add it inside that plugin's `config = function()` block in `lua/plugins/<plugin>.lua`.

### Add an editor option
Append a `vim.opt.X = value` line to `lua/ivan/set.lua`.

### Change the colorscheme
Edit the `style` field in `lua/plugins/tokyonight.lua` (`"storm" | "night" | "moon" | "day"`), or replace the entire file with a different colorscheme plugin's spec.

## Verifying changes

After any edit, restart nvim (not `:so %`) — lazy doesn't re-process plugin specs on source. Then:

```vim
:Lazy                     " plugin install/update status
:Mason                    " LSP server install status
:checkhealth              " general diagnostic
:checkhealth lsp          " LSP-specific
:messages                 " any startup errors land here
```

For LSP changes specifically: open a file of the target language, run `:LspInfo` to confirm the server attached.

## Pinned versions worth knowing

| Plugin | Pinned to | Why |
|---|---|---|
| `nvim-treesitter` | `branch = "master"` | A `main` branch with a redesigned API is under development. Pinning prevents accidental breakage if/when the default branch flips. |
| `ThePrimeagen/harpoon` | `branch = "harpoon2"` | v1's API (`require("harpoon.mark")`) is incompatible with v2's (`harpoon:list():add()`). Old tutorials show v1 — do not follow them. |

## Requirements

Nvim **0.11+** required — the LSP setup uses `vim.lsp.config()` / `vim.lsp.enable()` which only exist in 0.11+. Treesitter needs a C compiler. Telescope's grep prompt needs `ripgrep`. Several LSPs need Node.js. `vim.opt.clipboard = "unnamedplus"` is set in `lua/ivan/set.lua`, so on Linux a clipboard provider (`xclip`, `xsel`, or `wl-clipboard`) must be installed — macOS and Windows ship handlers nvim auto-detects. See `README.md` for the per-OS install commands.
