local input = require('input_utils.lua')
local t = require('table_utils.lua')

local function read_stones()
  local stones = {}
  input.read_numbers('input/day11.txt', function(stone) stones[stone] = 1 end)
  return stones
end

local function change(stone)
  if stone == '0' then
    return '1'
  elseif #stone % 2 == 0 then
      return (stone:sub(1, #stone // 2) + 0) .. '', (stone:sub(#stone // 2 + 1) + 0) .. ''
  else
    return (stone * 2024) .. ''
  end
end

local stones = read_stones()

local function blink()
  local new_stones = {}
  local function add_stones(s, n)
    t.update_value(new_stones, s, n, function(old) return old + n end)
  end

  for stone, n in pairs(stones) do
    if n > 0 then
      local s1, s2 = change(stone)
      add_stones(s1, n)
      if s2 then add_stones(s2, n) end
    end
  end

  stones = new_stones
end

for _ = 1, 25 do blink() end
print(t.sum_values(stones))

for _ = 26, 75 do blink() end
print(t.sum_values(stones))
