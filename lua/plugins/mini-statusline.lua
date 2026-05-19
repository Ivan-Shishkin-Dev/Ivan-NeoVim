return {
  "nvim-mini/mini.statusline",
  event = "VeryLazy",
  config = function()
    require("mini.statusline").setup({})
  end,
}
