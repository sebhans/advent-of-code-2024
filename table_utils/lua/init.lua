local M = {}

function M.add(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
  return t1
end

function M.append_all(t1, t2)
  for _, v in ipairs(t2) do
    t1[#t1 + 1] = v
  end
  return t1
end

function M.clone(t)
  local copy = {}
  for k, v in pairs(t) do
    local kc, vc = k, v
    if type(k) == "table" then
      kc = M.clone(k)
    end
    if type(v) == "table" then
      vc = M.clone(v)
    end
    copy[kc] = vc
  end
  setmetatable(copy, getmetatable(t))
  return copy
end

function M.cut_matrix(t, x1, y1, x2, y2)
  local slice = {}
  for y = y1, y2 do
    local row = {}
    for x = x1, x2 do
      row[#row + 1] = t[y][x]
    end
    slice[#slice + 1] = row
  end
  return slice
end

function M.min_by(t, selector)
  local min, min_s = nil, nil
  for _, v in ipairs(t) do
    if min == nil then
      min = v
      min_s = selector(v)
    else
      local s = selector(v)
      if s < min_s then
        min = v
        min_s = s
      end
    end
  end
  return min
end

function M.size(t)
  local size = 0
  for _ in pairs(t) do
    size = size + 1
  end
  return size
end

function M.update_value(t, key, default_value, f)
  local old_value = t[key]
  local new_value = default_value
  if old_value then
    new_value = f(old_value)
  end
  t[key] = new_value
  return new_value
end

function M.sum_values(t)
  local sum = 0
  for _, value in pairs(t) do
    sum = sum + value
  end
  return sum
end

return M
