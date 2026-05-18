-- Right-aligned absolute line numbers via virtual text.
-- Pairs with 'relativenumber' in set.lua: the left gutter shows distance
-- from the cursor and the right edge of the window shows the real line
-- number. Implemented as a decoration provider so only visible lines are
-- rendered (cheap on large files); extmarks are ephemeral and discarded
-- between redraws.

local ns = vim.api.nvim_create_namespace("ivan_right_numbers")

vim.api.nvim_set_decoration_provider(ns, {
  on_win = function(_, winid, bufnr)
    if vim.bo[bufnr].buftype ~= "" then return false end
    if not (vim.wo[winid].number or vim.wo[winid].relativenumber) then
      return false
    end
    return true
  end,
  on_line = function(_, _, bufnr, row)
    vim.api.nvim_buf_set_extmark(bufnr, ns, row, 0, {
      virt_text = { { tostring(row + 1), "LineNr" } },
      virt_text_pos = "right_align",
      ephemeral = true,
      hl_mode = "combine",
    })
  end,
})
