-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- New tab
keymap.set("n", "te", ":tabedit<Return>")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")
-- Close window
keymap.set("n", "q", ":q<Return>", opts)
-- Save File
keymap.set("n", "w", ":w<Return>", opts)
-- Enter Visual Block mode with Crtl + Space + v
keymap.set("n", "<C-Space>v", "<C-v>", opts)
-- Edit Move Line
keymap.set("n", "<M-k>", ":m -2<Return>", opts)
keymap.set("n", "<M-j>", ":m +1<Return>", opts)
keymap.set("n", "<M-Up>", ":m -2<Return>", opts)
keymap.set("n", "<M-Down>", ":m +1<Return>", opts)
