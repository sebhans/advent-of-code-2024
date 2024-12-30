local M = {}

function M.extract(s, pattern)
  local parts = {}
  for part in s:gmatch(pattern) do
    parts[#parts + 1] = part
  end
  return parts
end

function M.starts_with(s, prefix)
  if #s < #prefix then
    return false
  end
  if #s == #prefix and s == prefix then
    return true
  end
  return string.sub(s, 1, #prefix) == prefix
end

return M
