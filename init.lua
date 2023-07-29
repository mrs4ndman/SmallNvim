-- Dedicado a mis amigos Lin, Dai, Eva y Erika
-- Y a mis compañeros de la FP, Sergio, Iván, Ángel, Inma, David, Jose, ...

vim.g.mapleader = " "
vim.api.nvim_command("set clipboard+=unnamedplus")
vim.wo.cursorline = true
vim.wo.cursorlineopt = "both"
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.sidescroll = 1
vim.opt.sidescrolloff = 1
vim.opt.tabstop = 4
-- vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.updatetime = 50
vim.opt.timeoutlen = 500
vim.opt.signcolumn = "auto:1-4"
vim.o.foldenable = false
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true
vim.o.pumheight = 20
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
--
-- Plugin vim.g options
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_silent = 1
vim.g.netrw_fastbrowse = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_silent = 1
vim.g.netrw_fastbrowse = 0


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- Lazy.nvim bootstrap
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local plugins = {

  -- UI
  { -- Alpha dashboard
    "goolord/alpha-nvim",
    -- event = "VimEnter",
    dependencies = "nvim-tree/nvim-web-devicons",
    lazy = false,
    keys = { "<leader>sp", "<cmd>Alpha<CR>", desc = "Pantalla de inicio" },
    priority = 1000,
    opts = function(_, opts)
      opts = opts.dashboard
    end,
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      -- It uses almost the same format as the "date" command in Linux (man date for info)
      local time = os.date("%_k:%M - %a - %b %d")

      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function() require("lazy").show() end,
        })
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local v = vim.version()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = {
            "",
            "",
            "   WHERE TO, BOSS?",
            "",
            "" .. time,
            "",
            "    Neovim " .. v.major .. "." .. v.minor .. "." .. v.patch,
            "",
            "" .. stats.count .. " plugins | " .. ms .. " ms",
            "",
          }
          pcall(vim.cmd.AlphaRedraw)
        end,
      })

      if vim.api.nvim_exec("echo argc()", true) == "0" then
        -- Header section config
        dashboard.section.header.val = {
          "                                                                                    ",
          "                                      ／|__                                         ",
          "                                     (o o /                                         ",
          "                 ____________________ |.   ~. ______________________                ",
          "                                      じしf_,)ノ                                    ",
          "                                                                                    ",
          "                                   N E O V I M                                      ",
          "                                                                                    ",
        }

        dashboard.section.buttons.val = {
          dashboard.button("n", "Nuevo archivo", "<cmd>ene<CR>"),
          dashboard.button("e", "Explorador", ":Explore<CR>"),
          dashboard.button("v", "Recuperar sesión", ":SessionRestore<CR>"),
          dashboard.button("f", "Buscar archivo de proyecto", ":Telescope find_files<CR>"),
          -- dashboard.button("h", "Buscar en $HOME", ":cd $HOME | Telescope find_files<CR>"),
          dashboard.button("r", "Recientes", ":Telescope oldfiles<CR>"),
          dashboard.button("g", "Buscar patrón RegEx", ":Telescope live_grep<CR>"),
          dashboard.button("l", "Lazy", ":Lazy<CR>"),
          dashboard.button("c", "Colores", ":Themer<CR>"),
          dashboard.button("q", "Salir", ":qa<CR>"),
        }

        alpha.setup(dashboard.opts)

        vim.cmd([[ autocmd Filetype alpha setlocal nofoldenable signcolumn=no nonumber norelativenumber ]])
      end
    end,
  },
  {
    "willothy/nvim-cokeline",
    event = "VimEnter",
    dependencies = "nvim-tree/nvim-web-devicons",
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = "jcdickinson/wpm.nvim",
    event = "UIEnter",
  },
  {
    "NvChad/nvim-colorizer.lua",
    keys = { "<leader>cl", "<cmd>ColorizerToggle<CR>", desc = "Color picker toggle" },
    config = function()
      require("colorizer").setup({
        filetypes = { "css", "scss",
          "html",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "php",
          "markdown",
          "yaml",
        },
        user_default_options = {
          RRGGBBAA = true,
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          css_fn = true,
          mode = "virtualtext"
        },
      })
    end,
  },
  { "nvim-treesitter/nvim-treesitter-context", event = "BufReadPre", opts = { mode = "cursor" } },
  -- FIND BAR / STATUSLINE SUBSTITUTES
  -- COLORSCHEMES
  { "raddari/last-color.nvim" },
  {
    "rose-pine/neovim", -- the coolest color scheme B)
    lazy = true,
    name = "rose-pine",
    opts = {
      variant = "main",
      dark_variant = "main",
      bold_vert_split = true,
      disable_background = true,
      disable_float_background = true,
      disable_italics = true,
    },
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "night",
      light_style = "day",
      transparent = false,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      hide_inactive_statusline = false,
      dim_inactive = true,
      lualine_bold = true,
    }
  },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      background = { light = "latte", dark = "mocha" },
      transparent_background = false,
      show_end_of_buffer = false,
      dim_inactive = { enabled = false, shade = "dark", percentage = 0.2 },
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        fidget = true,
        gitsigns = true,
        harpoon = true,
        indent_blankline = { enabled = true, colored_indent_levels = false },
        illuminate = true,
        lsp_trouble = true,
        mason = true,
        navic = { enabled = true },
        noice = true,
        notify = true,
        nvimtree = true,
        telescope = true,
        treesitter_context = true,
        treesitter = true,
        which_key = true,
      },
    },
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    opts = {
      options = { transparent = false, dim_inactive = true, module_default = true },
    }
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
    opts = {
      plugins = { all = true },
      options = { highlight_inactive_windows = true, transparency = false },
    }
  },
  {
    "Mofiqul/dracula.nvim",
    lazy = true,
    opts = {
      show_end_of_buffer = false,
      transparent_bg = false,
      italic_comment = true,
    }
  },
  {
    "rmehri01/onenord.nvim",
    lazy = true,
    opts = {
      theme = "dark",
      borders = true,
      fade_nc = false,
      disable = { cursorline = true, eob_lines = true },
    }
  },
  {
    "maxmx03/fluoromachine.nvim",
    lazy = true,
    opts = { glow = false, theme = "retrowave" },
  },
  {
    "marko-cerovac/material.nvim",
    opts = {
      contrast = {
        terminal = true,
        sidebars = false,
        floating_windows = true,
        cursor_line = true,
        non_current_windows = true,
      },
      plugins = { "nvim-cmp", "nvim-navic", "telescope", "trouble", "which-key" },
      disable = {
        colored_cursor = false,
        borders = false,
        background = false,
        eob_lines = true,
      },
    },
    config = function() vim.g.material_style = "deep ocean" end
  },
  { "Mofiqul/vscode.nvim",          opts = { italic_comments = true } },
  {
    "tiagovla/tokyodark.nvim",
    config = function()
      vim.g.tokyodark_enable_italic = false
      vim.g.tokyodark_enable_italic_comment = true
    end
  },
  { "blazkowolf/gruber-darker.nvim" },
  {
    "projekt0n/github-nvim-theme",
    config = function()
      require("github-theme").setup({
        options = {
          hide_end_of_buffer = true,
          dim_inactive = true,
          styles = { comments = "italic", keywords = "bold", types = "italic,bold" }
        }
      })
    end
  },
  {
    "NTBBloodbath/doom-one.nvim",
    config = function()
      vim.g.doom_one_terminal_colors = true
      vim.g.doom_one_italic_comments = true
      vim.g.doom_one_enable_treesitter = true
      vim.g.doom_one_diagnostics_text_color = true
      -- Integrations
      vim.g.doom_one_plugin_telescope = true

      vim.g.doom_one_plugin_whichkey = true
      vim.g.doom_one_plugin_vim_illuminate = true
    end,
  },
  { "lunarvim/horizon.nvim" },
  {
    "shaunsingh/nord.nvim",
    lazy = true,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_disable_background = false
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = true
    end,
  },
  {
    "rafamadriz/neon",
    lazy = true,
    config = function()
      vim.g.neon_style = "doom"
      vim.g.neon_italic_comment = true
      vim.g.neon_bold = true
      vim.g.neon_transparent = false
    end,
  },
  { "nyoom-engineering/oxocarbon.nvim" },
  { "AlexvZyl/nordic.nvim" },
  { "zootedb0t/citruszest.nvim" },
  { "nyngwang/nvimgelion" },
  { "JoosepAlviste/palenightfall.nvim" },
  {
    "kvrohit/rasmus.nvim",
    config = function()
      vim.g.rasmus_italic_comments = true
      vim.g.rasmus_bold_keywords = true
      vim.g.rasmus_bold_functions = true
      vim.g.rasmus_variant = "dark"
    end
  },
  {
    "stevearc/dressing.nvim",
    -- event = "VimEnter",
    opts = {
      input = {
        enabled = true,
        title_pos = "center",
        start_in_insert = true,
        border = "rounded",
        relative = "cursor",
        win_options = {
          winblend = 0,
          wrap = true,
        },
        mappings = {
          n = { ["<C-c>"] = "Close", ["<Esc>"] = "Close", ["<CR>"] = "Confirm" },
          i = {
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
            ["<C-p>"] = "HistoryPrev",
            ["<C-n>"] = "HistoryNext",
          },
        },
      },
      select = {
        enabled = true,
        trim_prompt = true,
        win_options = { winblend = 0, wrap = true },
        mappings = {
          ["<Esc>"] = "Close",
          ["<C-c>"] = "Close",
          ["<CR>"] = "Confirm",
        },
      },
    },
  },
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("mini.indentscope").setup({
        opts = {
          draw = {
            delay = 75,
            priority = 1,
          },
          mappings = {
            object_scope = "ii",
            object_scope_with_borer = "ai",
            goto_top = "[i",
            goto_bottom = "]i",
          },
          options = {
            border = "both",
            indent_at_cursor = true,
          },
          symbol = "╎",
        }
      })
    end
  },
  {
    "airblade/vim-matchquote",
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "folke/noice.nvim",
    -- event = "VeryLazy",
    keys = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      lsp = {
        progress = { enabled = true, view = "mini" },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = false,
      },
      routes = { view = "notify", filter = { event = "msg_showmode" } },
    },
  },
  {
    "rcarriga/nvim-notify",
    event = "VimEnter",
    opts = {
      stages = "static",
      timeout = 1500,
      render = "compact",
      max_height = function() return math.floor(vim.o.lines * 0.40) end,
      max_width = function() return math.floor(vim.o.columns * 0.70) end,
    },
    config = function() vim.notify = require("notify") end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufNewFile", "BufReadPost" },
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")

      vim.g.rainbow_delimiters = {
        strategy = { [""] = rainbow_delimiters.strategy["global"], vim = rainbow_delimiters.strategy["local"] },
        query = { [""] = "rainbow-delimiters", lua = "rainbow-blocks" },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },
  { "alec-gibson/nvim-tetris", cmd = "Tetris" },





  -- TOOLS / UTILS
  { -- Session management
    "rmagatti/auto-session",
    event = "VimEnter",
    keys = {
      { "<leader>sd", "<cmd>SessionDelete<CR>", desc = "Borrar la sesión actual" },
      { "<leader>sr", "<cmd>SessionRestore<CR>", desc = "Recuperar la sesión para el directorio actual" },
      { "<leader>ss", "<cmd>SessionSave<CR>", desc = "Guardar la sesión actual (inicia autoguardado)" },
    },
    cmd = { "SessionRestore", "SessionSave", "SessionDelete" },
    opts = {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/install", "~/Downloads" },
      auto_session_create_enabled = false,
      auto_restore_enabled = false,
      auto_save_enabled = true,
    }
  },
  -- AUTO-PAIRING SYMBOLS
  { "windwp/nvim-autopairs",   event = { "BufReadPost", "BufNewFile" }, config = true },
  -- TABBING OUT OF SAID SYMBOLS
  {
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- parsing to the end of time
    opts = {
      tabkey = "<Tab>",
      backwards_tabkey = "<S-Tab>",
      act_as_tab = true,
      act_as_shift_tab = false,
      enable_backwards = true,
      completion = true,
      tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
        { open = "<", close = ">" },
        -- {open = ':', close = ':'} -- Rust maybe?
      },
      ignore_beginning = true,
      exclude = {},
    },
  },
  -- IDE-LIKE BREADCRUMBS
  { "Bekaboo/dropbar.nvim", lazy = false },
  {
    "ggandor/leap.nvim",
    lazy = false,
    opts = {
      max_phase_one_targets = 0,
      case_sensitive = true,
      max_highlighted_traversal_targets = 15,
    }
  },
  {
    "ggandor/flit.nvim",
    lazy = false,
    opts = {
      keys = { f = "f", F = "F", t = "t", T = "T" },
      labeled_modes = "v",
      multiline = true,
      opts = {}
    }
  },
  {
    "f-person/git-blame.nvim",
    keys = {
      { "<leader>gb",  "<cmd>GitBlameToggle<CR>",        desc = "Blame Toggle" },
      { "<leader>go",  "<cmd>GitBlameOpenCommitURL<CR>", desc = "Blame - Abrir URL del commit" },
      { "<leader>gO",  "<cmd>GitBlameOpenFileURL<CR>",   desc = "Blame - Abrir URL del archivo" },
      { "<leader>gcu", "<cmd>GitBlameCopyCommitURL<CR>", desc = "Blame - Copiar URL del commit" },
      { "<leader>gcf", "<cmd>GitBlameCopyFileURL<CR>",   desc = "Blame - Copiarl URL del archivo" },
      { "<leader>gch", "<cmd>GitBlameCopySHA<CR>",       desc = "Blame - Copiar hash" },
    },
    config = function()
      vim.g.gitblame_enabled = 0
      vim.g.gitblame_message_when_not_committed = "Sin subir?"
    end
  },
  {
    "ruifm/gitlinker.nvim",
    keys = { { "<leader>gy", mode = { "n", "v" }, "Crear enlace de código" } },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("gitlinker").setup() end
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { hl = "DiffAdd", text = "+", numhl = "GitSignsAddNr" },
        change = { hl = "DiffChange", text = "󰇙", numhl = "GitSignsChangeNr" },
        delete = { hl = "DiffDelete", text = "_", show_count = true, numhl = "GitSignsDeleteNr" },
        topdelete = { hl = "DiffDelete", text = "‾", show_count = true, numhl = "GitSignsDeleteNr" },
        changedelete = { hl = "DiffChange", text = "~", show_count = true, numhl = "GitSignsChangeNr" },
      },
      count_chars = {
        [1] = "",
        [2] = "₂",
        [3] = "₃",
        [4] = "₄",
        [5] = "₅",
        [6] = "₆",
        [7] = "₇",
        [8] = "₈",
        [9] = "₉",
        ["+"] = "󰎿",
      },
      numhl = true,
      attach_to_untracked = true,
      trouble = false,
    },

    config = function(_, opts)
      require("gitsigns").setup(opts)
      -- require("scrollbar.handlers.gitsigns").setup()
    end,
  },
  {
    "ThePrimeagen/harpoon", -- Reeling those files in
    keys = {
      { "<leader>1", desc = "Harpoon 1" },
      { "<leader>2", desc = "Harpoon 2" },
      { "<leader>3", desc = "Harpoon 3" },
      { "<leader>4", desc = "Harpoon 4" },
      { "<leader>5", desc = "Harpoon 5" },
      { "<leader>6", desc = "Harpoon 6" },
      { "<leader>7", desc = "Harpoon 7" },
      { "<leader>8", desc = "Harpoon 8" },
      { "<leader>9", desc = "Harpoon 9" },
      { "<leader>0", desc = "Harpoon 10" },
      { "<leader>a", desc = "Añadir a Harpoon" },
      { "<leader>h", desc = "Menú de Harpoon" },
      { "<leader>kn", desc = "Harpoon siguiente" },
      { "<leader>kp", desc = "Harpoon anterior" },
      { "<leader>t1", desc = "Harpoon terminal 1" },
      { "<leader>t2", desc = "Harpoon terminal 2" },
      { "<leader>t3", desc = "Harpoon terminal 3" },
      { "<leader>t4", desc = "Harpoon terminal 4" },
    },
    opts = {
      global_settings = { save_on_toggle = true, save_on_change = true, mark_branch = false }
    },
    config = function(_, opts)
      require("harpoon").setup(opts)
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")
      local term = require("harpoon.term")

      vim.keymap.set("n", "<leader>a", mark.add_file)
      vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu)

      vim.keymap.set("n", "<leader>kn", ui.nav_next)
      vim.keymap.set("n", "<leader>kp", ui.nav_prev)

      vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end, { silent = true })
      vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end, { silent = true })
      vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end, { silent = true })
      vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end, { silent = true })
      vim.keymap.set("n", "<leader>5", function() ui.nav_file(5) end, { silent = true })
      vim.keymap.set("n", "<leader>6", function() ui.nav_file(6) end, { silent = true })
      vim.keymap.set("n", "<leader>7", function() ui.nav_file(7) end, { silent = true })
      vim.keymap.set("n", "<leader>8", function() ui.nav_file(8) end, { silent = true })
      vim.keymap.set("n", "<leader>9", function() ui.nav_file(9) end, { silent = true })
      vim.keymap.set("n", "<leader>0", function() ui.nav_file(0) end, { silent = true })
      vim.keymap.set("n", "<leader>t1", function() term.gotoTerminal(1) end, { silent = true })
      vim.keymap.set("n", "<leader>t2", function() term.gotoTerminal(2) end, { silent = true })
      vim.keymap.set("n", "<leader>t3", function() term.gotoTerminal(3) end, { silent = true })
      vim.keymap.set("n", "<leader>t4", function() term.gotoTerminal(4) end, { silent = true })
    end,
  },
  { "nacro90/numb.nvim",    event = "VimEnter", config = function() require("numb").setup() end },
  {
    "chrisgrieser/nvim-genghis",
    dependencies = "stevearc/dressing.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.keymap.set("n", "<leader>fp", require("genghis").copyFilepath, { desc = "Yank kurrent filepath" })
      vim.keymap.set("n", "<leader>fn", require("genghis").copyFilename, { desc = "Yank current filename" })
      -- vim.keymap.set("<leader>cx", { require("genghis").chmodx, desc = "Make current file executable" },
      vim.keymap.set("n", "<leader>fr", require("genghis").renameFile, { desc = "Rename current file" })
      vim.keymap.set("n", "<leader>fm", require("genghis").moveAndRenameFile,
        { desc = "Move and rename current filepath" })
      vim.keymap.set("n", "<leader>fc", require("genghis").createNewFile, { desc = "Create new file" })
      vim.keymap.set("n", "<leader>fd", require("genghis").duplicateFile, { desc = "Duplicate current file" })
      vim.keymap.set("n", "<leader>ft", function() require("genghis").trashFile({ trashLocation = "$HOME/.Trash" }) end,
        { desc = "Trash current file" })
    end
  },
  {
    "ethanholz/nvim-lastplace",
    event = "VimEnter",
    config = function() require("nvim-lastplace") .setup { } end,
  },
  {
    "kylechui/nvim-surround",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      keymaps = { normal = "ys", delete = "ds", visual = "S", visual_line = "gS", change = "cs", change_line = "cS" },
    }
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "numToStr/Comment.nvim" },
    keys = {
      -- TELESCOPE
      { "<leader>tf", "<cmd>Telescope find_files<CR>",  desc = "Buscar archivos" },
      { "<leader>tb", "<cmd>Telescope buffers<CR>",     desc = "Lista buffers" },
      { "<leader>tr", "<cmd>Telescope oldfiles<CR>",    desc = "Archivos recientes" },
      { "<leader>vh", "<cmd>Telescope help_tags<CR>",   desc = "Tags de ayuda" },
      { "<leader>sg", "<cmd>Telescope grep_string<CR>", desc = "Buscar un string de texto" },
      {
        "<leader>ts",
        function() require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") }) end,
        desc = "Buscar dentro de archivos"
      },
    },
    config = function()
      require("telescope").setup {
        pickers = {
          colorscheme = { enable_preview = true },
          find_files = {
            find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git", "--strip-cwd-prefix" },
            theme = "ivy",
          },
        },
        defaults = {
          theme = "dropdown",
          vimgrep_arguments = {
            "rg",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
          },
          sort_mru = true,
          sorting_strategy = "ascending",
          color_devicons = true,
          layout_strategy = "horizontal",
          layout_config = {
            prompt_position = "top",
            horizontal = { width_padding = 0.04, height_padding = 0.1 },
            vertical = { width_padding = 0.05, height_padding = 1 },
          },
          border = true,
          prompt_prefix = "   ",
          hl_result_eol = false,
          -- results_title = "",
          wrap_results = true,
          hidden = true,
          mappings = {
            i = {
              ["<C-n>"] = require("telescope.actions").preview_scrolling_down,
              ["<C-p>"] = require("telescope.actions").preview_scrolling_up,
              ["<C-h>"] = require("telescope.actions").preview_scrolling_left,
              ["<C-l>"] = require("telescope.actions").preview_scrolling_right,
              -- ["<M-p>"] = action_layout.toggle_preview,
              ["<C-j>"] = require("telescope.actions").move_selection_next,
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
            },
            n = {
              -- ["<M-p>"] = action_layout.toggle_preview,
              ["<C-n>"] = require("telescope.actions").preview_scrolling_down,
              ["<C-p>"] = require("telescope.actions").preview_scrolling_up,
              ["<M-s>"] = require("telescope.actions").file_split,
              ["<M-v>"] = require("telescope.actions").file_vsplit,
            },
          },
        },

      }
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function() require("Comment").setup() end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    -- build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-context", "JoosepAlviste/nvim-ts-context-commentstring",
      "windwp/nvim-ts-autotag" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "astro",
          "c",
          "cpp",
          "css",
          "gitcommit",
          "gitignore",
          "go",
          "html",
          "java",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "php",
          "rust",
          "tsx",
          "typescript",
          "toml",
          "vim",
          "vimdoc",
          "yaml",
        },
        sync_install = false,
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true },
        context_commentstring = { enable = true, enable_autocmd = false },
        autotag = { enable = true },
      })
    end
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Undo-tree Toggle" },
    },
  },
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
  },
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      key_labels = {
        ["<leader>"] = "Space"
      },
      icons = {
        group = "",
      },
      window = {
        border = "single",
        margin = { 0, 4, 1, 1 },
        padding = { 0, 4, 2, 1 },
      },
      layout = {
        spacing = 5,
        align = "center",
      }
    }
  },




  -- LSP ZONE
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "folke/neodev.nvim",
      "jubnzv/virtual-types.nvim",
      "folke/lsp-colors.nvim",
      "williamboman/mason.nvim",
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = { "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" },
        opts = { lsp = { auto_attach = true } }
      },
      {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
          require("lsp_lines").setup()
          -- LSP_LINES TOGGLE
          vim.keymap.set(
            { "n", "v" },
            "<leader>vl",
            require("lsp_lines").toggle,
            { desc = "Toggle LSP line diagnostics" }
          )
        end
      }
    },
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = { ui = { icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } } },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    cmd = { "LspInstall", "LspUninstall" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          -- Language servers automagically installed
          "lua_ls",
          "vimls",
          "marksman",
          "clangd",
          "neocmake",
          "html",
          -- 'hls',
          "cssls",
          "eslint",
          "tsserver",
          "bashls",
          "ansiblels",
          "dockerls",
          "yamlls",
          "ruff_lsp",
          "rust_analyzer",
          "ruby_ls",
          "pylsp",
          "gopls",
          "jdtls",
          "jsonls",
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "amarakon/nvim-cmp-buffer-lines",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-nvim-lsp",
      "ray-x/cmp-treesitter",
      -- {
      --   "jcdickinson/codeium.nvim",
      --   dependencies = "nvim-lua/plenary.nvim",
      --   commit = "b1ff0d6c993e3d87a4362d2ccd6c660f7444599f",
      --   config = true,
      -- },
      -- {
      --   "tzachar/cmp-tabnine",
      --   build = "./install.sh",
      --   config = function()
      --     local tabnine = require("cmp_tabnine.config")
      --     tabnine:setup({
      --       max_lines = 1000,
      --       max_num_results = 4,
      --       sort = true,
      --       run_on_every_keystroke = true,
      --       snippet_placeholder = "**",
      --       show_prediction_strength = false,
      --     })
      --   end
      -- },
      {
        "L3MON4D3/LuaSnip",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      "buschco/nvim-cmp-ts-tag-close",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      -- CMP SETUP
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      local kind_icons = {
        Class = "󰠱",
        Color = "󰸌",
        Constant = "󰏿",
        Constructor = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "󰜢",
        File = "󰈙",
        Folder = "󰉋",
        Function = "󰊕",
        Interface = "",
        Keyword = "󰌋",
        Method = "󰆧",
        Module = "",
        Operator = "󰆕",
        Property = "",
        Reference = "",
        Snippet = " ",
        Struct = "",
        Text = "",
        TypeParameter = "󰅲",
        Unit = "",
        Value = "󰎠",
        Variable = "󰀫",
        buffer = "󰦨",
        path = "/",
        nvim_lsp = "λ",
        luasnip = "⋗",
        vsnip = "V",
        nvim_lua = "Π",
        Codeium = "C",
        Tabnine = "T"
      }

      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

      cmp.setup({
        preselect = "item",
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        config = {
          context = {
            in_treesitter_capture = true,
          },
        },
        window = {
          completion = cmp.config.window.bordered({
            border = "single",
            side_padding = 1,
            col_offset = -3,
            max_width = 80,
          }),
          documentation = cmp.config.window.bordered({
            max_width = 50,
          }),
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        formatting = {
          -- changing the order of fields so the icon is the first
          fields = { "menu", "abbr", "kind" },

          -- here is where the change happens
          format = function(entry, vim_item)
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            vim_item.menu = ({
              nvim_lsp = "λ",
              luasnip = "⋗",
              nvim_lua = "Π",
              codeium = "󱍋",
              cmp_tabnine = "󱍋",
              buffer = "󰦨",
              path = "/",
              vsnip = "V",
            })[entry.source.name]

            if entry.source.name == "text" then
              vim_item.dup = 0
            end
            if entry.source.name == "nvim_lsp" then
              vim_item.dup = 0
            end

            function Trim(text)
              local max = 40
              if text and text:len() > max then
                text = text:sub(1, max) .. "···"
              end
              return text
            end

            return vim_item
          end,
        },
        sorting = {
          comparators = {
            cmp.config.compare.locality,
            cmp.config.compare.offset,
            cmp.config.compare.kind,
            cmp.config.compare.recently_used,
            cmp.config.compare.exact,
            cmp.config.compare.length,
            cmp.config.compare.order,
            function(entry1, entry2)
              local result = vim.stricmp(entry1.completion_item.label, entry2.completion_item.label)
              if result < 0 then
                return true
              end
            end,
          },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-c>"] = cmp.mapping.abort(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Tab>"] = vim.NIL,
          ["<S-Tab>"] = vim.NIL,
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "treesitter" },
          { name = "luasnip" },
          { name = "path" },
          { name = "nvim_lua" },
          { name = "treesitter" }, -- treesitter integration
          { name = "codeium" },
          { name = "cmp_tabnine" },
          -- { name = "buffer-lines" },
          { name = "crates" }, -- crates.nvim plugin
          { name = "vsnip" },
          -- { name = 'cmdline' },
          {
            name = "buffer",
            options = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
          },
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
      })
    end
  },
  {
    "rmagatti/goto-preview",
    keys = {
      ["gp"] = { name = "LSP Previews" },
      { "gpd", desc = "Preview Definitions" },
      { "gpt", desc = "Preview Type Definitions" },
      { "gpi", desc = "Preview Implementations" },
      { "gpr", desc = "Preview References" },
      { "gP",  desc = "Preview Close All" },
    },
    config = function()
      require("goto-preview").setup {
        width = 80,
        height = 30,
        default_mappings = true,
        opacity = 5,
        resizing_mappings = true,
        references = { telescope = require("telescope.themes").get_ivy() },
        focus_on_open = true,
        force_close = true,
        stack_floating_preview_windows = true,
        preview_window_title = { enable = true, position = "right" },
      }
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    keys = { { "<leader>nt", "<cmd>Neotree<CR>", desc = "Neo-Tree" } },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      -- enable_diagnostics = true,
      default_component_configs = {
        container = { enable_character_fade = true },
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "|",
          with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = { folder_closed = "", folder_open = "", folder_empty = "󰜌" },
        modified = { symbol = "[+]", highlight = "NeoTreeModified" },
        name = { trailing_slash = false, use_git_status_colors = true, highlight = "NeoTreeFileName" },
        git_status = {
          symbols = {
            added = "+",
            modified = "",
            deleted = "✖",
            renamed = "󰁕",
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
        },
      },
      commands = {},
      window = {
        position = "left",
        width = 30,
        mapping_options = { noremap = true, nowait = true },
        mappings = { ["<C-c>"] = "close_window", ["<Esc>"] = "close_window" },
      },
      nesting_rulse = {},
      filesystem = {
        filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = false },
        follow_current_file = true,
        group_empty_dirs = true,
        hijack_netrw_behavior = "disabled",
      },
      buffers = { follow_current_file = true, group_empty_dirs = true, show_unloaded = true },
    },
  },
  { "folke/trouble.nvim",       cmd = { "TroubleToggle", "Trouble" }, opts = { use_diagnostic_signs = true } },
}

