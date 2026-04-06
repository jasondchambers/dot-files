local alpha = require('alpha')
local startify = require('alpha.themes.startify')

-- ASCII header
startify.section.header.val = {
  [[│ ╲ ││ ]],
  [[││╲╲││ ]],
  [[││ ╲ │ ]],
}

-- Buttons above MRU
startify.section.top_buttons.val = {
  startify.button("e", "  New file",      "<cmd>ene<CR>"),
  startify.button("f", "  Find file",     "<cmd>Telescope find_files<CR>"),
  startify.button("g", "  Live grep",     "<cmd>Telescope live_grep<CR>"),
}

-- Buttons below MRU
startify.section.bottom_buttons.val = {
  startify.button("q", "  Quit", "<cmd>q<CR>"),
}

-- Footer
startify.section.footer.val = {
  { type = "text", val = "happy hacking", opts = { hl = "Comment", position = "left" } },
}

alpha.setup(startify.config)

