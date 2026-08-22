vim.g.mapleader = " "
vim.g.termguicolors = true
vim.g.neovide_cursor_animation_length = 0

require("options")
require("colorscheme")
require("autocommands")
require("navigation")
require("keymaps")
require("netrw")
require("grep")
require("statusline")
require("find")


-- Load the bootstrap and lazy setup
require("config.lazy")
