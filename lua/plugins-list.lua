-- Bootstrap `mini.nvim` in a way that allows `mini.deps` to manage plugins
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'

if not vim.uv.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/nvim-mini/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })
local add = MiniDeps.add

-- build blink
local function build_blink(params)
  vim.notify('Building blink.cmp', vim.log.levels.INFO)
  local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify('Building blink.cmp done', vim.log.levels.INFO)
  else
    vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
  end
end

local plugins = {
  -- ui
  { source = 'https://github.com/nvim-lua/plenary.nvim' },
  { source = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { source = 'https://github.com/MunifTanjim/nui.nvim' },
  { source = 'https://github.com/nvim-lualine/lualine.nvim' },
  { source = 'https://github.com/folke/which-key.nvim' },
  { source = 'https://github.com/folke/todo-comments.nvim' },
  { source = 'https://github.com/j-hui/fidget.nvim' },
  { source = 'https://github.com/s1n7ax/nvim-window-picker', name = 'window-picker' },
  { source = 'https://github.com/mcauley-penney/techbase.nvim' },
  -- { source = 'https://github.com/oskarnurm/koda.nvim' },
  { source = 'https://github.com/bluz71/vim-moonfly-colors', name = 'moonfly' },
  { source = 'https://github.com/folke/noice.nvim' },
  { source = 'https://github.com/luukvbaal/statuscol.nvim' },

  -- lsp/editor
  {
    source = 'https://github.com/nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = {
      post_checkout = function()
        vim.cmd('silent! TSUpdate')
      end,
    },
  },
  { source = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', checkout = 'main' },
  { source = 'https://github.com/folke/lazydev.nvim' },
  { source = 'https://github.com/neovim/nvim-lspconfig' },
  {
    source = 'https://github.com/saghen/blink.cmp',
    hooks = {
      post_install = build_blink,
      post_checkout = build_blink,
    },
  },
  { source = 'https://github.com/mason-org/mason.nvim' },
  { source = 'https://github.com/stevearc/conform.nvim' },
  { source = 'https://github.com/fang2hou/blink-copilot' },
  { source = 'https://github.com/SavingFrame/sidekick.nvim' },

  { source = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { source = 'https://github.com/ranelpadon/python-copy-reference.vim' },

  -- editor
  { source = 'https://github.com/nvim-neo-tree/neo-tree.nvim' },
  { source = 'https://github.com/folke/snacks.nvim' },
  { source = 'https://github.com/folke/persistence.nvim' },
  { source = 'https://github.com/monaqa/dial.nvim' },
  { source = 'https://github.com/lewis6991/gitsigns.nvim' },
  { source = 'https://github.com/nvim-mini/mini.nvim' },
  { source = 'https://github.com/windwp/nvim-autopairs' },
  { source = 'https://github.com/kevinhwang91/promise-async' },
  { source = 'https://github.com/kevinhwang91/nvim-ufo' },
  { source = 'https://github.com/christoomey/vim-tmux-navigator' },
  { source = 'https://github.com/folke/trouble.nvim' },
  { source = 'https://github.com/NMAC427/guess-indent.nvim' },
  { source = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
  { source = 'https://github.com/MagicDuck/grug-far.nvim' },
  { source = 'https://github.com/Vimjas/vim-python-pep8-indent' },

  -- tests
  { source = 'https://github.com/nvim-neotest/nvim-nio' },
  { source = 'https://github.com/nvim-neotest/neotest-python' },
  { source = 'https://github.com/fredrikaverpil/neotest-golang' },
  { source = 'https://github.com/nvim-neotest/neotest' },
}

for _, plugin in ipairs(plugins) do
  add(plugin)
end

require('plugins.snacks')
require('plugins.tree-sitter')
require('plugins.lsp')
require('plugins.ui')
require('plugins.editor')
require('plugins.tests')
require('plugins.dial')
