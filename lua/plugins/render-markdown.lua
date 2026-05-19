return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  -- Only spin up on markdown buffers. Needs the `markdown` and
  -- `markdown_inline` parsers; both are already in `treesitter.lua`.
  ft = { "markdown" },
  config = function()
    require("render-markdown").setup({})
  end,
}
