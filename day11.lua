local function read_stones()
  local stones = {}
  for line in io.lines('input/day11.txt') do
    for stone in line:gmatch("([0-9]+)") do
      stones[#stones + 1] = stone
    end
  end
  return stones
end

local function blink(stones)
  local s = {}
  for _, stone in ipairs(stones) do
    if stone == '0' then
      s[#s + 1] = '1'
    elseif #stone % 2 == 0 then
      s[#s + 1] = (stone:sub(1, #stone // 2) + 0) .. ''
      s[#s + 1] = (stone:sub(#stone // 2 + 1) + 0) .. ''
    else
      s[#s + 1] = (stone * 2024) .. ''
    end
  end
  return s
end

local stones = read_stones()
for _ = 1, 25 do
  stones = blink(stones)
end
print(#stones)
