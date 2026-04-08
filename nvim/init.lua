-- Brand new simplified modernized config for Neovim 0.12
-- 1. Options (no plugins needed)
vim.opt.termguicolors = true -- Needed by Colorizer
vim.opt.relativenumber = true -- Show relative line numbers from current position 
vim.opt.number = true -- show absolute line number for current line
vim.opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
vim.opt.shiftwidth = 2 -- 2 spaces for indent width
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.autoindent = true -- copy indent from current line when starting new one
vim.opt.wrap = false -- disable line wrapping
vim.opt.ignorecase = false -- Do not ignore case when searching
vim.opt.cursorline = true -- highlight the current cursor line
vim.opt.clipboard:append("unnamedplus") -- yank to the system clipboard
vim.opt.signcolumn = "yes" -- sign column is used for git signs, diagnostics, breakpoints
vim.opt.colorcolumn = "80" -- Show where column 80 is
vim.opt.scrolloff = 10 -- Keep 10 lines above/below cursor when scrolling
vim.opt.autoread = true -- External file change detection (useful for AI agent workflows)
vim.opt.autowrite = false -- Ditto
vim.opt.updatetime = 1000 -- Ditto
vim.opt.swapfile = false -- Ditto
vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.g.mapleader = " "
vim.g.loaded_perl_provider   = 0
vim.g.loaded_ruby_provider   = 0
vim.g.python3_host_prog = vim.fn.expand('~/.venv/neovim/bin/python3')
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, { -- Ditto
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})
vim.api.nvim_create_autocmd("FileType", { -- Enable line wrapping for markdown
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true -- wrap at word boundaries, not mid-word
  end,
})
vim.api.nvim_create_autocmd("BufReadPost", { -- Restore to the cursor position last time file was opened
  desc = "Restore last cursor position",
  callback = function()
    if vim.o.diff then return end
    local last_pos = vim.api.nvim_buf_get_mark(0, '"')
    local last_line = vim.api.nvim_buf_line_count(0)
    local row = last_pos[1]
    if row < 1 or row > last_line then return end
    pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
  end,
})

-- 2. Install & load plugins
-- Status of plug-ins from previous config (pre 0.12)
-- DONE alpha.lua
-- NOT-NOW auto-session.lua
-- DONE colorizer.lua
-- NOT-NOW dap.lua
-- IGNORE dressing.lua -- It's been archived
-- DONE gitsigns.lua
-- DONE indent-blankline.lua
-- DONE lazygit.lua
-- IGNORE lsp.lua
-- DONE lualine.lua
-- DONE nvim-tree.lua
-- DONE smart-splits.lua
-- DONE telescope.lua
-- IGNORE theme.lua
-- IGNORE theme.lua.default
-- DONE treesitter.lua
-- DONE vim-maximizer.lua
-- DONE which-key.lua

