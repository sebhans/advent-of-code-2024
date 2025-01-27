local t = require('table_utils.lua')
local M = {}

function M.shallow_copy_array(a)
  local copy = {}
  for i, v in ipairs(a) do
    copy[i] = v
  end
  return copy
end

local set_methods = {
  add = function(self, value)
    self[value] = true
  end,

  contains = function(self, value)
    return self[value]
  end,

  contains_all = function(self, other)
    for value in other:elements() do
      if not self:contains(value) then
        return false
      end
    end
    return true
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

  to_array = function(self)
    local a = M.empty_set()
    for e in self:elements() do
      a[#a + 1] = e
    end
    return a
  end
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
