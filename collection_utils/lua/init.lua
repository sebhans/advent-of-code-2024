local t = require('table_utils.lua')
local M = {}

local set_methods = {
  add = function(self, value)
    self[value] = true
  end,

  contains = function(self, value)
    return self[value]
  end,

  elements = function(self)
    local function next_element(set, index)
      local k, v = index, nil
      repeat
        k, v = next(set, k)
      until k == nil or type(v) ~= "function"
      return k
    end
    return next_element, self, nil
  end,

  remove = function(self, value)
    self[value] = nil
    return value
  end,

  union = function(self, other)
    for k, v in pairs(other) do
      self[k] = v
    end
    return self
  end,
}

function set_methods.size(self) return t.size(self) - t.size(set_methods) end


local set_meta = {
  __tostring = function(self)
    local s = "[ "
    for e in self:elements() do
      s = s .. e .. " "
    end
    s = s .. "]"
    return s
  end
}

function M.empty_set()
  local set = {}
  t.add(set, set_methods)
  setmetatable(set, set_meta)
  return set
end

function M.set(...)
  local set = M.empty_set()
  for _, e in ipairs(table.pack(...)) do
    set:add(e)
  end
  return set
end

return M
