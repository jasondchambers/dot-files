return {
  'goolord/alpha-nvim',
  event = "VimEnter",
  dependencies = { 'nvim-mini/mini.icons' },
  config = function ()
    require'alpha'.setup(require'alpha.themes.startify'.config)
  end
}