vim.pack.add { 
  'https://github.com/neovim/nvim-lspconfig', -- Collection of LSP server configurations
  'https://github.com/nvim-lua/plenary.nvim', -- Dependency of lazygit, nvim-telescope
  'https://github.com/kdheepak/lazygit.nvim', -- lazygit integration
  'https://github.com/NvChad/nvim-colorizer.lua', -- Colorize #aa0000
  'https://github.com/nvim-mini/mini.nvim',  -- Dependency of alpha
  'https://github.com/goolord/alpha-nvim', -- Nice greeter
  'https://github.com/lewis6991/gitsigns.nvim', -- GitSigns 
  'https://github.com/nvim-tree/nvim-web-devicons', -- Dependency of nvim-tree, nvim-telescope, lualine
  'https://github.com/nvim-tree/nvim-tree.lua', -- A nice file-explorer
  'https://github.com/mrjones2014/smart-splits.nvim', -- Ctrl-h,j,k,l across buffers and WezTerm splits
  'https://github.com/folke/which-key.nvim', -- Handy helper to show keybindings
  'https://github.com/nvim-telescope/telescope.nvim', -- Wonderful way to open files
  'https://github.com/szw/vim-maximizer', -- Maximize current split
  'https://github.com/nvim-lualine/lualine.nvim', -- Beautiful status line at the bottom
  'https://github.com/lukas-reineke/indent-blankline.nvim', -- Add indentation guides
  'https://github.com/nvim-treesitter/nvim-treesitter', -- indentation, highlighting for multiple languages
  'https://github.com/MeanderingProgrammer/render-markdown.nvim', -- Does what it says in the tin
}
vim.cmd("packadd nvim.undotree")
vim.cmd.colorscheme('miniautumn')
vim.api.nvim_set_hl(0, "Normal",      { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- 3. Configure each plugin

local colorizer = require('colorizer')
local alpha_custom_greeter = require('jasonchambers.alpha-custom-greeter')
local gitsigns = require('gitsigns')
local nvim_tree = require('nvim-tree')
local smart_splits = require('smart-splits')
local which_key = require('which-key')
local telescope = require('telescope')
local telescope_actions = require('telescope.actions')
local lualine = require('lualine')
local indent_blankline = require('ibl')
local nvim_treesitter = require('nvim-treesitter')
local render_markdown = require('render-markdown')
local undotree = require('undotree')


colorizer.setup({
  user_default_options = {
    RGB = true,
    RRGGBB = true,
    names = false,
    RRGGBBAA = true,
    rgb_fn = true,
    hsl_fn = true,
  },
})
gitsigns.setup()
nvim_tree.setup({
  view = {
    width = 35,
    relativenumber = true,
  },
  renderer = {
    indent_markers = {
      enable = true,
    },
    icons = {
      glyphs = {
        folder = {
          arrow_closed = "",
          arrow_open = "",
        },
      },
    },
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      },
    },
  },
  filters = {
    custom = { ".DS_Store" },
  },
  git = {
    ignore = false,
  },
})
smart_splits.setup()
which_key.setup()
telescope.setup({
  defaults = {
    path_display = { 'smart' },
    mappings = {
      i = {
        ['<C-k>'] = telescope_actions.move_selection_previous,
        ['<C-j>'] = telescope_actions.move_selection_next,
        ['<C-q>'] = telescope_actions.send_selected_to_qflist + telescope_actions.open_qflist,
      },
    },
  },
})
local colors = {
  blue        = "#65D1FF",
  green       = "#3EFFDC",
  violet      = "#FF61EF",
  yellow      = "#FFDA7B",
  red         = "#FF4A4A",
  fg          = "#c3ccdc",
  bg          = "#112638",
  inactive_bg = "#2c3043",
}
local my_lualine_theme = {
  normal = {
    a = { bg = colors.blue,   fg = colors.bg, gui = "bold" },
    b = { bg = colors.bg,     fg = colors.fg },
    c = { bg = colors.bg,     fg = colors.fg },
  },
  insert = {
    a = { bg = colors.green,  fg = colors.bg, gui = "bold" },
    b = { bg = colors.bg,     fg = colors.fg },
    c = { bg = colors.bg,     fg = colors.fg },
  },
  visual = {
    a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
    b = { bg = colors.bg,     fg = colors.fg },
    c = { bg = colors.bg,     fg = colors.fg },
  },
  command = {
    a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
    b = { bg = colors.bg,     fg = colors.fg },
    c = { bg = colors.bg,     fg = colors.fg },
  },
  replace = {
    a = { bg = colors.red,    fg = colors.bg, gui = "bold" },
    b = { bg = colors.bg,     fg = colors.fg },
    c = { bg = colors.bg,     fg = colors.fg },
  },
  inactive = {
    a = { bg = colors.inactive_bg, fg = colors.fg, gui = "bold" },
    b = { bg = colors.inactive_bg, fg = colors.fg },
    c = { bg = colors.inactive_bg, fg = colors.fg },
  },
}
lualine.setup({
  options = {
    theme = my_lualine_theme,
  },
  sections = {
    lualine_x = {
      { "encoding" },
      { "fileformat" },
      { "filetype" },
    },
  },
})
indent_blankline.setup({
  indent = { char = '┊' },
})
-- Treesitter section
nvim_treesitter.install({
  'bash',
  'python',
  'javascript',
  'typescript',
  'tsx',
  'lua',
  'json',
  'yaml',
  'markdown',
  'markdown_inline', -- needed for inline code in markdown
  'vim',
  'vimdoc',
})

