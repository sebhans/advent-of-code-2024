local i = require('input_utils.lua')

local pruner = 16777216

local function advance(n, iterations)
  if not iterations then
    iterations = 1
  end
  if iterations == 0 then
    return n
  end
  n = (n ~ (n << 6)) % pruner
  n = (n ~ (n >> 5)) % pruner
  n = (n ~ (n << 11)) % pruner
  return advance(n, iterations - 1)
end

local sum = 0
i.read_numbers('input/day22.txt', function(secret)
  sum = sum + advance(secret + 0, 2000)
end)
print(sum)
