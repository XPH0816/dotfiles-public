-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Check The OS is Windows or not
if vim.fn.has("win32") == 1 then
    opt.shell = "powershell"
end

opt.tabstop = 4
opt.shiftwidth = 4
