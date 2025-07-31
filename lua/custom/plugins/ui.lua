return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      'rcarriga/nvim-notify',
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        -- theme = 'lackluster',
        theme = 'kanagawa',
        section_separators = '',
        component_separators = '',
        disabled_filetypes = { -- Filetypes to disable lualine for.
          statusline = { 'neo-tree' }, -- only ignores the ft for statusline.
          -- winbar = {}, -- only ignores the ft for winbar.
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
          {
            'filename',
            file_status = true, -- Displays file status (readonly status, modified status)
            newfile_status = false, -- Display new file status (new file means no write after created)
            path = 1, -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory

            shorting_target = 120, -- Shortens path to leave 40 spaces in the window
            -- for other components. (terrible name, any suggestions?)
            symbols = {
              modified = '[+]', -- Text to show when the file is modified.
              readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
              unnamed = '[No Name]', -- Text to show for unnamed buffers.
              newfile = '[New]', -- Text to show for newly created file before first write
            },
          },
        },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      winbar = {
        lualine_c = {
          {
            'filename',
            file_status = true, -- Displays file status (readonly status, modified status)
            newfile_status = false, -- Display new file status (new file means no write after created)
            path = 1, -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory

            shorting_target = 120, -- Shortens path to leave 40 spaces in the window
            -- for other components. (terrible name, any suggestions?)
            symbols = {
              modified = '[+]', -- Text to show when the file is modified.
              readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
              unnamed = '[No Name]', -- Text to show for unnamed buffers.
              newfile = '[New]', -- Text to show for newly created file before first write
            },
          },
          {
            'navic',
            color_correction = nil,
            navic_opts = nil,
          },
        },
      },
    },
  },
  {
    'chentoast/marks.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'SmiteshP/nvim-navic',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('nvim-navic').setup {
        lsp = {
          auto_attach = true, -- Automatically attach to LSP servers
          preference = { 'clangd', 'basedpyright', 'tsserver' }, -- Prioritize servers
        },
        highlight = true, -- Enable highlight groups for icons and text
        separator = ' > ', -- Separator between context elements
        depth_limit = 0, -- No limit on context depth (0 means unlimited)
        depth_limit_indicator = '..', -- Indicator for truncated context
      }
    end,
  },
  {
    'slugbyte/lackluster.nvim',
    lazy = false,
    priority = 1000,
    init = function()
      -- vim.cmd.colorscheme 'lackluster'
      local lackluster = require 'lackluster'

      -- Configure lackluster with custom highlight for DiagnosticWarn
      lackluster.setup {
        tweak_syntax = {
          comment = lackluster.color.gray5, -- or gray5
        },
        tweak_highlight = {
          ['DiagnosticWarn'] = {
            fg = lackluster.color.yellow, -- Orange color for warnings (hex code)
          },
          ['DiagnosticVirtualTextWarn'] = {
            fg = lackluster.color.yellow, -- Orange color for warnings (hex code)
          },
        },
      }
      -- vim.cmd.colorscheme 'lackluster-hack' -- my favorite
      --
      vim.api.nvim_set_hl(0, 'WinBar', { fg = '#7a7a7a', bg = '#242424' })
      vim.api.nvim_set_hl(0, 'WinBarNC', { fg = '#7a7a7a', bg = '#242424' })
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    init = function()
      require('kanagawa').setup {
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = 'none',
              },
            },
          },
        },
      }
      vim.cmd.colorscheme 'kanagawa'
    end,
  },
  {
    'kazhala/close-buffers.nvim',
    opts = {
      filetype_ignore = { 'neo-tree' }, -- Filetype to ignore when running deletions
      file_glob_ignore = {}, -- File name glob pattern to ignore when running deletions (e.g. '*.md')
      file_regex_ignore = {}, -- File name regex pattern to ignore when running deletions (e.g. '.*[.]md')
      preserve_window_layout = { 'this', 'nameless' }, -- Types of deletion that should preserve the window layout
      next_buffer_cmd = nil, -- Custom function to retrieve the next buffer when preserving window layout
    },
    keys = {
      {
        '<leader>bo',
        function()
          require('close_buffers').delete { type = 'hidden', force = true }
        end,
        desc = 'Delete Other Buffers',
      },
    },
  },
}
