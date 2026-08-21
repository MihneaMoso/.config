local M = {}

function M.smart_buffer_move(direction)
    -- direction is 1 for next, -1 for previous
    local cmd = direction == 1 and "bnext" or "bprev"
    
    -- Try to move
    local success, _ = pcall(vim.cmd, cmd)
    
    -- If we landed on a buffer that isn't a file or netrw, 
    -- and we have more than one buffer, skip it.
    if success and vim.bo.buftype ~= "" and vim.bo.filetype ~= "netrw" then
        vim.cmd(cmd)
    end
end


function M.move_line_up()
    vim.cmd(":m .-2==")
end

function M.move_line_down()
    vim.cmd(":m .+1==")
end

return M
