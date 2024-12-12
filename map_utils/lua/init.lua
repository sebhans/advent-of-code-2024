local t = require('table_utils.lua')
local M = {}

local coordinate_methods = {
  key = function(self) return self.x .. "," .. self.y end,
  up = function(self) return M.coord(self.x, self.y - 1) end,
  down = function(self) return M.coord(self.x, self.y + 1) end,
  left = function(self) return M.coord(self.x - 1, self.y) end,
  right = function(self) return M.coord(self.x + 1, self.y) end,
}

local coordinate_meta = {
  __tostring = function(self) return self:key() end,
}

function M.coord(x, y)
  if not y and type(x) == "string" then
    x, y = x:match("([0-9]+),([0-9]+)")
  end
  local c = { x = x + 0, y = y + 0 }
  t.add(c, coordinate_methods)
  setmetatable(c, coordinate_meta)
  return c
end

local matrix_map_methods = {
  width = function(self) return #self[1] end,
  height = function(self) return #self end,

  at = function(self, x, y)
    if not y then
      if type(x) == "string" then return self:at_key(x)
      elseif type(x) == "number" then return nil
      else return self:at_coord(x)
      end
    elseif x < 1 or y < 1 or x > self:width() or y > self:height() then return nil
    else return self[y][x]
    end
  end,

  at_coord = function(self, c) return self:at(c.x, c.y) end,
  at_key = function(self, key) return self:at(M.coord(key)) end,

  coordinates = function(self)
    local function next_coordinate(_, c)
      if c == nil then
        return M.coord(1, 1)
      end
      local x = c.x + 1
      local y = c.y
      if x > self:width() then
        x = 1
        y = y + 1
        if y > self:height() then
          return nil
        end
      end
      return M.coord(x, y)
    end
    return next_coordinate, self, nil
  end
}

local matrix_map_meta = {
  __index = function(map, key)
    return map:at(key)
  end
}

function M.matrix_map(matrix)
  t.add(matrix, matrix_map_methods)
  setmetatable(matrix, matrix_map_meta)
  return matrix
end

return M
