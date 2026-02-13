vim.pack.add({
  -- ui
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/MunifTanjim/nui.nvim' },
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
  { src = 'https://github.com/folke/which-key.nvim' },
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/j-hui/fidget.nvim',
  { src = 'https://github.com/s1n7ax/nvim-window-picker',   version = vim.version.range('^2'), name = 'window-picker' },
  { src = 'https://github.com/mcauley-penney/techbase.nvim' },
  -- 'https://github.com/oskarnurm/koda.nvim',
  { src = 'https://github.com/bluz71/vim-moonfly-colors',   name = 'moonfly' },
  'https://github.com/folke/noice.nvim',
  'https://github.com/luukvbaal/statuscol.nvim',
  -- lsp/editor
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
    data = {
      on_update = function()
        vim.cmd('TSUpdate')
      end,
    },
  },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
  { src = 'https://github.com/folke/lazydev.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/saghen/blink.cmp',                            version = vim.version.range('^1') },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/fang2hou/blink-copilot' },
  { src = 'https://github.com/SavingFrame/sidekick.nvim' },

  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { src = 'https://github.com/ranelpadon/python-copy-reference.vim' },
  -- editor
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',                 version = vim.version.range('^3') },
  { src = 'https://github.com/folke/snacks.nvim' },
  { src = 'https://github.com/folke/persistence.nvim' },
  { src = 'https://github.com/monaqa/dial.nvim' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/kevinhwang91/promise-async',
  'https://github.com/kevinhwang91/nvim-ufo',
  'https://github.com/christoomey/vim-tmux-navigator',
  'https://github.com/folke/trouble.nvim',
  'https://github.com/NMAC427/guess-indent.nvim',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  -- tests
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/nvim-neotest/neotest-python',
  'https://github.com/fredrikaverpil/neotest-golang',
  'https://github.com/nvim-neotest/neotest',
})

require('plugins.snacks')
require('plugins.tree-sitter')
require('plugins.lsp')
require('plugins.ui')
require('plugins.editor')
require('plugins.tests')
require('plugins.dial')
