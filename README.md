# Ivan-NeoVim

A personal Neovim configuration built from scratch following [ThePrimeagen's "Neovim from scratch"](https://www.youtube.com/watch?v=w7i4amO_zaE) tutorial, modernized with current plugin versions and best practices.

Built on `lazy.nvim` with inline plugin specs, native LSP via `nvim-lspconfig` + Mason, `nvim-cmp` completion, and treesitter-powered syntax highlighting.

---

## What's included

| Plugin | Purpose |
| --- | --- |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | Colorscheme (Storm, transparent) |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy file finder & live grep |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting & code parsing |
| [harpoon (v2)](https://github.com/ThePrimeagen/harpoon/tree/harpoon2) | Pin & jump between files |
| [undotree](https://github.com/mbbill/undotree) | Visual undo history |
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | Git integration |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason](https://github.com/williamboman/mason.nvim) | Language server management |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) + [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Completion & snippets |

**Language servers auto-installed:** `lua_ls`, `ts_ls`, `rust_analyzer`, `pyright`, `clangd`, `gopls`, `html`, `cssls`, `jsonls`, `yamlls`, `bashls`.

---

## Requirements

| Tool | Why | Minimum |
| --- | --- | --- |
| Neovim | The editor | **0.10+** (0.11 recommended for built-in LSP keymaps) |
| git | Plugin cloning | any recent |
| C compiler | Treesitter parsers (compiled at install) | any |
| ripgrep (`rg`) | Telescope live grep | any |
| Node.js | Required by some LSPs (`ts_ls`, `pyright`, etc.) | 18+ |
| A Nerd Font | Optional, for icons in your terminal | any |

---

## Installation

### macOS

```bash
# Prerequisites
brew install neovim git ripgrep node
xcode-select --install   # C compiler

# Back up any existing config first
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.backup 2>/dev/null

# Clone
git clone https://github.com/Ivan-Shishkin-Dev/Ivan-NeoVim.git ~/.config/nvim

# Launch
nvim
```

### Linux (Debian / Ubuntu)

```bash
# Prerequisites
sudo apt update
sudo apt install neovim git ripgrep nodejs build-essential

# Back up any existing config first
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.backup 2>/dev/null

# Clone
git clone https://github.com/Ivan-Shishkin-Dev/Ivan-NeoVim.git ~/.config/nvim

# Launch
nvim
```

> If your distro ships an old Neovim (< 0.10), install from the [official releases](https://github.com/neovim/neovim/releases) or use the unstable PPA: `sudo add-apt-repository ppa:neovim-ppa/unstable`.

### Linux (Arch / Manjaro)

```bash
sudo pacman -S neovim git ripgrep nodejs base-devel
# Then clone and launch as above
```

### Linux (Fedora)

```bash
sudo dnf install neovim git ripgrep nodejs gcc
# Then clone and launch as above
```

---

## Windows 11

Two equivalent paths: **winget** (built into Windows) or **scoop** (preferred if you like Unix-style tooling). Pick one.

### Option A — winget (no extra setup)

Open **PowerShell** (not CMD):

```powershell
# Prerequisites
winget install Neovim.Neovim
winget install Git.Git
winget install BurntSushi.ripgrep.MSVC
winget install OpenJS.NodeJS
winget install Microsoft.VisualStudio.2022.BuildTools    # C compiler for treesitter
# During Build Tools install, select "Desktop development with C++"
```

Restart PowerShell so `PATH` picks up the new tools.

```powershell
# Back up any existing config
Move-Item $env:LOCALAPPDATA\nvim       $env:LOCALAPPDATA\nvim.backup       -ErrorAction SilentlyContinue
Move-Item $env:LOCALAPPDATA\nvim-data  $env:LOCALAPPDATA\nvim-data.backup  -ErrorAction SilentlyContinue

# Clone into Neovim's Windows config location
git clone https://github.com/Ivan-Shishkin-Dev/Ivan-NeoVim.git $env:LOCALAPPDATA\nvim

# Launch
nvim
```

### Option B — scoop

```powershell
# Install scoop itself (one-time)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# Prerequisites
scoop install neovim git ripgrep nodejs gcc

# Clone
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.backup -ErrorAction SilentlyContinue
git clone https://github.com/Ivan-Shishkin-Dev/Ivan-NeoVim.git $env:LOCALAPPDATA\nvim

# Launch
nvim
```

### Windows notes

- **Config path is different on Windows.** Neovim reads from `%LOCALAPPDATA%\nvim\` (typically `C:\Users\<You>\AppData\Local\nvim\`), NOT `~\.config\nvim\`.
- **Use a real terminal.** The default Windows console is rough. Install [Windows Terminal](https://aka.ms/terminal) from the Microsoft Store and use PowerShell 7 inside it.
- **Transparent background:** requires a terminal that supports transparency (Windows Terminal does — Settings → Profiles → Appearance → Background opacity).
- **Treesitter needs a C compiler.** The MSVC Build Tools install in Option A is the standard choice. Alternative: install [zig](https://ziglang.org/) and set `CC=zig cc`.
- **If `nvim` isn't found after install,** close and reopen your terminal — `PATH` updates require a fresh shell.

---

## First launch

The first time you run `nvim`, three things happen automatically:

1. **Lazy.nvim bootstraps itself** — clones into `<data>/lazy/lazy.nvim`.
2. **Lazy installs all plugins** — a progress UI shows what's downloading. Takes ~30 seconds.
3. **Treesitter compiles parsers** — for the languages in `ensure_installed`. Takes another 30-60s.
4. **Mason installs language servers** — happens in the background after launch. Watch progress with `:Mason`.

When the dust settles, check everything with:

```vim
:Lazy        " plugin status
:Mason       " LSP server status
:checkhealth " general diagnostic
```

---

## Keybindings

Leader key is **`<Space>`**.

### Editor

| Keys | Action |
| --- | --- |
| `<leader>pv` | Open file explorer (netrw) |

### Telescope

| Keys | Action |
| --- | --- |
| `<leader>pf` | Fuzzy find files |
| `<C-p>` | Fuzzy find git-tracked files |
| `<leader>ps` | Grep prompt across project |

### Harpoon

| Keys | Action |
| --- | --- |
| `<leader>a` | Add current file to harpoon list |
| `<C-e>` | Toggle harpoon menu |
| `<C-h>` `<C-t>` `<C-n>` `<C-s>` | Jump to harpoon file 1, 2, 3, 4 |

### Git (fugitive)

| Keys | Action |
| --- | --- |
| `<leader>gs` | Open git status |

### Undo history

| Keys | Action |
| --- | --- |
| `<leader>u` | Toggle undotree |

### LSP (Neovim 0.11+ built-ins)

| Keys | Action |
| --- | --- |
| `K` | Hover docs |
| `grn` | Rename symbol |
| `gra` | Code action |
| `grr` | Find references |
| `gri` | Go to implementation |
| `gO` | Document symbols |
| `[d` / `]d` | Prev / next diagnostic |
| `<C-]>` | Go to definition |
| `<C-S>` (insert mode) | Signature help |

### Completion (cmp defaults)

| Keys | Action |
| --- | --- |
| `<C-n>` / `<C-p>` | Next / previous suggestion |
| `<C-y>` | Confirm selection |
| `<C-Space>` | Manually trigger completion |
| `<C-e>` | Cancel menu |

---

## Project structure

```
~/.config/nvim/              (Windows: %LOCALAPPDATA%\nvim\)
├── init.lua                 Entry point
├── lazy-lock.json           Plugin version lockfile (committed for reproducibility)
└── lua/
    ├── config/
    │   └── lazy.lua         Lazy.nvim bootstrap
    ├── ivan/
    │   ├── init.lua         Loads set + remap
    │   ├── set.lua          Editor options (line numbers, tabs, etc.) + leader keys
    │   └── remap.lua        Personal keymaps
    └── plugins/
        ├── tokyonight.lua   Colorscheme
        ├── telescope.lua    Fuzzy finder
        ├── treesitter.lua   Syntax highlighting
        ├── harpoon.lua      File pinning
        ├── undotree.lua     Undo history
        ├── fugitive.lua     Git
        └── lsp.lua          LSP + completion
```

Each plugin lives in its own file under `lua/plugins/` — lazy.nvim auto-discovers them.

---

## Customizing

- **Add a plugin:** create `lua/plugins/<name>.lua` returning a lazy spec table. Restart nvim, lazy will install it.
- **Change colorscheme:** edit `lua/plugins/tokyonight.lua` (change the `style` field) or replace the file with a different colorscheme plugin.
- **Add a language server:** add its name to the `ensure_installed` and `servers` lists in `lua/plugins/lsp.lua`. Available names: see [mason-lspconfig docs](https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md).
- **Add a keymap:** drop a `vim.keymap.set(...)` call into `lua/ivan/remap.lua`.

---

## Credits

- [ThePrimeagen](https://github.com/ThePrimeagen) — the original tutorial and `harpoon`
- [folke](https://github.com/folke) — `lazy.nvim`, `tokyonight.nvim`
- [tjdevries](https://github.com/tjdevries), [nvim-telescope](https://github.com/nvim-telescope) — `telescope.nvim`, `plenary.nvim`
- Everyone in the Neovim ecosystem