local opts = {
  defaults = { lazy = true, version = false },
  checker = { enabled = true },
  performance = {
    cache = { enabled = true },
    rtp = { disabled_plugins = { "man", "gzip", "tarPlugin", "tutor", "zipPlugin" } }
  },
}

require("lazy").setup(plugins, opts)
--
-- colorizer
local telescope_actions = require("telescope.actions")
local telescope_action_state = require("telescope.actions.state")
local telescope_pickers = require("telescope.pickers")
local telescope_finders = require("telescope.finders")
local telescope_sorters = require("telescope.sorters")

local function themer_enter(prompt_bufnr)
  local selected = telescope_action_state.get_selected_entry()
  -- print(vim.inspect(selected))
  local cmd = "colorscheme " .. selected[1]
  vim.cmd(cmd)
  telescope_actions.close(prompt_bufnr)
end

local function themer_next_color(prompt_bufnr)
  telescope_actions.move_selection_next(prompt_bufnr)
  local selected = telescope_action_state.get_selected_entry()
  local cmd = "colorscheme " .. selected[1]
  vim.cmd(cmd)
end

local function themer_prev_color(prompt_bufnr)
  telescope_actions.move_selection_previous(prompt_bufnr)
  local selected = telescope_action_state.get_selected_entry()
  local cmd = "colorscheme " .. selected[1]
  vim.cmd(cmd)
