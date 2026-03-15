-- ╔═══════════════════════════════════════╗
-- ║          nvim/init.lua                ║
-- ║   LazyVim bootstrap entry point       ║
-- ╚═══════════════════════════════════════╝
-- Full docs: https://www.lazyvim.org

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        repo, lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
        }, true, {})
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Load options before lazy so they apply immediately
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Bootstrap LazyVim
require("lazy").setup({
    spec = {
        -- LazyVim core — loads all default plugins
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },

        -- ── Language extras ─────────────────────────────────────────────
        { import = "lazyvim.plugins.extras.lang.typescript" },
        { import = "lazyvim.plugins.extras.lang.python" },
        { import = "lazyvim.plugins.extras.lang.rust" },
        { import = "lazyvim.plugins.extras.lang.go" },
        { import = "lazyvim.plugins.extras.lang.java" },
        { import = "lazyvim.plugins.extras.lang.json" },
        { import = "lazyvim.plugins.extras.lang.markdown" },
        { import = "lazyvim.plugins.extras.lang.docker" },

        -- ── Tools ────────────────────────────────────────────────────────
        { import = "lazyvim.plugins.extras.util.mini-hipatterns" },

        -- ── Your custom plugins ──────────────────────────────────────────
        { import = "plugins" },
    },
    defaults = {
        lazy    = false,
        version = false,  -- always latest
    },
    install  = { colorscheme = { "tokyonight", "habamax" } },
    checker  = { enabled = true },  -- auto-check plugin updates
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip", "matchit", "matchparen",
                "netrwPlugin", "tarPlugin", "tohtml",
                "tutor", "zipPlugin",
            },
        },
    },
})
