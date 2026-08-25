vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.keymap.set("n", "<leader>g", function()
	vim.ui.input({ prompt = "Grep: " }, function(pattern)
		if pattern and pattern ~= "" then
			-- Structural invocation: sidesteps shell/command-line quoting pitfalls
			-- with patterns containing %, #, backticks, etc.
			vim.cmd({ cmd = "grep", bang = true, args = { pattern }, mods = { silent = true } })
			vim.cmd("copen")
		end
	end)
end, { silent = true, desc = "Live grep (ripgrep)" })
