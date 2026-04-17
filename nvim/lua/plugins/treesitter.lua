return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- This 'pcall' (protected call) prevents the error from 
      -- crashing your Neovim if the plugin files are missing.
      local status, treesitter = pcall(require, "nvim-treesitter.configs")
      if not status then
          return 
      end

      treesitter.setup({
        ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "python" },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true
        },
      })
    end,
  },
}
