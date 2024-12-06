function mark(self, x, y)
  self[x .. "," .. y] = true
end

local map = { mark = mark }
local up = 0
local right = 1
local down = 2
local left = 3
local guard = { direction = up }
local y = 0
for line in io.lines('input/day6.txt') do
  local x = 0
  y = y + 1
  for c in line:gmatch("(.)") do
    x = x + 1
    if c == "#" then
      map:mark(x, y)
    elseif c == "^" then
      guard.x, guard.y = x, y
    end
  end
  map.width = x
end
map.height = y

map.is_marked = function(self, x, y)
  return map[x .. "," .. y]
end

guard.is_on = function(self, map)
  return self.x > 0 and self.y > 0 and self.x <= map.width and self.y <= map.height
end

guard.step = function(self, delta)
  if self.direction == up then
    self.y = self.y - delta
  elseif self.direction == down then
    self.y = self.y + delta
  elseif self.direction == left then
    self.x = self.x - delta
  else
    self.x = self.x + delta
  end
end

guard.turn = function(self)
  self.direction = (self.direction + 1) % 4
end

guard.move = function(self, map)
  self:step(1)
  if map:is_marked(self.x, self.y) then
    self:step(-1)
    self:turn()
  end
end

local trail = { mark = mark }
trail.length = function(self)
  local l = 0
  for _, v in pairs(self) do
    if v == true then
      l = l + 1
    end
  end
  return l
end

while guard:is_on(map) do
  trail:mark(guard.x, guard.y)
  guard:move(map)
end

print(trail:length())
