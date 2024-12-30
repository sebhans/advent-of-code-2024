local c = require('collection_utils.lua')
local i = require('input_utils.lua')
local m = require('map_utils.lua')

local dimension = 71

local map = m.empty_matrix_map(dimension, dimension)
local n = 0
i.read_lines('input/day18.txt', function(line)
  n = n + 1
  if n <= 1024 then
    map:put(m.coord(line):translate(1, 1), '#')
  end
end)

local heads = { { pos = m.coord(1, 1), n = 0 } }
local finished = false
local visited = c.empty_set()
visited:add(heads[1].pos)
local steps
while not finished do
  local head = table.remove(heads, 1)
  if head.pos.x == dimension and head.pos.y == dimension then
    finished = true
    steps = head.n
  else
    local function try(coord)
      local k = coord:key()
      if map:at(coord) == '.' and not visited:contains(k) then
        table.insert(heads, {pos = coord, n = head.n + 1})
        visited:add(k)
      end
    end
    try(head.pos:left())
    try(head.pos:right())
    try(head.pos:up())
    try(head.pos:down())
  end
end
print(steps)
