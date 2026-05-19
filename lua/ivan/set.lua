
-- Relative line numbers (0 on the cursor line, distance elsewhere) so
-- `9k` / `12j` style jumps are easy.
vim.opt.nu = false
vim.opt.relativenumber = true

-- A <Tab> character is visually 4 spaces wide
vim.opt.tabstop = 4
-- Backspace over an "indent" treats it as 4 spaces
vim.opt.softtabstop = 4
-- `>>` and auto-indent shift by 4 spaces
vim.opt.shiftwidth = 4
-- Pressing <Tab> in insert mode inserts spaces, not a literal tab character
vim.opt.expandtab = true

-- New lines inherit the previous line's indent. Pairs with filetype-indent
-- scripts (built into nvim's runtime) and treesitter `indent.enable` in
-- lua/plugins/treesitter.lua, which provide language-aware indent on top.
-- Intentionally NOT setting smartindent: it's a legacy C-heuristic that
-- conflicts with `indentexpr` and was the cause of C++ snapping to col 0.
vim.opt.autoindent = true

-- Don't wrap long lines visually — they scroll horizontally instead
vim.opt.wrap = false

-- Disable .swp files (they clutter and we don't need crash recovery)
vim.opt.swapfile = false
-- Disable backup files (~ files left next to originals)
vim.opt.backup = false
-- Store persistent undo history in ~/.vim/undodir so undo survives closing the file
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- Actually enable that persistent undo history (powers undotree across sessions)
vim.opt.undofile = true

-- Don't keep search matches highlighted after the search ends
vim.opt.hlsearch = false
-- But DO highlight matches incrementally as you type the search
vim.opt.incsearch = true

-- Enable 24-bit RGB colors in the terminal (needed for modern colorschemes)
vim.opt.termguicolors = true

-- Always keep 8 lines of context visible above/below the cursor when scrolling
vim.opt.scrolloff = 8
-- Always show the sign column (LSP diagnostics, git signs) so text doesn't jump when signs appear
vim.opt.signcolumn = "yes"
-- Treat `@-@` as part of a filename (lets `gf` work on emails / scoped names)
vim.opt.isfname:append("@-@")

-- How long (ms) before swap/cursorhold events fire — lower = snappier LSP diagnostics
vim.opt.updatetime = 50

-- Global leader key binding 
vim.g.mapleader = " "

-- Map Local Leader for Future Plugins
vim.g.maplocalleader = "\\"
