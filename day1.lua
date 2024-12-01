local left_list = {}
local right_list = {}

local occurrances = {}
local default0 = {}
default0.__index = function(key) return 0 end
setmetatable(occurrances, default0)

for line in io.lines('input/day1.txt') do
  left, right = string.match(line, '(%d+)%s+(%d+)')
  table.insert(left_list, left)
  table.insert(right_list, right)
  occurrances[right] = occurrances[right] + 1
end
table.sort(left_list)
table.sort(right_list)

local diff = 0
for i = 1, #left_list do
  diff = diff + math.abs(left_list[i] - right_list[i])
end

print(diff)

local score = 0
for i = 1, #left_list do
  score = score + left_list[i] * occurrances[left_list[i]]
end

print(score)
