return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local autopairs = require("nvim-autopairs")
    autopairs.setup({
      -- Consult treesitter before auto-closing, so we don't close brackets
      -- inside strings/comments where it would just be noise.
      check_ts = true,
    })

    -- When you accept a function from the nvim-cmp menu, automatically
    -- append `()` and drop the cursor between the parens.
    local ok, cmp = pcall(require, "cmp")
    if ok then
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
  end,
}
