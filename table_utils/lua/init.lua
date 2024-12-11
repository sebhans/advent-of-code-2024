local M = {}

function M.update_value(t, key, default_value, f)
  local value = t[key]
  if value then
    t[key] = f(value)
  else
    t[key] = default_value
  end
end

function M.sum_values(t)
  local sum = 0
  for _, value in pairs(t) do
    sum = sum + value
  end
  return sum
end

return M
