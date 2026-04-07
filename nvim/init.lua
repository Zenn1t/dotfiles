-- =========================================================
-- Neovim IDE-style config (single file)
-- For Neovim 0.11+
-- =========================================================

-- ===== lazy.nvim bootstrap =====
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ===== LEADER KEY =====
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ===== BASIC OPTIONS =====
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.completeopt = "menu,menuone,noinsert"

-- ===== PLUGINS =====
require("lazy").setup({

-- Training (learn vim commands)
{
  "Weyaaron/nvim-training",
  cmd = "Training",
},

{
  "nvzone/typr",
  dependencies = "nvzone/volt",
  cmd = { "Typr", "TyprStats" },
},

  -- Theme: zenbones (monochrome)
  --{
  --  "mcchrish/zenbones.nvim",
  --  dependencies = { "rktjmp/lush.nvim" },
  --  priority = 1000,
  --  config = function()
  --    vim.g.zenbones_darkness = "stark"
  --    vim.g.zenbones_solid_line_nr = true
  --    vim.g.zenbones_darken_comments = 45
  --    vim.opt.background = "dark"
  --    vim.cmd.colorscheme("zenbones")
  --  end,
  --},

-- Theme: minimal monochrome (black & white)
{
  "slugbyte/lackluster.nvim",
  priority = 1000,
  config = function()
    local lackluster = require("lackluster")
    lackluster.setup({
      tweak_background = { normal = "#000000" },
      tweak_color = {},
    })
    vim.cmd.colorscheme("lackluster-hack")

    -- Override для полного ЧБ
    vim.api.nvim_set_hl(0, "Normal", { fg = "#ffffff", bg = "#000000" })
    vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#ffffff", bg = "#000000" })
    vim.api.nvim_set_hl(0, "Comment", { fg = "#888888", italic = true })
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#444444" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffffff" })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#111111" })
    vim.api.nvim_set_hl(0, "Visual", { bg = "#222222" })
    vim.api.nvim_set_hl(0, "StatusLine", { fg = "#ffffff", bg = "#000000" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#666666", bg = "#000000" })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = "#222222" })
    vim.api.nvim_set_hl(0, "Pmenu", { fg = "#ffffff", bg = "#111111" })
    vim.api.nvim_set_hl(0, "PmenuSel", { fg = "#000000", bg = "#ffffff" })
  end,
},


  -- UI
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
      })
    end,
  },

  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 35 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
        git = { enable = true, ignore = false },
      })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Esc>"] = actions.close,
            },
          },
          file_ignore_patterns = { "node_modules", ".git/", "dist/", "__pycache__" },
        },
      })
    end,
  },

  -- LSP
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
    },
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    dependencies = { "rafamadriz/friendly-snippets" },
  },

  -- GitHub Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-y>",
            accept_word = "<C-Right>",
            accept_line = "<C-Down>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = { enabled = false },
        filetypes = {
          yaml = true,
          markdown = true,
          help = false,
          gitcommit = true,
          ["."] = false,
        },
      })
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({ check_ts = false })
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Comments (gcc to comment)
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Which key (shows keybindings)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },

})

-- ===== LSP SETUP =====
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "pyright",
    "ts_ls",
    "lua_ls",
    "html",
    "cssls",
    "jsonls",
    "clangd",        -- C/C++
    "rust_analyzer", -- Rust
  },
  automatic_installation = true,
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Diagnostic config
vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 4 },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "always" },
})

-- LSP keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
  end,
})

-- LSP server configurations using vim.lsp.config (Neovim 0.11+)

-- Python
vim.lsp.config("pyright", {
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
})

-- TypeScript/JavaScript
vim.lsp.config("ts_ls", {
  capabilities = capabilities,
  settings = {
    typescript = {
      suggest = { autoImports = true, completeFunctionCalls = true },
      updateImportsOnFileMove = { enabled = "always" },
    },
    javascript = {
      suggest = { autoImports = true, completeFunctionCalls = true },
      updateImportsOnFileMove = { enabled = "always" },
    },
  },
})

-- Lua
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

-- HTML, CSS, JSON
vim.lsp.config("html", { capabilities = capabilities })
vim.lsp.config("cssls", { capabilities = capabilities })
vim.lsp.config("jsonls", { capabilities = capabilities })

-- C/C++
vim.lsp.config("clangd", {
  capabilities = capabilities,
  cmd = { "clangd", "--background-index", "--clang-tidy" },
})

-- Rust
vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = { command = "clippy" },
      cargo = { allFeatures = true },
    },
  },
})

-- Enable all configured LSP servers
vim.lsp.enable({
  "pyright",
  "ts_ls",
  "lua_ls",
  "html",
  "cssls",
  "jsonls",
  "clangd",
  "rust_analyzer",
})

-- ===== COMPLETION =====
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

require("luasnip.loaders.from_vscode").lazy_load()

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      maxwidth = 50,
      ellipsis_char = "...",
      show_labelDetails = true,
    }),
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp", priority = 1000 },
    { name = "luasnip", priority = 750 },
    { name = "buffer", priority = 500, keyword_length = 3 },
    { name = "path", priority = 250 },
  }),

  experimental = { ghost_text = true },
})

-- Command line completion
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "buffer" } },
})

-- ===== KEYMAPS =====
local keymap = vim.keymap.set

-- General
keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })

-- Navigation
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })
keymap("n", "n", "nzzzv", { desc = "Next search centered" })
keymap("n", "N", "Nzzzv", { desc = "Prev search centered" })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Down window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Up window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Right window" })

-- Buffer navigation
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Move lines in visual mode
keymap("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
keymap("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

-- Better indenting
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Nvim-tree
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "File explorer" })

-- Telescope
local builtin = require("telescope.builtin")
keymap("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
keymap("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
keymap("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
keymap("n", "<leader>fh", builtin.help_tags, { desc = "Help" })
keymap("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
keymap("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Symbols" })
keymap("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
keymap("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
keymap("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })
keymap("n", "<leader>gs", builtin.git_status, { desc = "Git status" })

-- Splits
keymap("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
keymap("n", "<leader>sh", "<cmd>split<cr>", { desc = "Horizontal split" })

-- Terminal
keymap("n", "<leader>tt", "<cmd>terminal<cr>", { desc = "Terminal" })
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal" })

-- ===== AUTOCOMMANDS =====
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("HighlightYank", {}),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Remove trailing whitespace
autocmd("BufWritePre", {
  group = augroup("TrimWhitespace", {}),
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

-- Return to last position
autocmd("BufReadPost", {
  group = augroup("LastPosition", {}),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with q
autocmd("FileType", {
  group = augroup("CloseWithQ", {}),
  pattern = { "help", "lspinfo", "man", "notify", "qf", "checkhealth" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
