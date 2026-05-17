return {
  "ThePrimeagen/harpoon",
  -- v2 has a completely different API from the version in Prime's old video
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    -- Add the current file to your harpoon list
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end,
      { desc = "Harpoon add file" })

    -- Toggle the floating menu showing your harpoon list
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = "Harpoon menu" })

    -- Jump to harpoon files 1-4 (matches Prime's bindings)
    vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
    vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
    vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
    vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })
  end,
}
