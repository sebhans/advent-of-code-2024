local i = require('input_utils.lua')
local d = require('debug_utils.lua')

local robots = {}
i.read_lines('input/day14.txt', "p=(%d+),(%d+) v=(-?%d+),(-?%d+)", function(x, y, vx, vy)
  robots[#robots + 1] = {x = x + 0, y = y + 0, vx = vx + 0, vy = vy + 0}
end)

local width, height = 101, 103

local function patrol(seconds)
  for i, r in ipairs(robots) do
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
