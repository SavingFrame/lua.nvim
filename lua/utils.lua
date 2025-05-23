local M = {}

--- Get the 'site-packages' path of the currently activated virtual environment.
-- @return string|nil: The 'site-packages' path if found, or nil if not found.
function M.get_venv_site_packages_path()
  -- Get the path to the virtual environment
  local env_path = os.getenv 'VIRTUAL_ENV'
  if not env_path then
    print 'VIRTUAL_ENV is not set.'
    return nil
  end

  -- The lib directory contains Python version folders
  local lib_path = env_path .. '/lib'

  -- Find the pythonX.Y folder (like python3.11)
  local python_version_folder = nil
  for folder in io.popen('ls "' .. lib_path .. '"'):lines() do
    if folder:match '^python%d+%.%d+$' then
      python_version_folder = folder
      break
    end
  end

  -- If we found the python version folder, return the path to site-packages
  if python_version_folder then
    return lib_path .. '/' .. python_version_folder .. '/site-packages'
  else
    print('Could not find a Python version folder inside: ' .. lib_path)
    return nil
  end
end
return M