-- Keep parsers up to date when plugin updates
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function()
    require('nvim-treesitter').update()
  end,
})

-- Enable highlighting, folding and indentation per filetype
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    local ok = pcall(vim.treesitter.start)
    if not ok then return end

    -- Indentation (provided by nvim-treesitter, experimental)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
render_markdown.setup({})

-- 4. Keymaps
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<leader>|", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
vim.keymap.set("n", "<leader>x", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' }) -- Lazygit
vim.keymap.set('n', ']h', gitsigns.next_hunk, { desc = 'Next git hunk' }) -- GitSigns
vim.keymap.set('n', '[h', gitsigns.prev_hunk, { desc = 'Previous git hunk' }) -- GitSigns
vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview hunk' }) -- GitSigns
vim.keymap.set('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Stage hunk' }) -- GitSigns
vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Reset hunk' }) -- GitSigns
vim.keymap.set('n', '<leader>gb', gitsigns.blame_line, { desc = 'Blame line' }) -- GitSigns
vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- nvim-tree
vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>",       { desc = "Collapse file explorer" }) -- nvim-tree
vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>",        { desc = "Refresh file explorer" }) -- nvim-tree
vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left) -- smart-splits
vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down) -- smart-splits
vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up) -- smart-splits
vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right) -- smart-splits
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>',  { desc = 'Fuzzy find files in cwd' }) -- telescope
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>',     { desc = 'Telescope buffers' }) -- telescope
vim.keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>',    { desc = 'Fuzzy find recent files' }) -- telescope
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>',   { desc = 'Find string in cwd' }) -- telescope
vim.keymap.set('n', '<leader>fc', '<cmd>Telescope grep_string<cr>', { desc = 'Find string under cursor in cwd' }) -- telescope
vim.keymap.set('n', '<leader>m', '<cmd>MaximizerToggle<CR>', { desc = 'Maximize/minimize a split' }) -- vim-maximizer
vim.keymap.set('i', '<CR>', function()
  return vim.fn.pumvisible() == 1 and '<C-y>' or '<CR>'
end, { expr = true })
vim.keymap.set("n", "<leader>u", require("undotree").open)


-- 5. LSP
-- 0.12 has a new native LSP config API
-- Moving away from Mason - instead, the LSP servers must be installed manually
-- using the chosen O/S package manager
vim.lsp.enable('basedpyright') -- Python LSP - ensure basedpyright is installed first
vim.lsp.enable('bashls') -- Bash LSP - ensure bash-language-server is installed first

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
})

vim.lsp.config('basedpyright', {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt',
  '.git' },
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })

    local opts = { buffer = ev.buf, silent = true }

    opts.desc = 'Go to definition'
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

    opts.desc = 'Go to declaration'
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)

    opts.desc = 'Show references'
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

    opts.desc = 'Show hover info'
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

    opts.desc = 'Rename symbol'
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

    opts.desc = 'Code action'
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)

    opts.desc = 'Show diagnostics'
    vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)

    opts.desc = 'Next diagnostic'
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

    opts.desc = 'Previous diagnostic'
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)

    opts.desc = 'Toggle inline diagnostics'
    vim.keymap.set('n', '<leader>td', function()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end, opts)

    -- Format on save for sh/bash files
    local ft = vim.bo[ev.buf].filetype
    if ft == 'sh' or ft == 'bash' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  end,
})


