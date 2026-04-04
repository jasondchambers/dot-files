return {
  -- Mason: manages installing LSP servers, formatters, linters
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Bridge between mason and lspconfig (ensures servers are installed)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "ruff", "bashls" },
      })
      -- Also ensure debugpy is installed for Python debugging
      local mason_registry = require("mason-registry")
      if not mason_registry.is_installed("debugpy") then
        mason_registry.get_package("debugpy"):install()
      end
    end,
  },

  -- LSP keymaps and configuration (using Neovim 0.11 native API)
  {
    "hrsh7th/cmp-nvim-lsp",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Show diagnostic messages as inline virtual text
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underlines = true,
      })

      -- Keymaps that activate when an LSP attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }

          opts.desc = "Go to definition"
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

          opts.desc = "Go to declaration"
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

          opts.desc = "Show references"
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

          opts.desc = "Show hover info"
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

          opts.desc = "Rename symbol"
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

          opts.desc = "Code action"
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

          opts.desc = "Debugging"
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

          opts.desc = "Next diagnostic"
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

          opts.desc = "Previous diagnostic"
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

          -- Format on save for sh/bash files
          local ft = vim.bo[ev.buf].filetype
          if ft == "sh" or ft == "bash" then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = ev.buf,
              callback = function()
                vim.lsp.buf.format({ async = false })
              end,
            })
          end

          opts.desc = "Toggle inline diagnostics"
          vim.keymap.set("n", "<leader>td", function()
            vim.diagnostic.enable(not vim.diagnostic.is_enabled())
          end, opts)
        end,
      })

      -- Configure pyright using Neovim 0.11 native vim.lsp.config
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
            },
          },
        },
      })

      -- Configure ruff linter (runs alongside pyright)
      vim.lsp.config("ruff", {
        capabilities = capabilities,
        cmd = { "ruff", "server" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", "setup.py", ".git" },
        init_options = {
          settings = {
            lineLength = 120,
          },
        },
        -- Disable hover so it doesn't conflict with pyright
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
        end,
      })

      -- Configure bash-language-server
      -- Provides: completions, hover, go-to-definition, formatting (via shfmt), diagnostics (via shellcheck)
      -- Install supporting tools: :MasonInstall shfmt shellcheck
      vim.lsp.config("bashls", {
        capabilities = capabilities,
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh", "bash" },
        root_markers = { ".git" },
        settings = {
          bashIde = {
            globPattern = "*@(.sh|.inc|.bash|.command)",
          },
        },
      })

      -- Enable LSP servers (auto-attach to matching filetypes)
      vim.lsp.enable("pyright")
      vim.lsp.enable("ruff")
      vim.lsp.enable("bashls")
    end,
  },

  -- Autocompletion engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP completions
      "hrsh7th/cmp-buffer",   -- buffer word completions
      "hrsh7th/cmp-path",     -- file path completions
      "L3MON4D3/LuaSnip",    -- snippet engine (required by nvim-cmp)
      "saadparwaiz1/cmp_luasnip", -- snippet completions
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
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
