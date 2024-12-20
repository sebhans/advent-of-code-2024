local m = require('map_utils.lua')
local o = require('output_utils.lua')

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

local function is_wall(c) return map:at(c) == "#" end
local function is_box(c) return map:at(c) == "O" end
local function is_free(c) return map:at(c) == "." end
local function can_move(c) return not is_wall(c) end

local function move(c, movement)
  local target = nil
  if movement == "^" then target = c:up()
  elseif movement == "v" then target = c:down()
  elseif movement == "<" then target = c:left()
  else target = c:right()
  end
  if not can_move(target) then return false end
  if is_box(target) then
    if not move(target, movement) then
      return false
    end
  end
  map:put(target, map:at(c))
  map:put(c, ".")
  return target
end

for movement in movements:gmatch(".") do
  local t = move(robot, movement)
  if t then
    robot = t
  end
end

local sum = 0
for c in map:coordinates() do
  if is_box(c) then
    sum = sum + c.x - 1 + 100 * (c.y - 1)
  end
end
print(sum)
