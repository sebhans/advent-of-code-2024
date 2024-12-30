local M = {}

local function make_key(...)
  local key
  for _, arg in ipairs(table.pack(...)) do
    if key then
      key = key .. '|' .. tostring(arg)
    else
      key = tostring(arg)
    end
  end
  return key
end

function M.memoize(f)
  local memo = {}
  return function(...)
    local key = make_key(...)
    local result = memo[key]
    if not result then
      result = f(...)
      memo[key] = result
    end
    return result
  end
end

return M
