return {
  {
    'b0o/SchemaStore.nvim',
    lazy = true,
    version = false, -- last release is way too old
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = 'main',
    lazy = false,
    -- main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'python',
        'go',
        'gomod',
        'gowork',
        'gosum',
        'json5',
        'dockerfile',
        'templ',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        -- additional_vim_regex_highlighting = { 'ruby' },
        additional_vim_regex_highlighting = true,
      },
      indent = { enable = true, disable = { 'ruby', 'python' } },
    },
    config = function(_, opts)
      -- This is the main configuration for nvim-treesitter.
      --  It sets up the treesitter modules and their options.
      --
      --  You can read more about the options in `:help nvim-treesitter-configs`
      -- treesitter = require 'nvim-treesitter'
      -- treesitter.setup(opts)
      require('nvim-treesitter').install {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'python',
        'go',
        'gomod',
        'gowork',
        'gosum',
        'json5',
        'dockerfile',
        'templ',
      }
      local parsersInstalled = require('nvim-treesitter.config').get_installed 'parsers'
      for _, parser in pairs(parsersInstalled) do
        local filetypes = vim.treesitter.language.get_filetypes(parser)
        vim.api.nvim_create_autocmd({ 'FileType' }, {
          pattern = filetypes,
          callback = function(ctx)
            vim.treesitter.start()
            local noIndent = {}
            if not vim.list_contains(noIndent, ctx.match) then
              vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end,
        })
      end

      -- NOTE: If you want to learn more about nvim-treesitter, you can read the
      --       documentation at `:help nvim-treesitter`
    end,
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
  {
    -- This is temporary solution.
    -- Without it we should use main textobject repo with main branch(not master).
    -- PR: https://github.com/nvim-treesitter/nvim-treesitter-textobjects/pull/782
    'SavingFrame/nvim-treesitter-textobjects',
    enabled = true,
    branch = 'fix-python-textobjects',
    opts = {
      lookahead = true,
    },
    keys = {
      -- select in/select out
      {
        'ic',
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
        end,
        mode = { 'o', 'x' },
        desc = 'Treesitter inner class',
      },
      {
        'ac',
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
        end,
        mode = { 'o', 'x' },
        desc = 'Treesitter outer class',
      },
      {
        'if',
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
        end,
        mode = { 'o', 'x' },
        desc = 'Treesitter inner function',
      },
      {
        'af',
        function()
          require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
        end,
        mode = { 'o', 'x' },
        desc = 'Treesitter outer function',
      },
      -- move
      {
        ']f',
        function()
          require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
        end,
        mode = { 'n', 'x' },
        desc = 'Treesitter next function start',
      },
      {
        '[f',
        function()
          require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
        end,
        mode = { 'n', 'x', 'o' },
        desc = 'Treesitter previous function start',
      },
      {
        '[F',
        function()
          require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
        end,
        mode = { 'n', 'x', 'o' },
        desc = 'Treesitter previous function end',
      },
      {
        ']F',
        function()
          require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
        end,
        mode = { 'n', 'x', 'o' },
        desc = 'Treesitter next function end',
      },
      {
        ']c',
        function()
          require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
        end,
        mode = { 'n', 'x', 'o' },
        desc = 'Treesitter next class start',
      },
      {
        '[c',
        function()
          require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects')
        end,
        mode = { 'n', 'x', 'o' },
        desc = 'Treesitter previous class start',
      },
      {
        ']C',
        function()
          require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
        end,
        mode = { 'n', 'x', 'o' },
        desc = 'Treesitter next class end',
      },
      {
        '[C',
        function()
          require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
        end,
        mode = { 'n', 'x', 'o' },
        desc = 'Treesitter previous class end',
      },
      {
        '[a',
        function()
          require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.inner', 'textobjects')
        end,
        mode = { 'n', 'x', 'o' },
        desc = 'Treesitter previous parameter start',
      },
      {
        ']a',
        function()
          require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.inner', 'textobjects')
        end,
        mode = { 'n', 'x', 'o' },
        desc = 'Treesitter next parameter start',
      },
      {
        '[A',
        function()
          require('nvim-treesitter-textobjects.move').goto_previous_end('@parameter.inner', 'textobjects')
        end,
        mode = { 'n', 'x', 'o' },
        desc = 'Treesitter previous parameter end',
      },
      {
        ']A',
        function()
          require('nvim-treesitter-textobjects.move').goto_next_end('@parameter.inner', 'textobjects')
        end,
        mode = { 'n', 'x', 'o' },
        desc = 'Treesitter next parameter end',
      },
    },
  },
}
