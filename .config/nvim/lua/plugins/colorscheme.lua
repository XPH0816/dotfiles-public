return {
    {
        "craftzdog/solarized-osaka.nvim",
        { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
        lazy = true,
        priority = 1000,
        opts = function()
            return {
                transparent = false,
            }
        end,
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "catppuccin-mocha",
            },
        },
    },
}
