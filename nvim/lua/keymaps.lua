
local navigation = require("navigation")
local map = vim.keymap.set

-- Keymaps for Alt + Arrow Keys
-- Note: On some terminals, <A- is represented as <M- (Meta)
map('n', '<A-Right>', function() navigation.smart_buffer_move(1) end, { desc = "Next Buffer" })
map('n', '<A-Left>', function() navigation.smart_buffer_move(-1) end, { desc = "Prev Buffer" })

map('n', '<A-Up>', function() navigation.move_line_up() end, { desc = "Move line up" })
map('n', '<A-Down>', function() navigation.move_line_down() end, { desc = "Move line below" })



map("n", "<C-h>", "<C-w><C-h>")
map("n", "<C-j>", "<C-w><C-j>")
map("n", "<C-k>", "<C-w><C-k>")
map("n", "<C-l>", "<C-w><C-l>")

-- Word deletion
map("i", "<C-Backspace>", "<C-w>", { noremap = true, silent = true })
map("i", "<C-Delete>", "<C-o>dw", { noremap = true, silent = true })

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
-- map("n", "<A-Left>", ":bprevious")

map("n", "<leader>w", ":write<CR>")
map("n", "<leader>q", ":quit<CR>")
map("n", "<leader>Q", ":quit!<CR>")
map("v", "<leader>y", "\"+y")
map("n", "<leader>f", ":Lexplore<CR>")
map("n", "<leader>e", ":Explore<CR>")
map("n", "<leader>v", ":edit $MYVIMRC<CR>")
--map("n", "<leader>ff", ":find ")
--map("n", "<leader>fg", ":Grep ")
map("n", "<leader>r", ":make!<CR>")
map("n", "<leader>R", ":set makeprg=")
map("n", "<leader>x", ":copen<CR>")
map("n", "<leader>c", ":!ctags -R .<CR>")
map("n", "<leader>s", ":split<CR><C-w><Down>")
map("n", "<leader>d", ":vsplit<CR><C-w><Right>")
map("n", "<leader>t", ":below term<CR>i")

map("n", "<leader>/", "gcc", { remap = true })
map("v", "<leader>/", "gc", { remap = true })

map("n", "<C-/>", "gcc", { remap = true })
map("v", "<C-/>", "gc", { remap = true })


-- Regular copy/cut/pasting
map("v", "<C-c>", '"+y', { desc = "Copy to clipboard" })
map({ "n", "i", "v", "c", "t" }, "<C-x>", function()
  vim.cmd('normal! "+d')
end, { desc = "Cut to clipboard", silent = true })

map({ "n", "i", "v", "c", "t" }, "<C-v>", function()
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


