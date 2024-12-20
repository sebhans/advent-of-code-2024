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

local function is_wall(map, c) return map:at(c) == "#" end
local function is_box(map, c) return map:at(c) == "O" end
local function can_move(map, c) return not is_wall(map, c) end

local function move(map, c, movement)
  local target = nil
  if movement == "^" then target = c:up()
  elseif movement == "v" then target = c:down()
  elseif movement == "<" then target = c:left()
  else target = c:right()
  end
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
