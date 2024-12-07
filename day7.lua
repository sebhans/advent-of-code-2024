local lpeg = require('lpeg')
local p_n = lpeg.C(lpeg.R'09'^1)
local p_equation = p_n * lpeg.S(':') * (lpeg.S(' ') * p_n)^1

local function is_possible(test_value, operands, i)
  local n = operands[i] + 0
  if i == 1 then
    return n == test_value
  end
  if n <= test_value and is_possible(test_value - n, operands, i - 1) then
    return true
  end
  if test_value % n == 0 and is_possible(test_value // n, operands, i - 1) then
    return true
  end
  return false
end

local total_calibration_result = 0
for line in io.lines('input/day7.txt') do
  local numbers = { p_equation:match(line) }
  local test_value = numbers[1]
  table.remove(numbers, 1)
  if is_possible(test_value + 0, numbers, #numbers) then
    total_calibration_result = total_calibration_result + test_value
  end
end

print(total_calibration_result)
