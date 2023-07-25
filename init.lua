local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- Lazy.nvim bootstrap
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local plugins = {

  -- UI
  { -- Alpha dashboard
    "goolord/alpha-nvim",
    -- event = "VimEnter",
    dependencies = "nvim-tree/nvim-web-devicons",
    lazy = false,
    keys = { "<leader>sp", "<cmd>Alpha<CR>", desc = "Toggle Alpha" },
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
            "",
            "                    " .. time,
            "",
            "                        Neovim " .. v.major .. "." .. v.minor .. "." .. v.patch,
            "",
            "                   " .. stats.count .. " plugins | " .. ms .. "ms",
            "    I tuck you in, warm within, keep you free from sin ... ",
            "                  'Til the Sandman, he comes               ",
            "",
            "",
            "",
          }
          pcall(vim.cmd.AlphaRedraw)
        end,
      })

      if vim.api.nvim_exec("echo argc()", true) == "0" then
        -- Header section config
        dashboard.section.header.val = {
          "                                                                                    ",
          " ███╗   ███╗██████╗ ███████╗ █████╗ ███╗   ██╗██████╗ ███╗   ███╗ █████╗ ███╗   ██╗ ",
          " ████╗ ████║██╔══██╗██╔════╝██╔══██╗████╗  ██║██╔══██╗████╗ ████║██╔══██╗████╗  ██║ ",
          " ██╔████╔██║██████╔╝███████╗███████║██╔██╗ ██║██║  ██║██╔████╔██║███████║██╔██╗ ██║ ",
          " ██║╚██╔╝██║██╔══██╗╚════██║██╔══██║██║╚██╗██║██║  ██║██║╚██╔╝██║██╔══██║██║╚██╗██║ ",
          " ██║ ╚═╝ ██║██║  ██║███████║██║  ██║██║ ╚████║██████╔╝██║ ╚═╝ ██║██║  ██║██║ ╚████║ ",
          " ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ",
          "                                                                                    ",
          "                                   N E O V I M                                      ",
          "                                                                                    ",
          "                                      ／|__                                         ",
          "                                     (o o /                                         ",
          "_____________________________________ |.   ~. _____________________________________ ",
          "                                      じしf_,)ノ                                    ",
          "                                                                                    ",
        }

        dashboard.section.buttons.val = {
          dashboard.button("n", "New file", "<cmd>ene<CR>"),
          dashboard.button("e", "Ex", ":Explore<CR>"),
          dashboard.button("v", "Source session", ":SessionRestore<CR>"),
          dashboard.button("f", "Find project file", ":Telescope find_files<CR>"),
          dashboard.button("h", "Home dir find", ":cd $HOME | Telescope find_files<CR>"),
          dashboard.button("r", "Recent", ":Telescope oldfiles<CR>"),
          dashboard.button("g", "Grep pattern", ":Telescope live_grep<CR>"),
          dashboard.button("l", "Lazy", ":Lazy<CR>"),
          dashboard.button("s", "Settings", ":e $NVIMRC<CR>"),
          dashboard.button("q", "Quit", ":qa<CR>"),
        }

        alpha.setup(dashboard.opts)

        vim.cmd([[ autocmd Filetype alpha setlocal nofoldenable signcolumn=no nonumber norelativenumber ]])
      end
    end,
  },
  -- FIND BAR / STATUSLINE SUBSTITUTES
  --
  --
  --
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
      plugins = {
        "nvim-cmp",
        "nvim-navic",
        "telescope",
        "trouble",
        "which-key",
      },
      disable = {
        colored_cursor = false,
        borders = false,
        background = false,
        eob_lines = true,
      },
    },
    config = function() vim.g.material_style = "deep ocean" end
  },
  { "Mofiqul/vscode.nvim", opts = { italic_comments = true } },
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
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
    },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
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

  },





  -- TOOLS / UTILS
  { -- Session management
    "rmagatti/auto-session",
    event = "VimEnter",
    keys = {
      { "<leader>sd", "<cmd>SessionDelete<CR>",  desc = "Delete current session" },
      { "<leader>sr", "<cmd>SessionRestore<CR>", desc = "Restore session for CWD" },
      { "<leader>ss", "<cmd>SessionSave<CR>",    desc = "Save current session" },
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
  { "windwp/nvim-autopairs", event = { "BufReadPost", "BufNewFile" }, config = true },
  -- IDE-LIKE BREADCRUMBS
  { "Bekaboo/dropbar.nvim",  lazy = false },
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
      { "<leader>go",  "<cmd>GitBlameOpenCommitURL<CR>", desc = "Blame Open" },
      { "<leader>gO",  "<cmd>GitBlameOpenFileURL<CR>",   desc = "Blame Open" },
      { "<leader>gch", "<cmd>GitBlameCopySHA<CR>",       desc = "Blame Open" },
      { "<leader>gcu", "<cmd>GitBlameCopyCommitURL<CR>", desc = "Blame Open" },
      { "<leader>gcf", "<cmd>GitBlameCopyFileURL<CR>",   desc = "Blame Open" },
    },
    config = function()
      vim.g.gitblame_enabled = 0
      vim.g.gitblame_message_when_not_committed = "Not yet?"
    end
  },

  {
    "ruifm/gitlinker.nvim",
    keys = { { "<leader>gy", mode = { "n", "v" }, "Create codelink" } },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("gitlinker").setup() end
  }
}

local opts = {
  defaults = { lazy = true, version = false },
  checker = { enabled = true },
}

require("lazy").setup(plugins, opts)
