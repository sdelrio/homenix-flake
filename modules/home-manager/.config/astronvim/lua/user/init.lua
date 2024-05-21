return {
  colorscheme = "gruvbox",

  options = {
    opt = {
      cmdheight = 1, -- Always display cmd line
      foldcolumn = "0", -- Hide foldcolumn
      guicursor = "", -- Disable Nvim GUI cursor
      mouse = "", -- Disable mouse support
      number = false, -- Hide numberline
      relativenumber = false, -- Hide relative numberline
      signcolumn = "auto", -- Show sign column when used only
      spell = true, -- Enable spell checking
    },
  },

  highlights = {
    -- Fix Gruvbox highlight groups
    -- https://github.com/ellisonleao/gruvbox.nvim/blob/main/lua/gruvbox.lua
    gruvbox = {
      -- Hard-code reversed colors
      -- https://github.com/AstroNvim/AstroNvim/issues/1147
      StatusLine = { fg = "#ebdbb2", bg = "#504945" }, -- colors.light1 / colors.dark2
    },
  },

  plugins = {
    { "ellisonleao/gruvbox.nvim", version = "2.0.0" },
    { "terrastruct/d2-vim", version = "981c87dccb63df2887cc41b96e84bf550f736c57", ft = { "d2" }},
    {
      "rebelot/heirline.nvim",
      opts = function(_, opts)
        local status = require("astronvim.utils.status")
        opts.statusline = vim.tbl_deep_extend("force", opts.statusline, {
          -- add mode component
          status.component.mode { mode_text = { padding = { left = 1, right = 1 } } },
        })
        return opts
      end
    },
    {
      "jay-babu/mason-nvim-dap.nvim",
      config = function()
        local dap = require('dap')
        local adapters = require('mason-nvim-dap.mappings.adapters')
        local configurations = require('mason-nvim-dap.mappings.configurations')

        dap.adapters.delve = adapters.delve
        dap.configurations.go = configurations.delve
      end,
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = {
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
          },
        },
      }
    },
    {
      "jose-elias-alvarez/null-ls.nvim",
      opts = function(_, opts)
        local null_ls = require "null-ls"
        -- Include code and source with diagnostics message
        opts.diagnostics_format = "[#{c}] #{m} (#{s})"
        opts.sources = {
          null_ls.builtins.diagnostics.golangci_lint,
          null_ls.builtins.diagnostics.hadolint,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.shfmt.with({
            extra_args = { "-i", "2", "-ci", "-bn"},
          }),
        }
        return opts
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        ensure_installed = {
          "bash",
          "go",
          "gomod",
          "hcl",
          "jsonnet",
          "nix",
          "python",
          "regex",
          "rust",
          "terraform",
          "typescript",
        },
      },
    },
--[[ Alternate lsp config
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = {
        "neovim/nvim-lspconfig"
      },
      opts = {
        handlers = {
          function(ls) require('lspconfig')[ls].setup({}) end, -- default for anything that doesn't have an explicit handler
          lua_ls = function()
            require('lspconfig').lua_ls.setup({
               -- lua_ls only settings here
            })
          end
        }
      },
    },
]]--
  },

  lsp = {
    servers = {
      "bashls",
      "cssls",
      "eslint",
      "gopls",
      "html",
      "jsonls",
      "jsonnet_ls",
      "nixd",
      "pylsp",
      "rnix",
      "ruff_lsp",
      "rust_analyzer",
      "terraformls",
      "tsserver",
      "yamlls",
    },
    formatting = {
      disabled = {
        -- use null-ls' prettier instead
        "cssls",
        "html",
        "jsonls",
        "tsserver",
        "yaml",
      },
      format_on_save = {
        enabled = true,
        allow_filetypes = {
          "go",
          "jsonnet",
          "rust",
          "terraform",
        },
      },
    },
  },

  polish = function()
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Highlight lines over 90 characters long",
      callback = function()
        if vim.bo.filetype == "alpha" then
          return
        end
        vim.cmd([[
          highlight ColorColumn ctermbg=DarkRed guibg=DarkRed
          call matchadd('ColorColumn', '\%91v', 100)
        ]])
      end,
    })
  end,
}
