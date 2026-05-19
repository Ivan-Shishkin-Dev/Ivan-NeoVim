return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("bufferline").setup({
      options = {
        -- Show 1, 2, 3, ... next to each tab so the <leader>N keymaps below
        -- have a visible target. Set to "none" if the numbers feel noisy.
        numbers = "ordinal",
      },
    })

    -- <leader>1 .. <leader>9 jumps to the buffer in the corresponding
    -- position in the bufferline. Position is absolute (visual slot),
    -- not buffer id.
    for i = 1, 9 do
      vim.keymap.set("n", "<leader>" .. i, function()
        require("bufferline").go_to(i, true)
      end, { desc = "Buffer position " .. i })
    end
  end,
}
