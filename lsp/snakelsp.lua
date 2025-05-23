return {
  -- cmd = { 'snakelsp' },
  cmd = { '/home/archie/Projects/snakelsp/snakelsp' },
  filetypes = { 'python' },
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