end

local themer_opts = {
  prompt_title = "Which color?",
  layout_strategy = "vertical",
  layout_config = { height = 0.45, width = 0.25, prompt_position = "top" },
  sorting_strategy = "ascending",
  finder = telescope_finders.new_table({
    "rose-pine",
    "tokyonight",
    "oxocarbon",
    "vscode",
    "citruszest",
    "doom-one",
    "tokyodark",
    "nvimgelion",
    "palenightfall",
    "rasmus",
    "onedark_dark",
    "catppuccin",
    "github_dark_high_contrast",
    "carbonfox",
    "material",
    "gruber-darker",
    "fluoromachine",
    "nord",
    "nordic",
    "dracula",
    "onenord",
    "nightfox",
    "nordfox",
    "neon",
    "tokyonight-moon",
  }),
  sorter = telescope_sorters.get_generic_fuzzy_sorter({}),
  ---@diagnostic disable-next-line: unused-local
  attach_mappings = function(prompt_bufnr, map)
    map("i", "<CR>", themer_enter)
    map("i", "<C-k>", themer_prev_color)
    map("i", "<C-j>", themer_next_color)
    return true
  end,
}

local themer_colors = telescope_pickers.new(themer_opts)

vim.api.nvim_create_user_command("Themer", function() themer_colors:find() end, {})

