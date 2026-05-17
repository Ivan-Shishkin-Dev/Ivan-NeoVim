return {
  "tpope/vim-fugitive",
  config = function()
    -- <leader>gs opens git status (`:Git`) in the current window
    vim.keymap.set("n", "<leader>gs", vim.cmd.Git,
      { desc = "Git status (fugitive)" })
  end,
}
