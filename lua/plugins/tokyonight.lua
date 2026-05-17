return {
  "folke/tokyonight.nvim",
  -- Colorschemes shouldn't be lazy-loaded — we want them active immediately
  lazy = false,
  -- High priority so it loads before any other plugin that might check highlights
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "storm",          -- "storm" | "night" | "moon" | "day"
      transparent = true,       -- let terminal bg show through
      styles = {
        sidebars = "transparent",
        floats   = "transparent",
      },
    })
    -- Actually apply the colorscheme
    vim.cmd.colorscheme("tokyonight")
  end,
}
