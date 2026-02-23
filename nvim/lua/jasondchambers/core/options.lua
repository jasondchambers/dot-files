-- This changes the built in file explorer style to a tree style
vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- Show relative line numbers from current position and
-- show absolute line number for current line
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = false -- Do not ignore case when searching

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard - when you yank, it will copy to the systtem clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-------------------------------------------------------------------------------
-- This section inspired by this video https://www.youtube.com/watch?v=lljs_7xB7Ps&t=1953s
-------------------------------------------------------------------------------
---
-- This whole block makes neovim reload external changes to the file reflect in neovim
-- Useful for when working with AI agents
vim.opt.autoread = true
vim.opt.autowrite = false
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})
opt.updatetime = 1000 -- run checktime more regularly
opt.swapfile = false

-- Show a column at 80 columns
opt.colorcolumn = "80"
-- Keep 10 lines above/below cursor when scrolling
opt.scrolloff = 10

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then -- except in diff mode
			return
		end

		local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
		local last_line = vim.api.nvim_buf_line_count(0)

		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end

		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})
