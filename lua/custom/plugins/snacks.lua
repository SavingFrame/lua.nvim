return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      dashboard = { enabled = true },
      indent = {
        enabled = true,
        chunk = {
          enabled = true,
        },
      },
      lazygit = {
        enabled = true,
      },
      input = { enabled = true },
      picker = {
        formatters = {
          file = {
            truncate = 120,
          },
        },
        previewers = {
          git = {
            native = true,
          },
        },
      },
      notifier = {
        enabled = true,
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      -- Top Pickers & Explorer
      -- {
      --   '<leader><space>',
      --   function()
      --     Snacks.picker.smart()
      --   end,
      --   desc = 'Smart Find Files',
      -- },
      {
        '<leader>,',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<leader><tab>',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<leader>:',
        function()
          Snacks.picker.command_history()
        end,
        desc = 'Command History',
      },
      {
        '<leader>n',
        function()
          Snacks.picker.notifications()
        end,
        desc = 'Notification History',
      },
      -- find
      {
        '<leader>fb',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      -- {
      --   '<leader>fc',
      --   function()
      --     Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
      --   end,
      --   desc = 'Find Config File',
      -- },
      -- {
      --   '<leader>ff',
      --   function()
      --     Snacks.picker.files {
      --       finder = 'files',
      --       format = 'file',
      --       hidden = true,
      --       ignored = true,
      --       follow = false,
      --       supports_live = true,
      --       -- debug = false,
      --     }
      --   end,
      --   desc = 'Find Files',
      -- },
      {
        '<leader>fr',
        function()
          Snacks.picker.recent()
        end,
        desc = 'Recent',
      },
      -- git
      {
        '<leader>gd',
        function()
          Snacks.picker.git_diff()
        end,
        desc = 'Git Diff (Hunks)',
      },
      {
        '<leader>gf',
        function()
          Snacks.picker.git_log_file()
        end,
        desc = 'Git Log File',
      },
      {
        '<leader>gs',
        function()
          Snacks.picker.git_status()
        end,
        desc = 'Git Status',
      },
      -- Grep
      {
        '<leader>sg',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Grep',
      },
      {
        '<leader>sw',
        function()
          Snacks.picker.grep_word()
        end,
        desc = 'Visual selection or word',
        mode = { 'n', 'x' },
      },
      -- search
      {
        '<leader>sb',
        function()
          Snacks.picker.lines()
        end,
        desc = 'Buffer Lines',
      },
      {
        '<leader>sd',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = 'Diagnostics',
      },
      {
        '<leader>sD',
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = 'Buffer Diagnostics',
      },
      {
        '<leader>sh',
        function()
          Snacks.picker.help()
        end,
        desc = 'Help Pages',
      },
      {
        '<leader>sH',
        function()
          Snacks.picker.highlights()
        end,
        desc = 'Highlights',
      },
      {
        '<leader>sj',
        function()
          Snacks.picker.jumps()
        end,
        desc = 'Jumps',
      },
      {
        '<leader>sk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = 'Keymaps',
      },
      {
        '<leader>sl',
        function()
          Snacks.picker.loclist()
        end,
        desc = 'Location List',
      },
      {
        '<leader>sm',
        function()
          Snacks.picker.marks()
        end,
        desc = 'Marks',
      },
      {
        '<leader>sM',
        function()
          Snacks.picker.man()
        end,
        desc = 'Man Pages',
      },
      {
        '<leader>sq',
        function()
          Snacks.picker.qflist()
        end,
        desc = 'Quickfix List',
      },
      {
        '<leader>sR',
        function()
          Snacks.picker.resume()
        end,
        desc = 'Resume',
      },
      {
        '<leader>su',
        function()
          Snacks.picker.undo()
        end,
        desc = 'Undo History',
      },
      {
        '<leader>sp',
        function()
          Snacks.picker.lazy()
        end,
        desc = 'Search for Plugin Spec',
      },
      {
        '<leader>uC',
        function()
          Snacks.picker.colorschemes()
        end,
        desc = 'Colorschemes',
      },
      {
        '<leader>bd',
        function()
          Snacks.bufdelete()
        end,
        desc = 'Delete Buffer',
      },
      {
        '<leader>cR',
        function()
          Snacks.rename.rename_file()
        end,
        desc = 'Rename File',
      },
      {
        '<leader>gB',
        function()
          Snacks.gitbrowse()
        end,
        desc = 'Git Browse',
        mode = { 'n', 'v' },
      },
      {
        '<leader>gb',
        function()
          Snacks.git.blame_line()
        end,
        desc = 'Git Blame',
        mode = { 'n', 'v' },
      },
      {
        '<leader>gg',
        function()
          Snacks.lazygit()
        end,
        desc = 'Lazygit',
      },
      {
        '<leader>un',
        function()
          Snacks.notifier.hide()
        end,
        desc = 'Dismiss All Notifications',
      },
      {
        ']]',
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = 'Next Reference',
        mode = { 'n', 't' },
      },
      {
        '[[',
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = 'Prev Reference',
        mode = { 'n', 't' },
      },
      {
        '<leader>sw',
        function()
          Snacks.picker.grep_word()
        end,
        desc = 'Visual selection or word',
        mode = { 'n', 'x' },
      },
    },
  },
  {
    'dmtrKovalenko/fff.nvim',
    build = 'cargo build --release',
    -- or if you are using nixos
    -- build = "nix run .#release",
    opts = {
      -- pass here all the options
    },
    keys = {
      {
        '<leader><space>', -- try it if you didn't it is a banger keybinding for a picker
        function()
          require('fff').find_in_git_root() -- or find_in_git_root() if you only want git files
        end,
        desc = 'Open file picker',
      },
      {
        '<leader>fc',
        function()
          require('fff').find_files_in_dir(vim.fn.stdpath 'config')
        end,
        desc = 'Find Config File',
      },
      {
        '<leader>ff',
        function()
          require('fff').find_files()
        end,
        desc = 'Find Files',
      },
    },
  },
}
