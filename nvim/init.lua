vim.g.mapleader = " "
vim.g.termguicolors = true
vim.g.neovide_cursor_animation_length = 0

require("options")
require("colorscheme")
require("autocommands")
require("navigation")
require("keymaps")
require("netrw")


-- Load the bootstrap and lazy setup
require("config.lazy")
