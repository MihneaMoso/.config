vim.g.mapleader = " "
vim.g.termguicolors = true

vim.o.nu = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.wrap = false
vim.o.undofile = true
vim.o.undodir = os.getenv("HOME") .. "/.cache/nvim/undodir"
vim.o.list = true
--vim.o.listchars = "tabs:> "
vim.o.path = "**"
vim.opt.mouse = 'a'

vim.g.neovide_cursor_animation_length = 0

vim.cmd(":colorscheme retrobox")
vim.cmd(":command! -nargs=+ Grep execute 'silent grep! <args>' | copen")

vim.treesitter.language.register("cpp", "c")
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "c", "h", "cpp",
        "lua"
    },
    callback = function() vim.treesitter.start() end,
})

local map = vim.keymap.set
map("n", "<C-h>", "<C-w><C-h>")
map("n", "<C-j>", "<C-w><C-j>")
map("n", "<C-k>", "<C-w><C-k>")
map("n", "<C-l>", "<C-w><C-l>")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map({ "i", "n" }, "<C-n>", "<C-x><C-]>")
map({ "i", "n" }, "<C- >", "<C-x><C-o>")

map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("t", "<ESC>", "<C-\\><C-n>")
map("n", "<A-h>", ":below term<CR>i")

map("n", "<leader>w", ":write<CR>")
map("n", "<leader>q", ":quit<CR>")
map("n", "<leader>Q", ":quit!<CR>")
map("v", "<leader>y", "\"+y")
map("n", "<leader>e", ":Lexplore<CR>")
map("n", "<leader>v", ":edit $MYVIMRC<CR>")
map("n", "<leader>ff", ":find ")
map("n", "<leader>fg", ":Grep ")
map("n", "<leader>r", ":make!<CR>")
map("n", "<leader>R", ":set makeprg=")
map("n", "<leader>x", ":copen<CR>")
map("n", "<leader>c", ":!ctags -R .<CR>")

-- Neovide pasting
--if vim.g.neovide then
--  vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy to clipboard" })
--  vim.keymap.set({ "n", "i", "v", "c", "t" }, "<C-v>", function()
--    vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
--  end, { desc = "Paste from clipboard", silent = true })
--end

-- Regular pasting
vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy to clipboard" })
  vim.keymap.set({ "n", "i", "v", "c", "t" }, "<C-v>", function()
    vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
  end, { desc = "Paste from clipboard", silent = true })


--map('n', '<C-h>', ':bprevious<CR>', { desc = 'Previous buffer' })
--map('n', '<C-l>', ':bnext<CR>', { desc = 'Next buffer' })

map('n', '<C-w><Up>', '<C-w>k')
map('n', '<C-w><Down>', '<C-w>j')
map('n', '<C-w><Left>', '<C-w>h')
map('n', '<C-w><Right>', '<C-w>l')

map('n', '<C-w><C-Up>', '<C-w>k')
map('n', '<C-w><C-Down>', '<C-w>j')
map('n', '<C-w><C-Left>', '<C-w>h')
map('n', '<C-w><C-Right>', '<C-w>l')

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
-- vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
    {
        'mg979/vim-visual-multi',
        branch = 'master',
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- Multi-cursor Configuration
vim.g.VM_maps = {
    -- Mapping Ctrl+Shift+Arrows for Normal and Visual mode
    ['Add Cursor Down']             = '<C-S-Down>',
    ['Add Cursor Up']               = '<C-S-Up>',
    -- Note: vim-visual-multi treats Left/Right slightly differently 
    -- but we can map them to 'Add Cursor At Pos' logic
    ['Add Cursor Left']             = '<C-S-Left>',
    ['Add Cursor Right']            = '<C-S-Right>',
}

-- Mouse Support: Ctrl+Shift+Click to add a cursor
vim.keymap.set('n', '<C-S-LeftMouse>', '<Plug>(VM-Mouse-Cursor)', { desc = 'Add cursor at click' })

-- Escape behavior
-- By default, vim-visual-multi uses <Esc> or 'q' to exit.
-- If it doesn't feel snappy, you can explicitly map it:
vim.g.VM_quit_after_leaving_insert_mode = 0 -- Keep cursors when leaving insert mode
