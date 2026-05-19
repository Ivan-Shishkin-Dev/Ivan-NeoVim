# Ivan-NeoVim

A personal Neovim configuration following [ThePrimeagen's "Neovim from scratch"](https://www.youtube.com/watch?v=w7i4amO_zaE), modernized for current plugin APIs. Built on `lazy.nvim`, native LSP via `vim.lsp.config` / `vim.lsp.enable` (nvim 0.11+), `nvim-cmp` completion, treesitter highlighting, and `conform.nvim` formatting.

---

## What's included

| Plugin | Purpose |
| --- | --- |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | Colorscheme (Storm, transparent) |
| [mini.statusline](https://github.com/nvim-mini/mini.statusline) | Statusline |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Buffer tabs along the top |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | Sidebar file explorer |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder & live grep |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Parser installer + queries (highlighting via `vim.treesitter.start()`) |
| [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) | Sticky header showing the enclosing function / class |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | In-buffer markdown rendering |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Vertical indent guides |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlights & indexes `TODO` / `FIXME` / `HACK` / `NOTE` |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Popup menu of `<leader>` bindings |
| [undotree](https://github.com/mbbill/undotree) | Visual undo history |
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | Git (whole-file / repo ops) |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Per-line git status in the sign column |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-close brackets / quotes (treesitter-aware, cmp-integrated) |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Format on `<leader>al` |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason](https://github.com/williamboman/mason.nvim) | Language server management |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) + [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Completion & snippets |

**Auto-installed LSPs:** `lua_ls`, `ts_ls`, `rust_analyzer`, `pyright`, `clangd`, `html`, `cssls`, `jsonls`, `yamlls`, `bashls`.

**Formatters (install separately):** `stylua`, `black`, `prettier`, `clang-format`, `rustfmt`, `csharpier`, `shfmt`.

---

## Requirements

| Tool | Why | Minimum |
| --- | --- | --- |
| Neovim | The editor | **0.11+** (tested on 0.12) |
| git | Plugin cloning | any recent |
| C compiler | Treesitter parsers compile at install | any |
| ripgrep | Telescope live grep | any |
| Node.js | Several LSPs need it (`ts_ls`, `pyright`, …) | 18+ |
| Clipboard provider (Linux only) | `unnamedplus` yank → system clipboard. `xclip` / `xsel` / `wl-clipboard` | any |
| A Nerd Font | bufferline / neo-tree icons | any |

Formatter binaries are optional — install only the ones for filetypes you actually format with `<leader>al`. Via Mason: `:MasonInstall stylua black prettier shfmt clang-format`.

---

## Installation

Back up any existing config first:

```bash
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.backup 2>/dev/null
```

Then install prerequisites and clone:

### macOS

```bash
brew install neovim git ripgrep node
xcode-select --install   # C compiler
git clone https://github.com/Ivan-Shishkin-Dev/Ivan-NeoVim.git ~/.config/nvim
nvim
```

### Linux

| Distro | Prereq command |
| --- | --- |
| Debian / Ubuntu | `sudo apt install neovim git ripgrep nodejs build-essential xclip` |
| Arch / Manjaro | `sudo pacman -S neovim git ripgrep nodejs base-devel xclip` |
| Fedora | `sudo dnf install neovim git ripgrep nodejs gcc xclip` |

Then `git clone … ~/.config/nvim && nvim`. If your distro ships Neovim < 0.11, use the [official releases](https://github.com/neovim/neovim/releases) or the unstable PPA.

### Windows 11

PowerShell + [Windows Terminal](https://aka.ms/terminal):

```powershell
winget install Neovim.Neovim Git.Git BurntSushi.ripgrep.MSVC OpenJS.NodeJS
winget install Microsoft.VisualStudio.2022.BuildTools   # tick "Desktop development with C++"

Move-Item $env:LOCALAPPDATA\nvim       $env:LOCALAPPDATA\nvim.backup       -ErrorAction SilentlyContinue
Move-Item $env:LOCALAPPDATA\nvim-data  $env:LOCALAPPDATA\nvim-data.backup  -ErrorAction SilentlyContinue
git clone https://github.com/Ivan-Shishkin-Dev/Ivan-NeoVim.git $env:LOCALAPPDATA\nvim
nvim
```

Windows config lives at `%LOCALAPPDATA%\nvim\`, not `~\.config\nvim\`. Transparency needs a terminal that supports it (Windows Terminal does).

---

## First launch

Lazy bootstraps and installs plugins (~30s); treesitter compiles parsers (~30–60s); Mason installs LSPs in the background. Verify with `:Lazy`, `:Mason`, `:checkhealth`.

---

## Keybindings

Leader is **`<Space>`** — press it and pause to see every `<leader>` binding via which-key. Yank (`y`, `d`, `x`, …) goes to the system clipboard automatically (`unnamedplus`).

### Editor / file navigation

| Keys | Action |
| --- | --- |
| `<leader>pv` | netrw file explorer (current window) |
| `<leader>e` | Toggle neo-tree sidebar |
| `<leader>pf` | Telescope: find files |
| `<C-p>` | Telescope: find git-tracked files |
| `<leader>ps` | Telescope: grep across project |
| `<leader>u` | Toggle undotree |
| `<leader>gs` | `:Git` status (fugitive) |

Inside neo-tree: `<CR>` open, `a`/`d`/`r` add/delete/rename, `H` toggle hidden, `q` close, `?` for the full list.

### Buffers (bufferline)

Each tab shows an ordinal (1, 2, 3, …). `<leader>1` … `<leader>9` jump directly to position N. Standard `:bnext` / `:bprev` / `:bd` also work.

### Format (`<leader>al`)

Formats the current buffer, preserves cursor position. Falls back to the attached LSP if no dedicated formatter exists.

| Filetype | Formatter |
| --- | --- |
| `lua` | `stylua` |
| `python` | `black` |
| `javascript` / `typescript` / `json` / `html` / `css` / `markdown` / `yaml` | `prettier` |
| `c` / `cpp` | `clang-format` |
| `rust` | `rustfmt` |
| `cs` | `csharpier` |
| `sh` / `bash` | `shfmt` |

All formatters are pinned to 4-space indent via `prepend_args` in `lua/plugins/conform.lua` to match `tabstop` / `shiftwidth`. clang-format additionally sets `IndentAccessModifiers: true` so `public:` / `private:` indent under the class body. `:ConformInfo` shows what would actually run for the current buffer.

### Passive features (no keymap needed)

- **gitsigns** — `+` / `~` / `-` in the sign column for changes vs HEAD; `:Gitsigns toggle_current_line_blame` for inline blame.
- **render-markdown** — `.md` buffers auto-render; move the cursor onto a line to lift concealment.
- **treesitter-context** — sticky header shows the enclosing scope as you scroll; `:TSContextToggle` to hide.
- **todo-comments** — `TODO` / `FIXME` / `HACK` / `WARN` / `PERF` / `NOTE` / `TEST` are highlighted; `:TodoTelescope` to fuzzy-find them.

### LSP (Neovim 0.11+ built-ins, no overrides)

| Keys | Action |
| --- | --- |
| `K` | Hover docs |
| `grn` / `gra` | Rename / code action |
| `grr` / `gri` | References / implementation |
| `gO` | Document symbols |
| `[d` / `]d` | Prev / next diagnostic |
| `<C-]>` | Go to definition |
| `<C-S>` (insert) | Signature help |

### Completion (cmp defaults)

`<C-n>` / `<C-p>` next/prev, `<C-y>` confirm, `<C-Space>` trigger, `<C-e>` cancel.

---

## Project structure

```
~/.config/nvim/                  (Windows: %LOCALAPPDATA%\nvim\)
├── init.lua                     Entry point
├── lazy-lock.json               Plugin version lockfile (committed)
└── lua/
    ├── config/lazy.lua          lazy.nvim bootstrap
    ├── ivan/
    │   ├── init.lua             Loads set + remap
    │   ├── set.lua              Editor options + leader keys
    │   └── remap.lua            Personal keymaps
    └── plugins/                 Auto-discovered by lazy
        ├── tokyonight.lua       Colorscheme
        ├── mini-statusline.lua  Statusline
        ├── bufferline.lua       Top buffer tabs
        ├── neo-tree.lua         Sidebar file explorer
        ├── telescope.lua        Fuzzy finder
        ├── treesitter.lua       Treesitter parsers
        ├── treesitter-context.lua  Sticky scope header
        ├── render-markdown.lua  In-buffer markdown rendering
        ├── indent-blankline.lua Vertical indent guides
        ├── todo-comments.lua    TODO / FIXME highlights
        ├── which-key.lua        <leader> popup
        ├── undotree.lua         Undo history
        ├── fugitive.lua         Git (whole-file / repo)
        ├── gitsigns.lua         Git sign-column status
        ├── autopairs.lua        Auto-close brackets
        ├── conform.lua          Formatters
        └── lsp.lua              Mason + lspconfig + cmp + LuaSnip
```

Each plugin = one file under `lua/plugins/`. Lazy auto-discovers them.

---

## Customizing

- **Add a plugin:** drop `lua/plugins/<name>.lua` returning a lazy spec. Restart nvim.
- **Add a language server:** add it to **both** `ensure_installed` and `vim.lsp.enable({...})` in `lua/plugins/lsp.lua` ([server names](https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md)).
- **Add a formatter:** add to `formatters_by_ft` in `lua/plugins/conform.lua`, then install the binary.
- **Add a keymap / option:** edit `lua/ivan/remap.lua` or `lua/ivan/set.lua`.
- **Change colorscheme:** edit `style` in `lua/plugins/tokyonight.lua`, or replace the file.

---

## Credits

- [ThePrimeagen](https://github.com/ThePrimeagen) — original tutorial
- [folke](https://github.com/folke) — `lazy.nvim`, `tokyonight`, `which-key`, `todo-comments`
- [echasnovski / nvim-mini](https://github.com/nvim-mini) — `mini.statusline`
- [stevearc](https://github.com/stevearc) — `conform.nvim`
- Everyone in the Neovim ecosystem
