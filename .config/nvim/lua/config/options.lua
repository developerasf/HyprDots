-- ╔═══════════════════════════════════════╗
-- ║        nvim/lua/config/options.lua    ║
-- ╚═══════════════════════════════════════╝

local opt = vim.opt

-- ── UI ────────────────────────────────────────────────────────────────────────
opt.number         = true
opt.relativenumber = true
opt.cursorline     = true
opt.signcolumn     = "yes"
opt.colorcolumn    = "80,120"
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.wrap           = false
opt.termguicolors  = true
opt.showmode       = false       -- lualine shows it
opt.pumheight      = 10          -- max autocomplete items
opt.cmdheight      = 1
opt.laststatus     = 3           -- global statusline

-- ── Editing ───────────────────────────────────────────────────────────────────
opt.tabstop        = 4
opt.shiftwidth     = 4
opt.expandtab      = true
opt.smartindent    = true
opt.autoindent     = true
opt.breakindent    = true

-- ── Search ────────────────────────────────────────────────────────────────────
opt.ignorecase     = true
opt.smartcase      = true
opt.hlsearch       = true
opt.incsearch      = true

-- ── Files ─────────────────────────────────────────────────────────────────────
opt.undofile       = true
opt.swapfile       = false
opt.backup         = false
opt.fileencoding   = "utf-8"

-- ── Splits ────────────────────────────────────────────────────────────────────
opt.splitbelow     = true
opt.splitright     = true

-- ── Performance ───────────────────────────────────────────────────────────────
opt.updatetime     = 200
opt.timeoutlen     = 300
opt.lazyredraw     = false

-- ── Clipboard ────────────────────────────────────────────────────────────────
opt.clipboard      = "unnamedplus"   -- sync with system clipboard

-- ── Completion ────────────────────────────────────────────────────────────────
opt.completeopt    = { "menu", "menuone", "noselect" }

-- ── Folding (using treesitter) ────────────────────────────────────────────────
opt.foldmethod     = "expr"
opt.foldexpr       = "nvim_treesitter#foldexpr()"
opt.foldenable     = false          -- don't fold on open

-- LazyVim colorscheme
vim.g.lazyvim_colorscheme = "tokyonight"
