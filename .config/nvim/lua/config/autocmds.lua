-- ╔═══════════════════════════════════════╗
-- ║      nvim/lua/config/autocmds.lua     ║
-- ╚═══════════════════════════════════════╝

local function augroup(name)
    return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group    = augroup("highlight_yank"),
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
    end,
})

-- Resize splits on window resize
vim.api.nvim_create_autocmd("VimResized", {
    group    = augroup("resize_splits"),
    callback = function() vim.cmd("tabdo wincmd =") end,
})

-- Remember last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
    group    = augroup("last_cursor"),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- Close certain filetypes with just q
vim.api.nvim_create_autocmd("FileType", {
    group   = augroup("close_with_q"),
    pattern = { "help", "lspinfo", "man", "notify", "qf", "startuptime", "checkhealth" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- Set 2-space indent for web files
vim.api.nvim_create_autocmd("FileType", {
    group   = augroup("two_space_indent"),
    pattern = { "javascript", "typescript", "typescriptreact", "javascriptreact",
                "html", "css", "scss", "json", "yaml", "toml", "lua" },
    callback = function()
        vim.opt_local.tabstop    = 2
        vim.opt_local.shiftwidth = 2
    end,
})

-- Auto-create parent directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
    group    = augroup("auto_create_dir"),
    callback = function(event)
        if event.match:match("^%w%w+://") then return end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- Wrap and spell in markdown / text
vim.api.nvim_create_autocmd("FileType", {
    group   = augroup("wrap_spell"),
    pattern = { "markdown", "text", "gitcommit" },
    callback = function()
        vim.opt_local.wrap      = true
        vim.opt_local.spell     = true
        vim.opt_local.spelllang = "en_us"
    end,
})
