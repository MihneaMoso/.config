-- File list backing :find, built lazily and cached per working directory.
-- Prefers ripgrep (respects .gitignore, far faster than recursive globbing);
-- falls back to the old glob walk when rg is unavailable.
local ignore_patterns = {
	"node_modules",
	"%.git",
	"%.cache",
	"dist",
	"build",
	"%.tmp",
	"%.log",
}

local file_list = nil

local function ignored(f)
	for _, pat in ipairs(ignore_patterns) do
		if f:match(pat) then
			return true
		end
	end
	return false
end

local function list_files()
	if file_list then
		return file_list
	end

	local result = {}

	if vim.fn.executable("rg") == 1 then
		local out = vim.system({ "rg", "--files", "--hidden", "--glob", "!.git/" }):wait()
		if out.code == 0 then
			for f in out.stdout:gmatch("[^\n]+") do
				if not ignored(f) then
					result[#result + 1] = f
				end
			end
		end
	end

	if #result == 0 then -- no ripgrep (or it failed): fall back to globbing
		for _, f in ipairs(vim.fn.glob("**/*", true, true)) do
			if vim.fn.isdirectory(f) == 0 and not ignored(f) then
				result[#result + 1] = f
			end
		end
	end

	file_list = result
	return result
end

function _G.native_find(text, _)
	return vim.fn.matchfuzzy(list_files(), text)
end

vim.opt.findfunc = "v:lua.native_find"

-- Kept in `:` form on purpose: expects further typed input.
vim.keymap.set("n", "<leader>f", ":find ", { silent = false })

-- Invalidate the cache when the project changes or files are written,
-- so newly created files show up on the next :find.
vim.api.nvim_create_autocmd({ "DirChanged", "BufWritePost" }, {
	group = vim.api.nvim_create_augroup("find_cache", { clear = true }),
	callback = function()
		file_list = nil
	end,
})
