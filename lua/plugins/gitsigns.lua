return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- Stock setup. The sign column will show +/~/- next to changed lines.
    -- gitsigns deliberately does not bind keymaps by default; add an
    -- on_attach block below if/when hunk navigation or blame toggles are
    -- wanted.
    require("gitsigns").setup()
  end,
}