-- last-color plugin
local theme = require("last-color").recall() or "rose-pine"
vim.cmd(("colorscheme %s"):format(theme))

-- LUALINE AND COKELINE CONFIGS
--
-- Cokeline custom config:

local get_hex = require("cokeline/utils").get_hex
local mappings = require("cokeline/mappings")

local comments_fg = get_hex("Comment", "fg")
local errors_fg = get_hex("DiagnosticError", "fg")
local warnings_fg = get_hex("DiagnosticWarn", "fg")

local red = vim.g.terminal_color_1
local yellow = vim.g.terminal_color_3

local components = {
  space = { text = " ", truncation = { priority = 1 } },
  two_spaces = { text = "  ", truncation = { priority = 1 } },
  separator = { text = function(buffer) return buffer.index ~= 1 and "▏" or "" end, truncation = { priority = 1 } },
  devicon = {
    text = function(buffer)
      return (mappings.is_picking_focus() or mappings.is_picking_close()) and buffer.pick_letter .. " "
          or buffer.devicon.icon
    end,
    fg = function(buffer)
      return (mappings.is_picking_focus() and yellow) or (mappings.is_picking_close() and red) or buffer.devicon.color
    end,
    style = function(_)
      return (mappings.is_picking_focus() or mappings.is_picking_close()) and "italic,bold" or nil
    end,
    truncation = { priority = 1 },
  },

  index = { text = function(buffer) return buffer.index .. " 󰁎 " end, truncation = { priority = 1 } },

  unique_prefix = {
    text = function(buffer) return buffer.unique_prefix end,
    fg = comments_fg,
    style = "italic",
    truncation = { priority = 3, direction = "left" },
  },

  filename = {
    text = function(buffer) return buffer.filename end,
    style = function(buffer)
      return ((buffer.is_focused and buffer.diagnostics.errors ~= 0) and "bold,underline")
          or (buffer.is_focused and "bold")
          or (buffer.diagnostics.errors ~= 0 and "underline")
          or nil
    end,
    truncation = { priority = 2, direction = "left" },
  },

  diagnostics = {
    text = function(buffer)
      return (buffer.diagnostics.errors ~= 0 and " 󰅚 " .. buffer.diagnostics.errors)
          or (buffer.diagnostics.warnings ~= 0 and "  " .. buffer.diagnostics.warnings)
          or ""
    end,
    fg = function(buffer)
      return (buffer.diagnostics.errors ~= 0 and errors_fg) or
          (buffer.diagnostics.warnings ~= 0 and warnings_fg) or nil
    end,
    truncation = { priority = 1 },
  },

  close_or_unsaved = {
    text = function(buffer) return buffer.is_modified and "●" or "󰅖" end,
    ---@diagnostic disable-next-line: undefined-global
    fg = function(buffer) return buffer.is_modified and green or nil end,
    delete_buffer_on_left_click = true,
    truncation = { priority = 1 },
  },
}

