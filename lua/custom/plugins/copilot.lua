return {
  {
    'zbirenbaum/copilot.lua',
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
    dependencies = { 'fang2hou/blink-copilot' },
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
    },
  },
  -- {
  --   'CopilotC-Nvim/CopilotChat.nvim',
  --   dependencies = {
  --     { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
  --     { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
  --   },
  --   build = 'make tiktoken', -- Only on MacOS or Linux
  --   keys = {
  --     { '<leader>a', '', desc = '+ai', mode = { 'n', 'v' } },
  --     {
  --       '<leader>aa',
  --       function()
  --         return require('CopilotChat').toggle()
  --       end,
  --       desc = 'Toggle (CopilotChat)',
  --       mode = { 'n', 'v' },
  --     },
  --     {
  --       '<leader>ap',
  --       function()
  --         require('CopilotChat').select_prompt()
  --       end,
  --       desc = 'Prompt Actions (CopilotChat)',
  --       mode = { 'n', 'v' },
  --     },
  --   },
  --   opts = {
  --     -- See Configuration section for options
  --   },
  --   -- See Commands section for default commands if you want to lazy load on them
  -- },

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
    { '<leader>aa', function() require('opencode').ask() end, desc = 'Ask opencode', mode = 'n', },
    { '<leader>aa', function() require('opencode').ask('@selection: ') end, desc = 'Ask opencode about selection', mode = 'v', },
    { '<leader>ap', function() require('opencode').select_prompt() end, desc = 'Select prompt', mode = { 'n', 'v', }, },
    { '<leader>an', function() require('opencode').command('session_new') end, desc = 'New session', },
    { '<leader>ay', function() require('opencode').command('messages_copy') end, desc = 'Copy last message', },
    { '<S-C-u>',    function() require('opencode').command('messages_half_page_up') end, desc = 'Scroll messages up', },
    { '<S-C-d>',    function() require('opencode').command('messages_half_page_down') end, desc = 'Scroll messages down', },
  },
  },
}
