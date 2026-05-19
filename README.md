# Ivan-NeoVim

A personal Neovim configuration built from scratch following [ThePrimeagen's "Neovim from scratch"](https://www.youtube.com/watch?v=w7i4amO_zaE) tutorial, modernized for current plugin APIs. Built on `lazy.nvim` with native LSP via nvim 0.11+'s `vim.lsp.config` / `vim.lsp.enable`, `nvim-cmp` completion, treesitter-powered highlighting, and `conform.nvim` formatting.

---

## What's included

| Plugin | Purpose |
| --- | --- |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | Colorscheme (Storm, transparent) |
| [mini.statusline](https://github.com/nvim-mini/mini.statusline) | Statusline (mode + git + diagnostics + position) |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Buffer tabs along the top |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | Sidebar file explorer |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder & live grep |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting & code parsing |
| [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) | Sticky scope header at top of window |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Vertical indent guides |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlights & searches `TODO` / `FIXME` / `HACK` / `NOTE` |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Popup menu of bindings after `<leader>` |
| [undotree](https://github.com/mbbill/undotree) | Visual undo history |
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | Git integration |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-close brackets / quotes (treesitter-aware, cmp-integrated) |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Format-on-keystroke (Prettier / stylua / black / etc.) |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason](https://github.com/williamboman/mason.nvim) | Language server management |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) + [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Completion & snippets |

**Auto-installed language servers:** `lua_ls`, `ts_ls`, `rust_analyzer`, `pyright`, `clangd`, `html`, `cssls`, `jsonls`, `yamlls`, `bashls`.

**Formatters (install separately, see below):** `stylua`, `black`, `prettier`, `clang-format`, `rustfmt`, `csharpier`, `shfmt`.

---

## Requirements

| Tool | Why | Minimum |
| --- | --- | --- |
| Neovim | The editor | **0.11+** (uses `vim.lsp.config` / `vim.lsp.enable`; tested on 0.12) |
| git | Plugin cloning | any recent |
| C compiler | Treesitter parsers compile at install | any |
| ripgrep (`rg`) | Telescope live grep | any |
| Node.js | Required by some LSPs (`ts_ls`, `pyright`, etc.) | 18+ |
| Clipboard provider (Linux only) | For `unnamedplus` yank → system clipboard. One of: `xclip`, `xsel`, `wl-clipboard` | any |
| A Nerd Font | For bufferline / neo-tree icons | any |

Formatter binaries are optional and only needed for filetypes you actually format with `<leader>al`. Install via Mason (`:MasonInstall stylua black prettier shfmt clang-format`) or your package manager.

---

## Installation

### macOS

```bash
brew install neovim git ripgrep node
xcode-select --install   # C compiler

# Back up any existing config first
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.backup 2>/dev/null

git clone https://github.com/Ivan-Shishkin-Dev/Ivan-NeoVim.git ~/.config/nvim
nvim
```

### Linux

Install the prerequisites with your distro's package manager, then clone the same way as macOS:

| Distro | Prereq command |
| --- | --- |
| Debian / Ubuntu | `sudo apt install neovim git ripgrep nodejs build-essential xclip` |
| Arch / Manjaro | `sudo pacman -S neovim git ripgrep nodejs base-devel xclip` |
| Fedora | `sudo dnf install neovim git ripgrep nodejs gcc xclip` |

```bash
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.backup 2>/dev/null
git clone https://github.com/Ivan-Shishkin-Dev/Ivan-NeoVim.git ~/.config/nvim
nvim
```

> If your distro ships Neovim < 0.11, install from the [official releases](https://github.com/neovim/neovim/releases) or use the unstable PPA: `sudo add-apt-repository ppa:neovim-ppa/unstable`.

### Windows 11

Use PowerShell (not CMD) with [Windows Terminal](https://aka.ms/terminal):

```powershell
winget install Neovim.Neovim Git.Git BurntSushi.ripgrep.MSVC OpenJS.NodeJS
winget install Microsoft.VisualStudio.2022.BuildTools   # C compiler; tick "Desktop development with C++"

# Restart PowerShell so PATH picks up the new tools, then:
Move-Item $env:LOCALAPPDATA\nvim       $env:LOCALAPPDATA\nvim.backup       -ErrorAction SilentlyContinue
Move-Item $env:LOCALAPPDATA\nvim-data  $env:LOCALAPPDATA\nvim-data.backup  -ErrorAction SilentlyContinue
git clone https://github.com/Ivan-Shishkin-Dev/Ivan-NeoVim.git $env:LOCALAPPDATA\nvim
nvim
```

Notes:
- Windows config lives at `%LOCALAPPDATA%\nvim\`, not `~\.config\nvim\`.
- Transparent background needs a terminal that supports it (Windows Terminal does — Settings → Profiles → Appearance → Background opacity).
- If `nvim` isn't found after install, open a fresh shell — PATH updates require it.

---

## First launch

On first run, lazy bootstraps itself, installs every plugin (~30s), and treesitter compiles parsers (~30–60s). Mason installs the LSP servers in the background after the UI is up. Verify with:

```vim
:Lazy         " plugin install / update status
:Mason        " LSP server install status
:checkhealth  " general diagnostic
```

---

## Keybindings

Leader key is **`<Space>`**. Press `<Space>` and pause briefly to see every `<leader>`-prefixed binding via which-key.

> **Clipboard:** yank (`y`, `yy`, `Y`, `d`, `x`, etc.) writes directly to the system clipboard — paste with Cmd-V / Ctrl-V outside nvim, no `"+y` prefix needed. Set via `vim.opt.clipboard = "unnamedplus"` in `lua/ivan/set.lua`. On Linux, install a clipboard provider (see Requirements).

### Editor / file navigation

| Keys | Action |
| --- | --- |
| `<leader>pv` | Open netrw file explorer (in current window) |
| `<leader>e` | Toggle neo-tree sidebar file explorer |
| `<leader>pf` | Telescope: fuzzy find files |
| `<C-p>` | Telescope: fuzzy find git-tracked files |
| `<leader>ps` | Telescope: grep prompt across project |
| `<leader>u` | Toggle undotree |
| `<leader>gs` | Open git status (fugitive) |

### Buffers (bufferline)

Bufferline ships no default keymaps — use the built-in buffer commands. Click a buffer name with the mouse to jump; middle-click to close.

| Keys / command | Action |
| --- | --- |
| `:bnext` / `:bprev` | Cycle to next / previous buffer |
| `:bd` | Close current buffer |
| `<C-^>` | Toggle to alternate buffer |

### File tree (neo-tree, inside the tree)

| Keys | Action |
| --- | --- |
| `<CR>` | Open file / expand directory |
| `a` / `d` / `r` | Add / delete / rename |
| `c` / `m` | Copy / move |
| `H` | Toggle hidden files |
| `q` | Close the tree |
| `?` | Show all neo-tree keybindings |

### Format (conform.nvim)

| Keys | Action |
| --- | --- |
| `<leader>al` | Format the whole buffer using the language's formatter. Preserves cursor position. |

Formatters by filetype:

| Filetype | Formatter | Install |
| --- | --- | --- |
| `lua` | `stylua` | `:MasonInstall stylua` |
| `python` | `black` | `:MasonInstall black` or `brew install black` |
| `javascript` / `typescript` / `json` / `html` / `css` / `markdown` / `yaml` | `prettier` | `:MasonInstall prettier` or `brew install prettier` |
| `c` / `cpp` | `clang-format` | `:MasonInstall clang-format` or `brew install clang-format` |
| `rust` | `rustfmt` | ships with `rustup` |
| `cs` | `csharpier` | `dotnet tool install -g csharpier` |
| `sh` / `bash` | `shfmt` | `:MasonInstall shfmt` |

Anything not listed above falls back to the attached LSP's formatting capability (`lsp_fallback = true`). Run `:ConformInfo` in any buffer to see what would actually run.

**Indent width:** every formatter is forced to 4-space indent to match `tabstop` / `shiftwidth` in `lua/ivan/set.lua`. clang-format, prettier, stylua, and shfmt have their defaults overridden via `prepend_args` in `lua/plugins/conform.lua`; black, rustfmt, and csharpier already default to 4. clang-format also sets `IndentAccessModifiers: true` so `public:` / `private:` indent under the class body.

### TODO / FIXME comments (todo-comments)

Keywords `TODO`, `FIXME`, `HACK`, `WARN`, `PERF`, `NOTE`, `TEST` are highlighted and indexed automatically.

| Command | Action |
| --- | --- |
| `:TodoTelescope` | Fuzzy-find every todo comment in the project |
| `:TodoQuickFix` | Send todo comments to the quickfix list |
| `:TodoLocList` | Send todo comments to the location list |

### LSP (Neovim 0.11+ built-ins, no overrides)

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
| `<C-S>` (insert) | Signature help |

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
~/.config/nvim/                  (Windows: %LOCALAPPDATA%\nvim\)
├── init.lua                     Entry point
├── lazy-lock.json               Plugin version lockfile (committed for reproducibility)
└── lua/
    ├── config/
    │   └── lazy.lua             lazy.nvim bootstrap
    ├── ivan/
    │   ├── init.lua             Loads set + remap
    │   ├── set.lua              Editor options + leader keys
    │   └── remap.lua            Personal keymaps
    └── plugins/                 Auto-discovered by lazy
        ├── tokyonight.lua       Colorscheme
        ├── mini-statusline.lua  Statusline
        ├── bufferline.lua       Top buffer-tab strip
        ├── neo-tree.lua         Sidebar file explorer
        ├── telescope.lua        Fuzzy finder
        ├── treesitter.lua       Syntax highlighting
        ├── treesitter-context.lua  Sticky scope header
        ├── indent-blankline.lua    Vertical indent guides
        ├── todo-comments.lua    TODO / FIXME highlights
        ├── which-key.lua        Popup menu of <leader> bindings
        ├── undotree.lua         Undo history viewer
        ├── fugitive.lua         Git integration
        ├── autopairs.lua        Auto-close brackets / quotes
        ├── conform.lua          Formatters (<leader>al)
        └── lsp.lua              Mason + lspconfig + nvim-cmp + LuaSnip
```

Each plugin lives in its own file under `lua/plugins/` — lazy.nvim auto-discovers them.

---

## Customizing

- **Add a plugin:** create `lua/plugins/<name>.lua` returning a lazy spec table. Restart nvim, lazy installs it.
- **Change colorscheme:** edit the `style` field in `lua/plugins/tokyonight.lua`, or replace the file with a different colorscheme plugin.
- **Add a language server:** add its name to **both** `ensure_installed` and `vim.lsp.enable({...})` in `lua/plugins/lsp.lua`. Server names: see [mason-lspconfig docs](https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md).
- **Add a formatter:** add an entry to `formatters_by_ft` in `lua/plugins/conform.lua`, then install the binary (Mason or your package manager).
- **Add a keymap:** drop a `vim.keymap.set(...)` call into `lua/ivan/remap.lua` (personal) or into the plugin's `config = function()` block (plugin-specific).
- **Add an editor option:** append `vim.opt.X = value` to `lua/ivan/set.lua`.

---

## Credits

- [ThePrimeagen](https://github.com/ThePrimeagen) — the original tutorial
- [folke](https://github.com/folke) — `lazy.nvim`, `tokyonight.nvim`, `which-key.nvim`, `todo-comments.nvim`
- [echasnovski / nvim-mini](https://github.com/nvim-mini) — `mini.statusline`
- [stevearc](https://github.com/stevearc) — `conform.nvim`
- Everyone in the Neovim ecosystem
