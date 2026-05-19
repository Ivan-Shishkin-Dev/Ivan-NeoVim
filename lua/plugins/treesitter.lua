return {
  "nvim-treesitter/nvim-treesitter",
  -- `main` is the modern rewrite. `master` is the legacy modules API
  -- (`require("nvim-treesitter.configs").setup{ highlight = ... }`); on `main`,
  -- nvim core does highlighting via `vim.treesitter.start()` and this plugin
  -- is reduced to installing parsers and shipping query files.
  branch = "main",
  -- main does NOT support lazy-loading (per its README). Make eager-loading explicit.
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local parsers = {
      "vimdoc", "lua", "bash",
      "javascript", "typescript", "tsx", "jsdoc",
      "html", "css", "json",
      "c", "cpp", "rust", "python",
      "markdown", "markdown_inline",
    }

    -- Idempotent — skips parsers already on disk.
    require("nvim-treesitter").install(parsers)

    -- Highlighting: nvim core does the work; the autocmd just starts it per buffer
    -- when a filetype with a known parser opens.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = parsers,
      callback = function() vim.treesitter.start() end,
    })

    -- Experimental treesitter-aware indent — preserves what `indent.enable` did
    -- on master. Remove a language from `parsers` to opt that filetype out and
    -- fall back to nvim's built-in indent script.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = parsers,
      callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
