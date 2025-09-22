return {
  {
    'alexpasmantier/pymple.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      -- optional (nicer ui)
      'stevearc/dressing.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    build = ':PympleBuild',
    config = function()
      require('pymple').setup()
    end,
  },
  { 'microsoft/python-type-stubs' },
  { 'Vimjas/vim-python-pep8-indent', ft = 'python' },
  {
    'ranelpadon/python-copy-reference.vim',
    keys = {
      { '<leader>cid', '<cmd>PythonCopyReferenceDotted<CR>', desc = 'Copy Dotted Reference' },
      { '<leader>cii', '<cmd>PythonCopyReferenceImport<CR>', desc = 'Copy Import Reference' },
      { '<leader>cit', '<cmd>PythonCopyReferencePytest<CR>', desc = 'Copy Pytest Reference' },
    },
  },
}
