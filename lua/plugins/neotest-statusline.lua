local M = {}

local state = {
  active = false,
  results = {},
  running = 0,
  failed = 0,
  passed = 0,
  skipped = 0,
  total = 0,
}

local function refresh_lualine()
  pcall(function()
    require('lualine').refresh({ place = { 'statusline' } })
  end)
end

local function reset()
  state.active = true
  state.results = {}
  state.running = 0
  state.failed = 0
  state.passed = 0
  state.skipped = 0
  state.total = 0
end

local function recompute()
  state.failed = 0
  state.passed = 0
  state.skipped = 0
  state.total = 0

  for _, result in pairs(state.results) do
    state.total = state.total + 1
    local status = result and result.status
    if status == 'failed' then
      state.failed = state.failed + 1
    elseif status == 'passed' then
      state.passed = state.passed + 1
    elseif status == 'skipped' then
      state.skipped = state.skipped + 1
    end
  end
end

function M.attach(client)
  local function is_test(adapter_id, pos_id)
    local ok, neotest = pcall(require, 'neotest')
    if not ok or not neotest.state then
      return true
    end

    local tree = neotest.state.positions(adapter_id)
    local node = tree and tree:get_key(pos_id)
    return not node or node:data().type == 'test'
  end

  client.listeners.run = function(adapter_id, _, position_ids)
    reset()
    state.running = 0
    for _, pos_id in ipairs(position_ids or {}) do
      if is_test(adapter_id, pos_id) then
        state.running = state.running + 1
      end
    end
    refresh_lualine()
  end

  client.listeners.results = function(adapter_id, results, partial)
    if not state.active then
      return
    end

    if type(results) == 'table' then
      for pos_id, result in pairs(results) do
        if is_test(adapter_id, pos_id) then
          state.results[pos_id] = result
        end
      end
    end

    recompute()

    if not partial then
      state.running = 0
    else
      state.running = math.max(state.total - (state.failed + state.passed + state.skipped), 0)
    end

    refresh_lualine()
  end
end

function M.component()
  if not state.active then
    return ''
  end

  local ok_config, config = pcall(require, 'neotest.config')
  local icons = ok_config and config.icons or {
    running = '',
    failed = '',
    passed = '',
    skipped = '',
  }

  local parts = {}
  if state.running > 0 then
    table.insert(parts, icons.running .. ' ' .. state.running)
  end
  if state.failed > 0 then
    table.insert(parts, icons.failed .. ' ' .. state.failed)
  end
  if state.passed > 0 then
    table.insert(parts, icons.passed .. ' ' .. state.passed)
  end
  if state.skipped > 0 then
    table.insert(parts, icons.skipped .. ' ' .. state.skipped)
  end

  return table.concat(parts, ' ')
end

return M
