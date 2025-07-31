return {
  -- cmd = { 'snakelsp' },

  cmd = { '/home/archie/Projects/snakelsp/snakelsp' },
  -- cmd = { 'lsp-devtools', 'agent', '--', '/home/archie/Projects/snakelsp/snakelsp' },
  -- cmd = { 'lspwatcher', 'agent', '/home/archie/Projects/snakelsp/snakelsp' },
  filetypes = { 'python' },
  capabilities = {
    textDocument = {
      -- To disable documentSymbolss and use basedPyright documentSymbols
      documentSymbol = vim.NIL,
    },
  },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
    '.git',
    '.venv',
  },
  init_options = {
    virtualenv_path = os.getenv 'VIRTUAL_ENV',
  },
}
