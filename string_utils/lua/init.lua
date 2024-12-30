local M = {}

function M.extract(s, pattern)
  local parts = {}
  for part in s:gmatch(pattern) do
    parts[#parts + 1] = part
  end
  return parts
end

return M
