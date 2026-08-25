local pms = vim.api.nvim_get_hl(0, { name = "PmenuSel", link = false })
local dir = vim.api.nvim_get_hl(0, { name = "Directory", link = false })
local vis = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
vim.api.nvim_set_hl(0, "StlMode", { fg = pms.fg, bg = vis.bg })
vim.api.nvim_set_hl(0, "StlGit", { fg = dir.fg, bg = pms.bg })

local modes = {
	n = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	V = "V-LINE",
	["\22"] = "V-BLOCK",
	c = "COMMAND",
	t = "TERMINAL",
	R = "REPLACE",
	s = "SELECT",
	S = "S-LINE",
	["\19"] = "S-BLOCK",
}

function _G._statusline()
	local mode = modes[vim.fn.mode()] or vim.fn.mode():upper()
	local branch = vim.b.git_branch and "%#StlGit# " .. vim.b.git_branch .. " %*" or ""
	local path = vim.b.rel_path or "%f"

	local diag = ""
	local counts = vim.diagnostic.count(0) or {}
	local labels = { " ", " ", " ", " " }
	local hls = { "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint" }
	for i = 1, 4 do
		if counts[i] and counts[i] > 0 then
			diag = diag .. "%#" .. hls[i] .. "#" .. labels[i] .. counts[i] .. "%* "
		end
	end

	return "%#StlMode# " .. mode .. " %*" .. branch .. " " .. path .. "%=" .. diag .. " " .. vim.bo.filetype .. " %l:%c"
end

-- Git info for the statusline: looked up once per buffer directory (asynchronously,
-- never blocking) and cached, instead of running synchronous `git` subprocesses on
-- every BufEnter. Re-entering buffers in a known project costs zero subprocesses.
local git_info = {} -- [dir] = { pending = bool, root = string|false, branch = string|nil }

local function apply_git_info(entry)
	if entry.root then
		vim.b.git_branch = entry.branch
		vim.b.rel_path = vim.fs.relpath(entry.root, vim.api.nvim_buf_get_name(0))
	else
		vim.b.git_branch = nil
		vim.b.rel_path = vim.fn.expand("%:p:~")
	end
end

local function update_git_info()
	local dir = vim.fn.expand("%:p:h")
	if dir == "" then
		dir = vim.uv.cwd()
	end

	local entry = git_info[dir]
	if entry then
		if not entry.pending then
			apply_git_info(entry)
		end
		return
	end

	-- First time we see this directory: resolve it without blocking the UI.
	entry = { pending = true }
	git_info[dir] = entry

	vim.system({ "git", "-C", dir, "rev-parse", "--show-toplevel" }, { text = true }, function(res)
		vim.schedule(function()
			entry.root = res.code == 0 and vim.trim(res.stdout) or false
			if not entry.root then
				entry.pending = false
				if vim.fn.expand("%:p:h") == dir then
					apply_git_info(entry)
				end
				vim.cmd.redrawstatus()
				return
			end

			vim.system({ "git", "-C", entry.root, "branch", "--show-current" }, { text = true }, function(branch_res)
				vim.schedule(function()
					entry.branch = branch_res.code == 0 and vim.trim(branch_res.stdout) or nil
					entry.pending = false
					if vim.fn.expand("%:p:h") == dir then
						apply_git_info(entry)
					end
					vim.cmd.redrawstatus()
				end)
			end)
		end)
	end)
end

local stl_group = vim.api.nvim_create_augroup("statusline", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
	group = stl_group,
	callback = update_git_info,
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	group = stl_group,
	callback = function()
		vim.cmd("redrawstatus!")
	end,
})

vim.o.statusline = "%!v:lua._statusline()"
