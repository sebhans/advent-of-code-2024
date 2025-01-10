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

local function reachable_with_cheat(p)
  local l = p:left()
  local r = p:right()
  return ipairs({ l:left(), l:up(), l:down(), p:up():up(), p:down():down(), r:right(), r:up(), r:down() })
end

local time_saving_cheats = 0
local desired_min_saving = 100
for _, p in ipairs(path) do
  local t1 = trace:at(p)
  for _, c in reachable_with_cheat(p) do
    local t2 = trace:at(c)
    if type(t2) == "number" and t2 > t1 + 1 + desired_min_saving then
      time_saving_cheats = time_saving_cheats + 1
    end
  end
end
print(time_saving_cheats)
