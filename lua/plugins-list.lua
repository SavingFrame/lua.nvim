local function gh(repo)
  return 'https://github.com/' .. repo
end

-- build blink
local function build_blink(params)
  vim.notify('Building blink.cmp', vim.log.levels.INFO)
  local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()

  -- local cmp = require('blink.cmp')
  -- cmp.build():wait(60000)
  -- cmp.setup()
  if obj.code == 0 then
    vim.notify('Building blink.cmp done', vim.log.levels.INFO)
  else
    vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
  end
end

local function on_pack_changed(ev)
  local name = ev.data.spec.name
  local kind = ev.data.kind
  if kind ~= 'install' and kind ~= 'update' then
    return
  end

  if name == 'nvim-treesitter' then
    vim.cmd('silent! TSUpdate')
  elseif name == 'blink.cmp' then
    build_blink({ path = ev.data.path })
  elseif name == 'neotest-golang' then
    vim.system({ 'go', 'install', 'gotest.tools/gotestsum@latest' }):wait()
  elseif name == 'fff.nvim' then
    require('fff.download').download_or_build_binary()
  end
end

vim.api.nvim_create_autocmd('PackChanged', { callback = on_pack_changed })

local plugins = {
  -- ui
  gh('nvim-lua/plenary.nvim'),
  gh('nvim-tree/nvim-web-devicons'),
  gh('MunifTanjim/nui.nvim'),
  gh('nvim-lualine/lualine.nvim'),
  gh('folke/which-key.nvim'),
  gh('folke/todo-comments.nvim'),
  gh('j-hui/fidget.nvim'),
  { src = gh('s1n7ax/nvim-window-picker'), name = 'window-picker' },
  gh('mcauley-penney/techbase.nvim'),
  -- gh('oskarnurm/koda.nvim'),
  { src = gh('bluz71/vim-moonfly-colors'), name = 'moonfly' },
  gh('folke/noice.nvim'),
  gh('luukvbaal/statuscol.nvim'),
  gh('SmiteshP/nvim-navic'),

  -- lsp/editor
  { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },
  { src = gh('nvim-treesitter/nvim-treesitter-textobjects'), version = 'main' },
  gh('folke/lazydev.nvim'),
  gh('neovim/nvim-lspconfig'),
  { src = gh('saghen/blink.cmp'), version = 'v1' },
  gh('mason-org/mason.nvim'),
  gh('stevearc/conform.nvim'),
  gh('fang2hou/blink-copilot'),
  gh('folke/sidekick.nvim'),
  gh('mason-org/mason-lspconfig.nvim'),
  gh('ranelpadon/python-copy-reference.vim'),

  -- editor
  gh('nvim-neo-tree/neo-tree.nvim'),
  gh('folke/snacks.nvim'),
  gh('folke/persistence.nvim'),
  gh('monaqa/dial.nvim'),
  gh('lewis6991/gitsigns.nvim'),
  gh('nvim-mini/mini.nvim'),
  gh('windwp/nvim-autopairs'),
  gh('kevinhwang91/promise-async'),
  gh('kevinhwang91/nvim-ufo'),
  gh('christoomey/vim-tmux-navigator'),
  gh('folke/trouble.nvim'),
  gh('NMAC427/guess-indent.nvim'),
  gh('MeanderingProgrammer/render-markdown.nvim'),
  gh('MagicDuck/grug-far.nvim'),
  gh('Vimjas/vim-python-pep8-indent'),
  gh('dmtrKovalenko/fff.nvim'),

  -- tests
  gh('nvim-neotest/nvim-nio'),
  gh('nvim-neotest/neotest-python'),
  gh('fredrikaverpil/neotest-golang'),
  gh('nvim-neotest/neotest'),
}

vim.pack.add(plugins)

require('plugins.snacks')
require('plugins.tree-sitter')
require('plugins.lsp')
require('plugins.ui')
require('plugins.editor')
require('plugins.tests')
require('plugins.dial')