require("cokeline").setup({
  show_if_buffers_are_at_least = 2, -- It allows to hide it when in a single buffer
  buffers = {
    focus_on_delete = "next",
    filter_valid = function(buffer) return buffer.filetype ~= "netrw" end,
    filter_visible = function(buffer) return buffer.filename ~= "oil://" end,
    new_buffers_position = "next",
  },
  rendering = { max_buffer_width = 30 },
  pick = { use_filename = false },
  default_hl = {
    fg = function(buffer) return buffer.is_focused and get_hex("Normal", "fg") or get_hex("Comment", "fg") end,
    bg = get_hex("Background", "bg"),
  },
  components = {
    components.space,
    components.separator,
    components.space,
    components.unique_prefix,
    components.index,
    components.devicon,
    components.filename,
    components.diagnostics,
    components.two_spaces,
    components.close_or_unsaved,
    components.space,
  },
})

-- Eviline config for lualine, modified by MrSandman
-- Author: shadmansaleh
-- Credit: glepnir
--
-- Slightly modified GeoMetro
-- (if you get it, you get it)
local lualine = require("lualine")
-- Color table for highlights
-- stylua: ignore
local colors = {
  bg          = '#202328',
  fg          = '#bbc2cf',
  yellow      = '#ECBE7B',
  cyan        = '#008080',
  pink        = '#FF00FF',
  darkblue    = '#0037AA',
  turquoise   = '#00CCCC',
  green       = '#98be65',
  lime        = '#00CC00',
  orange      = '#FF8800',
  sorange     = '#FF6600',
  violet      = '#a9a1e1',
  magenta     = '#c678dd',
  blue        = '#51afef',
  red         = '#FF0000',
  ultraviolet = '#CC0099',
}

