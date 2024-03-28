return {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    config = function()
      require("gitsigns").setup()
      vim.keymap.set("n", "<F5>", ":Gitsigns preview_hunk<CR>", {})
    end
}
