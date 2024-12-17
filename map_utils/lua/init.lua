local t = require('table_utils.lua')
local M = {}

local coordinate_methods = {
  key = function(self) return self.x .. "," .. self.y end,
  up = function(self) return M.coord(self.x, self.y - 1) end,
  down = function(self) return M.coord(self.x, self.y + 1) end,
  left = function(self) return M.coord(self.x - 1, self.y) end,
  right = function(self) return M.coord(self.x + 1, self.y) end,
  translate = function(self, dx, dy) return M.coord(self.x + dx, self.y + dy) end,
}

local coordinate_meta = {
  __eq = function(self, other)
    if type(other) == "string" then return self == M.coord(other)
    else return self.x == other.x and self.y == other.y
    end
  end,
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
  end,

  put = function(self, x, y_or_element, element)
    if not element then
      if type(x) == "string" then return self:put_key(x, y_or_element)
      elseif type(x) == "number" then return
      else return self:put_coord(x, y_or_element)
      end
    elseif x < 1 or y_or_element < 1 or x > self:width() or y_or_element > self:height() then return nil
    else self[y_or_element][x] = element
    end
  end,

  put_coord = function(self, c, element) return self:put(c.x, c.y, element) end,
  put_key = function(self, key, element) return self:put(M.coord(key), element) end,

  scan = function(self, actions)
    for y, row in ipairs(self) do
      for x, c in ipairs(row) do
        for target, action in pairs(actions) do
          if c == target then
            action(M.coord(x, y))
          end
        end
      end
    end
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

function M.empty_matrix_map(width, height, tile)
  if not tile then tile = '.' end
  local map = {}
  for y = 1, height do
    local row = {}
    for x = 1, width do
      row[x] = tile
    end
    map[y] = row
  end
  return M.matrix_map(map)
end

local sparse_map_methods = {
  width = function(self) return self._width end,
  height = function(self) return self._height end,

  add = function(self, x, y, object)
    local row = self[y]
    if not row then
      row = {}
      self[y] = row
    end
    row[x] = object
  end,

  at = function(self, x, y)
    if not y then
      if type(x) == "string" then return self:at_key(x)
      elseif type(x) == "number" then return nil
      else return self:at_coord(x)
      end
    elseif x < self._left or y < self._top or x >= self._left + self._width or y >= self._top + self._height then return nil
    elseif self[y] then return self[y][x]
    else return nil
    end
  end,

  at_coord = function(self, c) return self:at(c.x, c.y) end,
  at_key = function(self, key) return self:at(M.coord(key)) end,

  print = function(self, render)
    for y = self._top, self._top + self._height - 1 do
      for x = self._left, self._left + self._width - 1 do
        if self[y] and self[y][x] then
          if render then
            io.write(render(self[y][x]))
          else
            io.write(self[y][x])
          end
        else
          io.write(" ")
        end
      end
      print()
    end
  end,

  tostring = function(self, render)
    local s = ""
    for y = self._top, self._top + self._height - 1 do
      for x = self._left, self._left + self._width - 1 do
        if self[y] and self[y][x] then
          if render then
            s = s .. render(self[y][x])
          else
            s = s .. self[y][x]
          end
        else
          s = s .. " "
        end
      end
      s = s .. "\n"
    end
    return s
  end,
}

local sparse_map_meta = {
  __index = function(map, key)
    return map:at(key)
  end
}

function M.sparse_map(top, left, width, height)
  local map = {_top = top + 0, _left = left + 0, _width = width + 0, _height = height + 0}
  t.add(map, sparse_map_methods)
  setmetatable(map, sparse_map_meta)
  return map
end

return M
