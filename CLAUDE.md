# CLAUDE.md

Project-level guidance for Claude Code when working in this repository.

## Overview

A personal Neovim configuration built on [lazy.nvim](https://github.com/folke/lazy.nvim) using idiomatic single-file-per-plugin specs. Structurally inspired by ThePrimeagen's "Neovim from scratch" tutorial but modernized for current plugin APIs (Packer → lazy.nvim, LSP-Zero → Mason+lspconfig+nvim-cmp, treesitter playground → core `:InspectTree`).

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
    └── plugins/                  Auto-discovered by lazy via `{ import = "plugins" }`
        ├── tokyonight.lua        folke/tokyonight.nvim — colorscheme (Storm, transparent)
        ├── mini-statusline.lua   nvim-mini/mini.statusline — stock setup, loaded on VeryLazy
        ├── bufferline.lua        akinsho/bufferline.nvim — top buffer line, needs nvim-web-devicons; `numbers = "ordinal"` + `<leader>1`–`<leader>9` jump to position N
        ├── neo-tree.lua          nvim-neo-tree/neo-tree.nvim — sidebar tree (pinned to v3.x); `<leader>e` toggles
        ├── telescope.lua         nvim-telescope/telescope.nvim — fuzzy finder + grep
        ├── treesitter.lua        nvim-treesitter/nvim-treesitter — `main` branch (rewrite); installs parsers, FileType autocmds wire `vim.treesitter.start()` + experimental indentexpr
        ├── treesitter-context.lua nvim-treesitter/nvim-treesitter-context — sticky header showing enclosing function/class; stock setup, lazy-loaded on BufReadPre/BufNewFile
        ├── render-markdown.lua   MeanderingProgrammer/render-markdown.nvim — in-buffer rendering for markdown (headings, code blocks, checkboxes); `ft = "markdown"`, needs the `markdown`+`markdown_inline` parsers
        ├── indent-blankline.lua  lukas-reineke/indent-blankline.nvim — v3, module name is `ibl`
        ├── todo-comments.lua     folke/todo-comments.nvim — TODO/FIXME highlights + `:TodoTelescope`
        ├── which-key.lua         folke/which-key.nvim — popup after `<leader>`, stock setup
        ├── undotree.lua          mbbill/undotree — undo viewer
        ├── fugitive.lua          tpope/vim-fugitive — git (whole-file/repo ops)
        ├── gitsigns.lua          lewis6991/gitsigns.nvim — per-line git status in the sign column; stock setup, no keymaps (opt in via on_attach if needed)
        ├── autopairs.lua         windwp/nvim-autopairs — lazy-loaded on InsertEnter, cmp-integrated
        ├── conform.lua           stevearc/conform.nvim — `<leader>al` formats buffer; per-filetype formatter table inside
        └── lsp.lua               Mason + lspconfig + nvim-cmp + LuaSnip + friendly-snippets
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

### Add a formatter
Edit `lua/plugins/conform.lua`:
1. Add an entry to `formatters_by_ft` mapping the filetype to the formatter name.
2. If the formatter needs non-default args (e.g. forcing 4-space indent), add an entry under `formatters = { ... }` with `prepend_args = { ... }`.
3. Install the binary: `:MasonInstall <name>` or via the system package manager.

Run `:ConformInfo` in a buffer of that filetype to confirm conform sees the formatter and that the binary is on PATH.

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
| `nvim-treesitter` | `branch = "main"` | `main` is the rewrite (and the repo's current default branch). `master` is the legacy modules API and is mostly in maintenance mode. We pin `main` explicitly so a future upstream default-branch rename doesn't silently flip us. |
| `neo-tree.nvim` | `branch = "v3.x"` | v2 had a different setup API; pinning `v3.x` keeps us on the line of releases the spec is written against. |

## Requirements

Nvim **0.11+** required — the LSP setup uses `vim.lsp.config()` / `vim.lsp.enable()` which only exist in 0.11+ (tested on 0.12). Treesitter needs a C compiler. Telescope's grep prompt needs `ripgrep`. Several LSPs need Node.js. `vim.opt.clipboard = "unnamedplus"` is set in `lua/ivan/set.lua`, so on Linux a clipboard provider (`xclip`, `xsel`, or `wl-clipboard`) must be installed — macOS and Windows ship handlers nvim auto-detects.

**Formatter binaries (optional):** conform.nvim is configured for a set of filetypes but the binaries (`stylua`, `black`, `prettier`, `clang-format`, `rustfmt`, `csharpier`, `shfmt`) are not bundled — install only the ones you need via Mason or the system package manager. When a formatter binary is absent, `<leader>al` falls back to LSP formatting (`lsp_fallback = true`).

See `README.md` for the per-OS install commands.
