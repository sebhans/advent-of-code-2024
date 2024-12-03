local sum = 0
for line in io.lines('input/day3.txt') do
  for a, b in string.gmatch(line, "mul[(](%d%d?%d?),(%d%d?%d?)[)]") do
    sum = sum + a * b
  end
end

print(sum)

local lpeg = require('lpeg')
local p_number = lpeg.C(lpeg.R'09' * lpeg.R'09'^-2)
local p_mul = lpeg.C(lpeg.P'mul') * lpeg.P'(' * p_number * lpeg.P',' * p_number * lpeg.P')'
local p_do = lpeg.C(lpeg.P'do') * lpeg.P'()'
local p_dont = lpeg.C(lpeg.P"don't") * lpeg.P'()'
local p_instruction = p_do + p_dont + p_mul

local more_accurate_sum = 0
local is_enabled = true
for line in io.lines('input/day3.txt') do
  for i = 1, #line do
    op, a, b = p_instruction:match(line, i)
    if op == 'do' then
      is_enabled = true
    elseif op == "don't" then
      is_enabled = false
    elseif op == 'mul' and is_enabled then
      more_accurate_sum = more_accurate_sum + a * b
    end
  end
end

print(more_accurate_sum)