local conditions = {
  buffer_not_empty = function() return vim.fn.empty(vim.fn.expand("%:t")) ~= 1 end,
  hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = "",
    section_separators = "",
    theme = "auto",
    globalstatus = true,
    disabled_filetypes = { statusline = { "dashboard", "alpha" }, winbar = { "help", "alpha", "lazy", "Trouble" } },
  },
  -- these are to remove the defaults
  sections = { lualine_a = {}, lualine_b = {}, lualine_c = {}, lualine_x = {}, lualine_y = {}, lualine_z = {} },
  winbar = { lualine_a = {}, lualine_b = {}, lualine_c = {}, lualine_x = {}, lualine_y = {}, lualine_z = {} },
  -- these are to remove the defaults
  inactive_sections = { lualine_a = {}, lualine_b = {}, lualine_y = {}, lualine_z = {}, lualine_c = {}, lualine_x = {} },
  extensions = { "lazy" },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component) table.insert(config.sections.lualine_c, component) end

-- Inserts a component in lualine_c at right section on winbar
local function ins_winb_left(component) table.insert(config.winbar.lualine_b, component) end

-- Inserts a component in lualine_x at right section on winbar
local function ins_winb_right(component) table.insert(config.winbar.lualine_x, component) end

-- Inserts a component in lualine_x at right section
local function ins_right(component) table.insert(config.sections.lualine_x, component) end


ins_left({ function() return "" end, color = { fg = colors.lime }, padding = { left = 1, right = 1 } })

ins_left({
  -- mode component
  function() return "" end,
  color = function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.pink,
      i = colors.turquoise,
      v = colors.orange,
      [""] = colors.blue,
      V = colors.sorange,
      c = colors.green,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [""] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ["r?"] = colors.cyan,
      ["!"] = colors.red,
      t = colors.red,
    }
    return { fg = mode_color[vim.fn.mode()] }
  end,
  padding = { left = 0, right = 1 },
})

ins_left({ "filename", cond = conditions.buffer_not_empty, color = { fg = colors.red, gui = "bold" }, path = 0 })

ins_left({
  -- git branch icon & name
  "branch",
  icon = "",
  color = { fg = colors.orange, gui = "bold" },
  cond = conditions.hide_in_width,
})

ins_left({
  function() return require("noice").api.status.command.get() end,
  cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
  padding = { left = 1, right = 1 },
  color = { fg = "violet", gui = "bold" },
})

ins_left({
  require("noice").api.statusline.mode.get,
  cond = require("noice").api.statusline.mode.has,
  color = { fg = "violet", gui = "bold" },
})

ins_left { require("lazy.status").updates, cond = require("lazy.status").has_updates }

ins_left({ function() return "%=" end })

ins_left({
  -- Lsp server name
  function()
    local msg = "Ninguno"

    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then return msg end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then return client.name end
    end
    return msg
  end,
  icon = "",
  color = { fg = "cyan", gui = "bold" },
  cond = conditions.hide_in_width,
  padding = { left = 0, right = 0 },
})

