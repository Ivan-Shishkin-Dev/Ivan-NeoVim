return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Mason: installs/manages LSP server binaries
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Completion engine + sources
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",         -- Lua
          "ts_ls",          -- TypeScript / JavaScript
          "rust_analyzer",  -- Rust
          "pyright",        -- Python
          "clangd",         -- C / C++
          "gopls",          -- Go
          "html",
          "cssls",
          "jsonls",
          "yamlls",
          "bashls",
        },
      })

      -- Tell each server that the editor supports cmp's enhanced completion items
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig    = require("lspconfig")
      for _, server in ipairs({
        "lua_ls", "ts_ls", "rust_analyzer", "pyright", "clangd",
        "gopls", "html", "cssls", "jsonls", "yamlls", "bashls",
      }) do
        lspconfig[server].setup({ capabilities = capabilities })
      end

      -- Completion menu (uses cmp's built-in default keymaps)
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert(),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
