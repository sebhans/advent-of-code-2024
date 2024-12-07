local lpeg = require('lpeg')
local p_n = lpeg.C(lpeg.R'09'^1)
local p_equation = p_n * lpeg.S(':') * (lpeg.S(' ') * p_n)^1

local function is_possible(test_value, n, operands, i)
  if i > #operands then
    return n == test_value
  end
  local m = operands[i] + 0
  if is_possible(test_value, n + m, operands, i + 1) then
    return true
  end
  if is_possible(test_value, n * m, operands, i + 1) then
    return true
  end
  return false
end

local function calibrate(is_possible)
  local total_calibration_result = 0
  for line in io.lines('input/day7.txt') do
    local numbers = { p_equation:match(line) }
    local test_value = numbers[1]
    table.remove(numbers, 1)
    if is_possible(test_value + 0, numbers[1] + 0, numbers, 2) then
      total_calibration_result = total_calibration_result + test_value
    end
  end
  return total_calibration_result
end

print(calibrate(is_possible))

local function is_possible_with_concatenation(test_value, n, operands, i)
  if i > #operands then
    return n == test_value
  end
  local m = operands[i] + 0
  if is_possible_with_concatenation(test_value, n + m, operands, i + 1) then
    return true
  end
  if is_possible_with_concatenation(test_value, n * m, operands, i + 1) then
    return true
  end
  if is_possible_with_concatenation(test_value, (n .. m) + 0, operands, i + 1) then
    return true
  end
  return false
end

print(calibrate(is_possible_with_concatenation))