ins_left({
  -- filetype / language component
  "filetype",
  colored = true,
  icon_only = false,
  icon = { align = "left" },
  color = { fg = "cyan", gui = "bold" },
  padding = { left = 1, right = 0 },
  cond = conditions.hide_in_width,
})

-- filesize component
ins_left({
  "filesize",
  cond = conditions.buffer_not_empty,
  color = { fg = colors.cyan },
  padding = { left = 1, right = 0 }
})

-- cursor location in file component
ins_left({ "location", color = { fg = colors.lime, gui = "bold" }, padding = { left = 1, right = 0 } })

-- same as location but in % form
ins_left({ "progress", color = { fg = colors.ultraviolet, gui = "bold" }, padding = { left = 1, right = 0 } })
ins_left({ function() return "%=" end })

ins_right({
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = { error = " ", warn = " ", info = " " },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan }
  },

})

ins_right({
  -- Is it me or the symbol for modified us really weird
  "diff",
  symbols = { added = " ", modified = " ", removed = " " },
  diff_color = { added = { fg = colors.lime }, modified = { fg = colors.orange }, removed = { fg = colors.red } },
  cond = conditions.hide_in_width,
})

local wpm = require("wpm")
ins_right({ wpm.wpm, "wpm", color = { fg = colors.pink, gui = "bold" }, padding = { left = 0, right = 1 } })

ins_right({
  "fileformat",
  fmt = string.upper,
  icons_enabled = true,
  color = { fg = colors.white, gui = "bold" },
  padding = { left = 1, right = 2 },
})

-- Now don't forget to initialize lualine
lualine.setup(config)


-- LSP Explicit config
local navbuddy = require("nvim-navbuddy")
local M = {}
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  },
}
M.on_attach = function(client, bufnr)
  navbuddy.attach(client, bufnr)
  require("virtualtypes").on_attach()
end
-- First, Native LSP
local lspconfig = require("lspconfig")
require("lspconfig").lua_ls.setup({
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  settings = {
    Lua = { diagnostics = { globals = { "vim" } } },
  },
})
require("lspconfig").rust_analyzer.setup({
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  settings = {
    ["rust-analyzer"] = { diagnostics = { enable = false } },
  },
})
lspconfig.clangd.setup({
  on_attach = M.on_attach,
  capabilities = M.capabilities,
})
lspconfig.astro.setup({})
lspconfig.pylsp.setup({})
lspconfig.vimls.setup({})
lspconfig.marksman.setup({})
lspconfig.ocamlls.setup({})
lspconfig.neocmake.setup({})
lspconfig.html.setup({})
-- lspconfig.emmet_ls.setup({})
lspconfig.cssls.setup({})
lspconfig.gopls.setup({})
lspconfig.eslint.setup({})
lspconfig.tsserver.setup({})
lspconfig.bashls.setup({})
lspconfig.ansiblels.setup({})
lspconfig.yamlls.setup({})
lspconfig.ruby_ls.setup({})
-- lspconfig.jdtls.setup {}
--
-- LSP Attach keybinds
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "[G]o to [D]efinition" })
    vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { desc = "[G]o to [T]ype definition" })
    vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "[G]o to [I]mplementation" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover info" })
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, { desc = "Workspace Symbol" })
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { desc = "Diagnostic Float on current word" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
    vim.keymap.set("n", "d]", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
    vim.keymap.set({ "n", "v" }, "<leader>vca", vim.lsp.buf.code_action, { desc = "View code action" })
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, { desc = "Show Variable References" })
    vim.keymap.set({ "n", "v" }, "<leader>vrn", vim.lsp.buf.rename, { desc = "Rename variable with LSP" })
    vim.keymap.set("n", "<leader>ff", function()
      vim.lsp.buf.format({ async = true })
    end, { desc = "Format current buffer / file" })
    vim.keymap.set("i", "<C-q>", vim.lsp.buf.signature_help, { desc = "Quickhelp on word" })

    vim.api.nvim_create_autocmd("CursorHold", {
      ---@diagnostic disable-next-line: undefined-global
      buffer = bufnr,
      callback = function()
        local opts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = "rounded",
          source = "always",
          prefix = " ",
          scope = "cursor",
        }
        vim.diagnostic.open_float(nil, opts)
      end,
    })
  end,
})

-- Change here the left sidebar LSP icon config for:
local signs = { Error = "󰅚 ", Warn = " ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

local wk = require("which-key")

-- LEADER plugin keybinds (Space for this config)

wk.register({
  -- which-key category entries
  ["<leader>b"] = { name = "[B]uffers" },
  ["<leader>c"] = { name = "Close, Colorpicker" },
  -- ["<leader>D"] = { name = "DAP" },
  ["<leader>f"] = { name = "LSP Format + Genghis" },
  ["<leader>g"] = { name = "Git Blame + Links" },
  ["<leader>i"] = { name = "Indenting" },
  ["<leader>l"] = { name = "Leap, Lazy" },
  ["<leader>m"] = { name = "Mason" },
  ["<leader>n"] = { name = "Navbuddy, NeckPain, NeoTree" },
  ["<leader>k"] = { name = "Harpoon swap" },
  ["<leader>r"] = { name = "Func. rename" },
  ["<leader>s"] = { name = "Cokeline Sessions Timer ISwap" },
  ["<leader>t"] = { name = "Telescope TS Aerial Harpoon ToDo" },
  ["<leader>te"] = { name = "Terminal" },
  ["<leader>ta"] = { name = "Aerial" },
  ["<leader>tc"] = { name = "[T]o-do [C]omments+" },
  ["<leader>v"] = { name = "HBAC, LSP, " },
  ["<leader>w"] = { name = "Windows + Saving" },
  ["<leader>x"] = { name = "Trouble + Export to HTML" },
  ["<leader>X"] = { name = "Executor" },
  ["<leader>y"] = { name = "Yank" },
  ["<leader>z"] = { name = "[Z]en-Mode / Twilight" },

  -- Custom lua functions: their which-key entries
  ["<leader>th"] = { "<cmd>Themer<CR>", "Colorines", { silent = true } },

  -- COKELINE
  ["<leader>cn"] = { "<Plug>(cokeline-focus-next)", "Cambia al siguiente buffer", { silent = true } },
  ["<leader>cp"] = { "<Plug>(cokeline-focus-prev)", "Cambia al buffer previo", { silent = true } },
  ["<leader>cc"] = { "<Plug>(cokeline-pick-close)", "Elije buffer para cerrar", { silent = true } },
  ["<leader>csn"] = { "<Plug>(cokeline-switch-next)", "Intercambia con el buffer anterior", { silent = true } },
  ["<leader>csp"] = { "<Plug>(cokeline-switch-prev)", "Intercambia con el buffer anterior", { silent = true } },
})


-- NEOVIM INTERNAL CONFIGURATION

-- AUTOCMDS
vim.cmd([[ augroup LeavingTerminal autocmd! autocmd TermLeave <silent> <Esc> augroup end ]])
vim.cmd([[ autocmd BufEnter * if &ft == 'netrw' | setlocal syntax=netrw | endif ]])
vim.cmd("autocmd! filetype lazy setlocal nonumber norelativenumber")
vim.api.nvim_command("au TextYankPost * silent! lua vim.highlight.on_yank {timeout = 50}")

vim.keymap.set("n", "<leader>lz", "<cmd>Lazy<CR>", { desc = "Lazy", noremap = true, silent = true })
vim.keymap.set("n", "<leader>mp", "<cmd>Mason<CR>", { desc = "Mason", noremap = true, silent = true })
vim.keymap.set("n", "<leader>cl", "<cmd>ColorizerToggle<CR>", { desc = "Color picker toggle", silent = true })
vim.keymap.set("n", "<leader>nb", "<cmd>Navbuddy<CR>", { desc = "Navbuddy", silent = true })
vim.keymap.set("n", "<Tab>", "<Plug>(cokeline-focus-next)", { desc = "Change to next buffer", silent = true })
vim.keymap.set("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", { desc = "Change to previous buffer", silent = true })
for i = 1, 9 do
  vim.keymap.set("n", ("<leader>c%s"):format(i), ("<Plug>(cokeline-focus-%s)"):format(i), { desc = "Cambia al buffer x" })
  vim.keymap.set("n", ("<leader>s%s"):format(i), ("<Plug>(cokeline-switch-%s)"):format(i),
    { desc = "Intercambia con el buffer x" })
end
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true, desc = "Trouble Toggle" })
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
  { silent = true, noremap = true, desc = "Trouble Quickfix" })
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
  { silent = true, noremap = true, desc = "Trouble Loclist" })
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
  { desc = "Trouble Workspace Diagnostics" })
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
  { desc = "Trouble Document Diagnostics" })
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
  { silent = true, noremap = true, desc = "Trouble LSP References" })
