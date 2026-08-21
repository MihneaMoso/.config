
-- Ensure netrw is listed in the buffer list
vim.api.nvim_create_autocmd({"FileType", "BufEnter"}, {
    pattern = "netrw",
    callback = function()
        vim.opt_local.buflisted = true
    end,
})

-- Highlight selection on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})


-- Autosave

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = "*",
  command = "silent! update",
})

-- don't really know where to put this yet
vim.cmd(":command! -nargs=+ Grep execute 'silent grep! <args>' | copen")
-- another better version would be:
-- vim.api.nvim_create_user_command("Grep", function(opts)
--     vim.cmd("silent grep! " .. vim.fn.shellescape(opts.args))
--     vim.cmd("copen")
-- end, { nargs = "+" })


