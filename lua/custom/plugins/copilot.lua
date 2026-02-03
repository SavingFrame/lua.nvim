return {
  {
    'zbirenbaum/copilot.lua',
    enabled = false,
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
  {
    'fang2hou/blink-copilot',
    opts = {
      debounce = 50,
      max_completions = 2,
    },
  },
  {
    'saghen/blink.cmp',
    build = 'cargo build --release',
    dependencies = { 'fang2hou/blink-copilot', 'folke/sidekick.nvim' },
    opts = {
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            score_offset = 100,
            async = true,
          },
        },
      },
      appearance = {
        -- Blink does not expose its default kind icons so you must copy them all (or set your custom ones) and add Copilot
        kind_icons = {
          Copilot = '',
          Text = '󰉿',
          Method = '󰊕',
          Function = '󰊕',
          Constructor = '󰒓',

          Field = '󰜢',
          Variable = '󰆦',
          Property = '󰖷',

          Class = '󱡠',
          Interface = '󱡠',
          Struct = '󱡠',
          Module = '󰅩',

          Unit = '󰪚',
          Value = '󰦨',
          Enum = '󰦨',
          EnumMember = '󰦨',

          Keyword = '󰻾',
          Constant = '󰏿',

          Snippet = '󱄽',
          Color = '󰏘',
          File = '󰈔',
          Reference = '󰬲',
          Folder = '󰉋',
          Event = '󱐋',
          Operator = '󰪚',
          TypeParameter = '󰬛',
        },
      },

      keymap = {
        ['<C-y>'] = {
          function() -- sidekick next edit suggestion
            return require('sidekick').nes_jump_or_apply()
          end,
          'select_and_accept',
          'fallback',
        },
      },
    },
  },

  {
    'NickvanDyke/opencode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    config = function()
      -- `opencode.nvim` passes options via a global variable instead of `setup()` for faster startup
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`
      }
    end,
  -- stylua: ignore
  keys = {
    { '<leader>at', function() require('opencode').toggle() end, desc = 'Toggle embedded opencode', },
    { '<leader>aa', function () require("opencode").ask("@this: ", { submit = false }) end, desc = 'Ask opencode', mode = 'n', },
    { '<leader>aa', function() require('opencode').ask('@this: ', {submit = false}) end, desc = 'Ask opencode about selection', mode = 'v', },
    { '<leader>ap', function() require('opencode').select_prompt() end, desc = 'Select prompt', mode = { 'n', 'v', }, },
    { '<leader>an', function() require('opencode').command('session_new') end, desc = 'New session', },
    { '<leader>ay', function() require('opencode').command('messages_copy') end, desc = 'Copy last message', },
    { '<S-C-u>',    function() require('opencode').command('messages_half_page_up') end, desc = 'Scroll messages up', },
    { '<S-C-d>',    function() require('opencode').command('messages_half_page_down') end, desc = 'Scroll messages down', },
  },
  },
  --
  {
    'folke/sidekick.nvim',
    opts = {
      -- add any options here
      cli = {
        mux = {
          backend = 'tmux',
          enabled = true,
        },
      },
    },
    keys = {
      {
        '<c-y>',
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require('sidekick').nes_jump_or_apply() then
            return '<Tab>' -- fallback to normal tab
          end
        end,
        expr = true,
        desc = 'Goto/Apply Next Edit Suggestion',
      },
      -- {
      --   '<c-.>',
      --   function()
      --     require('sidekick.cli').focus()
      --   end,
      --   desc = 'Sidekick Switch Focus',
      --   mode = { 'n', 'v' },
      -- },
      -- {
      --   '<leader>aa',
      --   function()
      --     require('sidekick.cli').toggle { focus = true }
      --   end,
      --   desc = 'Sidekick Toggle CLI',
      --   mode = { 'n', 'v' },
      -- },
      -- {
      --   '<leader>ap',
      --   function()
      --     require('sidekick.cli').select_prompt()
      --   end,
      --   desc = 'Sidekick Ask Prompt',
      --   mode = { 'n', 'v' },
      -- },
    },
  },
  -- {
  --   'saghen/blink.cmp',
  --   ---@module 'blink.cmp'
  --   ---@type blink.cmp.Config
  --   opts = {
  --     keymap = {
  --       ['<Tab>'] = {
  --         'snippet_forward',
  --         function() -- sidekick next edit suggestion
  --           return require('sidekick').nes_jump_or_apply()
  --         end,
  --         function() -- if you are using Neovim's native inline completions
  --           return vim.lsp.inline_completion.get()
  --         end,
  --         'fallback',
  --       },
  --     },
  --   },
  -- },
}
