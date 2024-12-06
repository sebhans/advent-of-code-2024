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
  return self[x .. "," .. y]
end

guard.is_on = function(self, cur_map)
  return self.x > 0 and self.y > 0 and self.x <= cur_map.width and self.y <= cur_map.height
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

function shallow_clone(o)
  local o2 = {}
  for k, v in pairs(o) do
    o2[k] = v
  end
  return o2
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

local g = shallow_clone(guard)
while g:is_on(map) do
  trail:mark(g.x, g.y)
  g:move(map)
end

print(trail:length())

function mark_detecting_loop(self, x, y, d)
  local key = x .. "," .. y
  if not self[key] then
    self[key] = { d = true }
  elseif self[key][d] then
    return "loop"
  else
    self[key][d] = true
  end
end

function map_with_obstacle_at(position)
  local m = {}
  for k, v in pairs(map) do
    m[k] = v
  end
  m[position] = true
  return m
end

function does_loop(guard, my_map)
  local trail = { mark = mark_detecting_loop }
  while guard:is_on(my_map) do
    if trail:mark(guard.x, guard.y, guard.direction) == "loop" then
      return true
    end
    guard:move(my_map)
  end
  return false
end

local num_looping_obstacle_positions = 0
local n = 1
for pos, is_mark in pairs(trail) do
  if is_mark == true and pos ~= guard.x .. "," .. guard.y then
    n = n + 1
    local g = shallow_clone(guard)
    local m = map_with_obstacle_at(pos)
    if does_loop(g, m) then
      num_looping_obstacle_positions = num_looping_obstacle_positions + 1
    end
  end
end

print(num_looping_obstacle_positions)
