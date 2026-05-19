return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>al",
      function()
        require("conform").format({
          async = false,
          lsp_fallback = true,
          timeout_ms = 3000,
        })
      end,
      mode = { "n", "v" },
      desc = "Format buffer (Prettier-style)",
    },
  },
  config = function()
    require("conform").setup({
      -- One formatter per language. conform applies the formatter as a
      -- diff against the buffer, so cursor position and window view are
      -- preserved automatically. `lsp_fallback = true` (set in the keymap)
      -- means a language without a formatter listed here still gets
      -- formatted via its LSP if the server supports formatting.
      formatters_by_ft = {
        lua        = { "stylua" },
        python     = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json       = { "prettier" },
        html       = { "prettier" },
        css        = { "prettier" },
        markdown   = { "prettier" },
        yaml       = { "prettier" },
        c          = { "clang-format" },
        cpp        = { "clang-format" },
        rust       = { "rustfmt" },
        cs         = { "csharpier" },
        sh         = { "shfmt" },
        bash       = { "shfmt" },
      },
      -- Override per-formatter defaults so every language indents with 4
      -- spaces (matches lua/ivan/set.lua's tabstop/shiftwidth = 4). Black,
      -- rustfmt and csharpier already default to 4. Prettier and clang-format
      -- default to 2, stylua and shfmt default to tabs — those need explicit
      -- args.
      formatters = {
        ["clang-format"] = {
          -- IndentAccessModifiers: true puts `public:` / `private:` /
          -- `protected:` at one indent level (4 spaces) and nests members
          -- one level deeper (8 spaces). AccessModifierOffset is ignored
          -- when this is enabled.
          prepend_args = {
            "--style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never, IndentAccessModifiers: true}",
          },
        },
        prettier = {
          prepend_args = { "--tab-width", "4", "--use-tabs", "false" },
        },
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
        },
        shfmt = {
          prepend_args = { "-i", "4" },
        },
      },
    })
  end,
}
