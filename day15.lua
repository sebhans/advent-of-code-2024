local m = require('map_utils.lua')
local o = require('output_utils.lua')
local t = require('table_utils.lua')

local map = {}
local rx, ry = nil, nil
local reading_map = true
local movements = ""
for line in io.lines("input/day15.txt") do
  if reading_map then
    if #line > 0 then
      local row = {}
      for c in line:gmatch("(.)") do
        if c == "@" then
          rx = #row + 1
          ry = #map + 1
        end
        row[#row + 1] = c
      end
      map[#map + 1] = row
    else
      reading_map = false
    end
  else
    movements = movements .. line
  end
end
m.matrix_map(map)
local robot = m.coord(rx, ry)
local original_robot = m.coord(rx, ry)
local original_map = t.clone(map)

local function is_wall(map, c) return map:at(c) == "#" end
local function is_box(map, c) return map:at(c) == "O" or map:at(c) == "[" or map:at(c) == "]" end
local function is_left_box(map, c) return map:at(c) == "[" end
local function is_right_box(map, c) return map:at(c) == "]" end
local function can_move(map, c) return not is_wall(map, c) end

local move

local function move_wide_box(map, c, movement, target)
  local wide = false
  if movement == "^" or movement == "v" then
    wide = true
    if not (can_move(map, target) and can_move(map, target:right())) then return false end
  end
  if movement == "<" and not can_move(map, target) then return false end
  local right = false
  if movement == ">" then
    target = target:right()
    right = true
    if not can_move(map, target) then return false end
  end
  local new_map = t.clone(map)
  if is_box(map, target) then
    new_map = move(map, target, movement)
    if not new_map then return false end
  end
  if wide and is_box(new_map, target:right()) then
    new_map = move(new_map, target:right(), movement)
    if not new_map then return false end
  end
  if wide then
    new_map:put(target, "[")
    new_map:put(target:right(), "]")
    new_map:put(c, ".")
    new_map:put(c:right(), ".")
  elseif right then
    new_map:put(target:left(), "[")
    new_map:put(target, "]")
    new_map:put(c, ".")
  else
    new_map:put(target, "[")
    new_map:put(target:right(), "]")
    new_map:put(c:right(), ".")
  end
  return new_map
end

move = function(map, c, movement)
  local target = nil
  if movement == "^" then target = c:up()
  elseif movement == "v" then target = c:down()
  elseif movement == "<" then target = c:left()
  else target = c:right()
  end
  if is_left_box(map, c) then return move_wide_box(map, c, movement, target) end
  if is_right_box(map, c) then return move_wide_box(map, c:left(), movement, target:left()) end
  if not can_move(map, target) then return false end
  local new_map
  if is_box(map, target) then
    local nm = move(map, target, movement)
    if not nm then
      return false
    end
    new_map = nm
  else
    new_map = t.clone(map)
  end
  new_map:put(target, new_map:at(c))
  new_map:put(c, ".")
  return new_map, target
end

for movement in movements:gmatch(".") do
  local n, t = move(map, robot, movement)
  if n then
    map = n
    robot = t
  end
end

local sum = 0
for c in map:coordinates() do
  if is_box(map, c) then
    sum = sum + c.x - 1 + 100 * (c.y - 1)
  end
end
print(sum)

local map2 = {}
for _, r in ipairs(original_map) do
  local r2 = {}
  for _, e in ipairs(r) do
    if e == "#" then
      r2[#r2 + 1] = "#"
      r2[#r2 + 1] = "#"
    elseif e == "." then
      r2[#r2 + 1] = "."
      r2[#r2 + 1] = "."
    elseif e == "@" then
      r2[#r2 + 1] = "@"
      r2[#r2 + 1] = "."
    elseif e == "O" then
      r2[#r2 + 1] = "["
      r2[#r2 + 1] = "]"
    end
  end
  map2[#map2 + 1] = r2
end
local robot2 = m.coord(original_robot.x * 2 - 1, original_robot.y)
m.matrix_map(map2)

for movement in movements:gmatch(".") do
  local n, t = move(map2, robot2, movement)
  if n then
    map2 = n
    robot2 = t
  end
end

local sum2 = 0
for c in map2:coordinates() do
  if is_left_box(map2, c) then
    -- sum2 = sum2 + math.min(c.x - 1, map2:width() - c.x - 1) + 100 * math.min(c.y - 1, map2:height() - c.y)
    sum2 = sum2 + c.x - 1 + 100 * (c.y - 1)
  end
end
print(sum2)
