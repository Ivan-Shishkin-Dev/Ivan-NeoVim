return {
  "lukas-reineke/indent-blankline.nvim",
  -- v3+ exposes its module as "ibl", not "indent_blankline"
  main = "ibl",
  config = function()
    require("ibl").setup({})
  end,
}
