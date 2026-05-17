return {
  "mbbill/undotree",
  config = function()
    -- <leader>u toggles the undo-history tree pane
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle,
      { desc = "Toggle undotree" })
  end,
}
