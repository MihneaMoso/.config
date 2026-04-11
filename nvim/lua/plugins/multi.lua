return {
    {
        'mg979/vim-visual-multi',
        branch = 'master',
        init = function()
            -- These global variables MUST be set before the plugin loads
            vim.g.VM_maps = {
                -- Mapping Ctrl+Shift+Arrows for Normal and Visual mode
                ['Add Cursor Down']  = '<C-S-Down>',
                ['Add Cursor Up']    = '<C-S-Up>',
                -- Note: vim-visual-multi treats Left/Right slightly differently 
                -- but we can map them to 'Add Cursor At Pos' logic
                ['Add Cursor Left']  = '<C-S-Left>',
                ['Add Cursor Right'] = '<C-S-Right>',
            }
            
            -- Mouse support
            vim.keymap.set('n', '<C-S-LeftMouse>', '<Plug>(VM-Mouse-Cursor)', { desc = 'Add cursor at click' })
            vim.keymap.set('n', '<C-LeftMouse>', '<Plug>(VM-Mouse-Cursor)', { desc = 'Add cursor' })

            vim.keymap.set('n', '<C-LeftMouse>', '<Nop>', { noremap = true, silent = true })
            -- Escape behavior
            -- By default, vim-visual-multi uses <Esc> or 'q' to exit.
            -- If it doesn't feel snappy, you can explicitly map it:
            vim.g.VM_quit_after_leaving_insert_mode = 0 -- Keep cursors when leaving insert mode
        end,
    },
}
