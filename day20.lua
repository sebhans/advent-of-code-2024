local i = require('input_utils.lua')
local m = require('map_utils.lua')

local map = i.read_matrix('input/day20.txt')
m.matrix_map(map)
map.is_free = function(self, e) return self[e] ~= '#' end
map.is_goal = function(self, e) return self[e] == 'E' end

local start
map:scan { S = function(coord) start = coord end }

local trace = m.empty_matrix_map(map:width(), map:height(), '.')
local path = {}

local pos = start
local prev_pos = nil
local n = 0
repeat
  trace:put(pos, n)
  path[#path + 1] = pos
  n = n + 1
  if     map:is_free(pos:left())  and pos:left()  ~= prev_pos then prev_pos, pos = pos, pos:left()
  elseif map:is_free(pos:right()) and pos:right() ~= prev_pos then prev_pos, pos = pos, pos:right()
  elseif map:is_free(pos:up())    and pos:up()    ~= prev_pos then prev_pos, pos = pos, pos:up()
  elseif map:is_free(pos:down())  and pos:down()  ~= prev_pos then prev_pos, pos = pos, pos:down()
  else
    print('dead end at', pos)
    os.exit(1)
  end
until map:is_goal(pos)
trace:put(pos, n)
path[#path + 1] = pos

local function reachable_with_cheat(p, max_cheat_time)
  local dx, dy = -1, -max_cheat_time
  return function()
    dx = dx + 1
    if math.abs(dx) + math.abs(dy) > max_cheat_time then
      dy = dy + 1
      if dy > max_cheat_time then
        return nil
      end
      dx = -(max_cheat_time - math.abs(dy))
    end
    return p:translate(dx, dy), math.abs(dx) + math.abs(dy)
  end
end

local function cheat(max_cheat_time, desired_min_saving)
  local time_saving_cheats = 0
  for _, p in ipairs(path) do
    local t1 = trace:at(p)
    for c, ct in reachable_with_cheat(p, max_cheat_time) do
      local t2 = trace:at(c)
      if type(t2) == "number" and t2 >= t1 + ct + desired_min_saving then
        time_saving_cheats = time_saving_cheats + 1
      end
    end
  end
  print(time_saving_cheats)
end

cheat(2, 100)
cheat(20, 100)
