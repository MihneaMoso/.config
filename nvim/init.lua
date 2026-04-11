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
-- map("n", "<A-h>", ":below term<CR>i")

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
map("n", "<leader>s", ":split<CR><C-w><Down>")
map("n", "<leader>t", ":below term<CR>i")



-- Regular pasting
vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy to clipboard" })
  vim.keymap.set({ "n", "i", "v", "c", "t" }, "<C-v>", function()
    vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
  end, { desc = "Paste from clipboard", silent = true })


--map('n', '<C-h>', ':bprevious<CR>', { desc = 'Previous buffer' })
--map('n', '<C-l>', ':bnext<CR>', { desc = 'Next buffer' })

-- Pane navigation
map('n', '<C-w><Up>', '<C-w>k')
map('n', '<C-w><Down>', '<C-w>j')
map('n', '<C-w><Left>', '<C-w>h')
map('n', '<C-w><Right>', '<C-w>l')

map('n', '<C-w><C-Up>', '<C-w>k')
map('n', '<C-w><C-Down>', '<C-w>j')
map('n', '<C-w><C-Left>', '<C-w>h')
map('n', '<C-w><C-Right>', '<C-w>l')


-- Load the bootstrap and lazy setup
require("config.lazy")
