return {
  "nvim-treesitter/nvim-treesitter",
  -- Pin to master. nvim-treesitter is mid-transition to a `main` branch with a
  -- different API. Explicitly pinning master prevents a future surprise break.
  branch = "master",
  -- Re-runs `:TSUpdate` after install/update so parser binaries stay current.
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Parsers downloaded automatically on first launch.
      ensure_installed = {
        "vimdoc",
        "lua",
        "bash",
        "javascript",
        "typescript",
        "tsx",
        "jsdoc",
        "html",
        "css",
        "json",
        "c",
        "cpp",
        "rust",
        "python",
        "markdown",
        "markdown_inline",
      },
      -- false = don't block startup waiting for parser downloads
      sync_install = false,
      -- Auto-install a parser when you open a filetype that doesn't have one yet
      auto_install = true,
      -- The reason we're here: syntax-tree-based highlighting
      highlight = { enable = true },
      -- Treesitter-aware `=` indenting (still experimental but works for most langs)
      indent = { enable = true },
    })
  end,
}
