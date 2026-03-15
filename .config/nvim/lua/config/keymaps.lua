-- ╔═══════════════════════════════════════╗
-- ║       nvim/lua/config/keymaps.lua     ║
-- ╚═══════════════════════════════════════╝

local map = vim.keymap.set

-- ── Leader ────────────────────────────────────────────────────────────────────
vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

-- ── Better escape ────────────────────────────────────────────────────────────
map("i", "jk", "<ESC>",  { desc = "Exit insert mode" })
map("i", "kj", "<ESC>",  { desc = "Exit insert mode" })

-- ── Save / quit ──────────────────────────────────────────────────────────────
map("n", "<leader>w", "<cmd>w<cr>",   { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>",   { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Force quit all" })

-- ── Window navigation ────────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- ── Resize windows ───────────────────────────────────────────────────────────
map("n", "<C-Up>",    "<cmd>resize +2<cr>",          { desc = "Increase window height" })
map("n", "<C-Down>",  "<cmd>resize -2<cr>",          { desc = "Decrease window height" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- ── Buffer navigation ─────────────────────────────────────────────────────────
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>",     { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- ── Move lines ───────────────────────────────────────────────────────────────
map("n", "<A-j>", "<cmd>m .+1<cr>==",        { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==",        { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv",       { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv",       { desc = "Move selection up" })

-- ── Keep visual selection when indenting ──────────────────────────────────────
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- ── Better search ────────────────────────────────────────────────────────────
map("n", "n", "nzzzv", { desc = "Next result (center)" })
map("n", "N", "Nzzzv", { desc = "Prev result (center)" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- ── Clipboard ────────────────────────────────────────────────────────────────
map("v", "p", '"_dP',     { desc = "Paste without yanking selection" })
map("n", "x", '"_x',      { desc = "Delete char without yank" })

-- ── Splits ───────────────────────────────────────────────────────────────────
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>-", "<cmd>split<cr>",  { desc = "Horizontal split" })

-- ── Terminal ──────────────────────────────────────────────────────────────────
map("t", "<Esc>",   "<C-\\><C-n>",    { desc = "Exit terminal mode" })
map("t", "<C-h>",   "<C-\\><C-n><C-w>h" )
map("t", "<C-j>",   "<C-\\><C-n><C-w>j" )
map("t", "<C-k>",   "<C-\\><C-n><C-w>k" )
map("t", "<C-l>",   "<C-\\><C-n><C-w>l" )

-- ── Notes (markdown files in ~/notes/) ───────────────────────────────────────
map("n", "<leader>nn", "<cmd>e ~/notes/index.md<cr>",  { desc = "Open notes index" })
map("n", "<leader>nj", function()
    local date = os.date("%Y-%m-%d")
    vim.cmd("e ~/notes/journal/" .. date .. ".md")
end, { desc = "Open today's journal" })
