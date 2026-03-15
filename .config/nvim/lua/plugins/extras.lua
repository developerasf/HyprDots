-- ╔═══════════════════════════════════════╗
-- ║       nvim/lua/plugins/extras.lua     ║
-- ║   Extra plugins on top of LazyVim     ║
-- ╚═══════════════════════════════════════╝

return {

    -- ── Tokyo Night colorscheme (matches whole system) ────────────────────────
    {
        "folke/tokyonight.nvim",
        lazy     = false,
        priority = 1000,
        opts = {
            style         = "night",   -- night | storm | day | moon
            transparent   = true,      -- match kitty bg_opacity
            terminal_colors = true,
            styles = {
                comments  = { italic = true },
                keywords  = { italic = true },
                functions = {},
                variables = {},
                sidebars  = "dark",
                floats    = "dark",
            },
        },
    },

    -- ── Render markdown in-buffer ─────────────────────────────────────────────
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        ft = { "markdown" },
        opts = {
            heading = { enabled = true },
            code    = { enabled = true, sign = true, width = "block" },
        },
    },

    -- ── Note-taking with telekasten ───────────────────────────────────────────
    {
        "renerocksai/telekasten.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        keys = {
            { "<leader>zf", "<cmd>Telekasten find_notes<cr>",         desc = "Find notes" },
            { "<leader>zd", "<cmd>Telekasten goto_today<cr>",         desc = "Today journal" },
            { "<leader>zn", "<cmd>Telekasten new_note<cr>",           desc = "New note" },
            { "<leader>zg", "<cmd>Telekasten search_notes<cr>",       desc = "Search notes" },
            { "<leader>zl", "<cmd>Telekasten insert_link<cr>",        desc = "Insert link" },
            { "<leader>zb", "<cmd>Telekasten show_backlinks<cr>",     desc = "Backlinks" },
        },
        opts = {
            home = vim.fn.expand("~/notes"),
        },
    },

    -- ── Lazygit inside nvim ───────────────────────────────────────────────────
    {
        "kdheepak/lazygit.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },

    -- ── Better todo comments ──────────────────────────────────────────────────
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "BufReadPost",
        opts  = {},
    },

    -- ── Surround ──────────────────────────────────────────────────────────────
    {
        "kylechui/nvim-surround",
        event = "BufReadPost",
        opts  = {},
    },

    -- ── Auto-save ────────────────────────────────────────────────────────────
    {
        "okuuva/auto-save.nvim",
        event = { "InsertLeave", "TextChanged" },
        opts  = {
            execution_message = { enabled = false },
            debounce_delay    = 1000,
        },
    },

    -- ── Harpoon — fast file navigation ───────────────────────────────────────
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ha", function() require("harpoon"):list():add() end,     desc = "Harpoon add" },
            { "<leader>hh", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon menu" },
            { "<leader>1",  function() require("harpoon"):list():select(1) end, desc = "Harpoon file 1" },
            { "<leader>2",  function() require("harpoon"):list():select(2) end, desc = "Harpoon file 2" },
            { "<leader>3",  function() require("harpoon"):list():select(3) end, desc = "Harpoon file 3" },
            { "<leader>4",  function() require("harpoon"):list():select(4) end, desc = "Harpoon file 4" },
        },
    },

    -- ── colorizer — show hex colors in-buffer ─────────────────────────────────
    {
        "NvChad/nvim-colorizer.lua",
        event = "BufReadPost",
        opts  = { user_default_options = { mode = "background", tailwind = true } },
    },

    -- ── Zen mode for focused writing ──────────────────────────────────────────
    {
        "folke/zen-mode.nvim",
        keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
        opts  = { window = { width = 0.75 } },
    },
}