require("leap").add_default_mappings()
vim.keymap.set({ "n", "v" }, "<leader>lp", function()
  local current_window = vim.fn.win_getid()
  require("leap").leap({ target_windows = { current_window } })
  vim.cmd([[:normal zz]])
end, { desc = "Leap bidirectionally" })
vim.keymap.set("n", "<leader>la", function()
  local focusable_window_on_tabpage = vim.tbl_filter(function(win) return vim.api.nvim_win_get_config(win).focusable end,
    vim.api.nvim_tabpage_list_wins(0))
  require("leap").leap({ target_windows = focusable_window_on_tabpage })
  vim.cmd([[:normal zz]])
end, { desc = "Leap on all windows" })

vim.keymap.set("n", "<leader>xth", "<cmd>TOhtml<CR>", { desc = "Exportar a HTML" })
vim.keymap.set("n", "<esc>", function()
  require("notify").dismiss()
  vim.cmd.nohl()
end, {})

vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Ex", silent = true })
-- Window splits and ?tabs?
vim.keymap.set("n", "<leader>ws", "<cmd>split<CR>", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<A-Left>", ":vertical resize -2<CR>", { desc = "Make vertical split smaller", silent = true })
vim.keymap.set("n", "<A-Right>", ":vertical resize +2<CR>", { desc = "Make vertical split larger", silent = true })
vim.keymap.set("n", "<A-Up>", ":resize -2<CR>", { desc = "Make horizontal split smaller", silent = true })
vim.keymap.set("n", "<A-Down>", ":resize +2<CR>", { desc = "Make horizontal split larger", silent = true })

vim.keymap.set("n", "<leader><Esc>", "<cmd>quitall<CR>", { desc = "Quit all", silent = true })
vim.keymap.set("n", "<leader>ww", "<cmd>write<CR>", { desc = "Write all" })
vim.keymap.set("n", "<leader>wq", "<cmd>wqa<CR>", { desc = "Bye :D" })
vim.keymap.set("n", "<leader>ip", "=ap", { desc = "Indent a paragraph", silent = true })
vim.keymap.set("n", "<leader>il", "==", { desc = "Indent-line toggle" })
--
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Better paste :)" })
vim.keymap.set({ "n", "v" }, "<leader>dd", [["_d]], { desc = "Better delete" })
vim.keymap.set("n", "dd", function()
  if vim.fn.getline(".") == "" then return '"_dd' end
  return "dd"
end, { expr = true })
--
-- Yank only to nvim clipboard
vim.keymap.set({ "n", "v" }, "<leader>yy", [[""y]])
vim.keymap.set({ "n", "v" }, "<leader>pp", [[""p]])
--
-- Keeping my cursor in the middle when searching
vim.keymap.set("n", "n", "nzzzv", { silent = true })
vim.keymap.set("n", "N", "Nzzzv", { silent = true })

-- Center cursor when skipping blocks and spaces
vim.keymap.set("n", "{", "{zzzv", { silent = true })
vim.keymap.set("n", "}", "}zzzv", { silent = true })
vim.keymap.set("n", "(", "(zzzv", { silent = true })
vim.keymap.set("n", ")", ")zzzv", { silent = true })

vim.keymap.set("n", "+", "S")

-- Delete character without yanking
vim.keymap.set({ "n", "v" }, "x", '"_x', { silent = true })
vim.keymap.set({ "n", "v" }, "X", '"_X', { silent = true })
--
-- Select all
vim.keymap.set("n", "<leader>sa", "ggVG", { desc = "Seleciona todo" })

-- Yank whole buffer
vim.keymap.set("n", "<leader>ya", 'ggVG"+y', { desc = "Copia todo el buffer" })
vim.keymap.set("n", "<leader>bc", "<cmd>bd<CR>", { noremap = true, silent = true, desc = "Close buffer softly" })
vim.keymap.set("n", "<leader>cw", "<cmd>close<CR>", { noremap = true, silent = true, desc = "Close window one way" })
vim.keymap.set("n", "<leader>q", "<cmd>close<CR>", { noremap = true, silent = true, desc = "Close window the other way" })
--
-- Delete buffer without saving
vim.keymap.set("n", "<leader>bd", "<cmd>bd!<CR>", { noremap = true, silent = true, desc = "Force buffer close" })

-- Half-page jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true })
--
-- Moving around text on visual

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- Better indenting
vim.keymap.set("v", "<", "<gv", { silent = true })
vim.keymap.set("v", ">", ">gv", { silent = true })

-- TERMINAL mode keybinds
--
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("n", "<leader>te>", ":bd!", { desc = "Exit terminal" })
