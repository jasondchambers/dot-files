return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "bash",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "tsx",
          "typescript",
          "vim",
          "yaml",
        },
      })

      -- nvim-treesitter-textobjects new API: keymaps wired directly to move functions
      local move = require("nvim-treesitter-textobjects.move")
      require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })

      vim.keymap.set("n", "]f", function() move.goto_next_start("@function.outer") end, { desc = "Next function" })
      vim.keymap.set("n", "[f", function() move.goto_previous_start("@function.outer") end, { desc = "Previous function" })
    end,
 }
