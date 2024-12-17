local i = require('input_utils.lua')
local m = require('map_utils.lua')
local s = require('string_utils.lua')

local robots = {}
i.read_lines('input/day14.txt', "p=(%d+),(%d+) v=(-?%d+),(-?%d+)", function(x, y, vx, vy)
  robots[#robots + 1] = {x = x + 0, y = y + 0, vx = vx + 0, vy = vy + 0}
end)

local width, height = 101, 103

local function patrol(seconds)
  for _, r in ipairs(robots) do
    r.x = (r.x + seconds * r.vx) % width
    r.y = (r.y + seconds * r.vy) % height
  end
end

patrol(100)

local function count_robots(left, top, right, bottom)
  local n = 0
  for _, r in ipairs(robots) do
    if r.x >= left and r.x <= right and r.y >= top and r.y <= bottom then
      n = n + 1
    end
  end
  return n
end

print(count_robots(0, 0, width // 2 - 1, height // 2 - 1)
      * count_robots(width // 2 + 1, 0, width - 1, height // 2 - 1)
      * count_robots(0, height // 2 + 1, width // 2 - 1, height - 1)
      * count_robots(width // 2 + 1, height // 2 + 1, width - 1, height - 1))

robots = {}
i.read_lines('input/day14.txt', "p=(%d+),(%d+) v=(-?%d+),(-?%d+)", function(x, y, vx, vy)
  robots[#robots + 1] = {x = x + 0, y = y + 0, vx = vx + 0, vy = vy + 0}
end)

local function render_robots()
  local map = m.sparse_map(0, 0, width, height)
  for _, r in ipairs(robots) do
    map:add(r.x, r.y, '#')
  end
  return map:tostring()
end

local function has_a_row(map)
  local lines = s.split(map, "\n")
  for _, line in ipairs(lines) do
    if line:match('##########') then
      return true
    end
  end
  return false
end

for j = 0, 10000 do
  local map = render_robots()
  if has_a_row(map) then
    print(j)
    print(map)
  end

  patrol(1)
  j = j + 1
end
