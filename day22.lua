local c = require('collection_utils.lua')
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

local function simulate_monkey(secret)
  local c1, c2, c3, c4
  local prev_price = secret % 10
  local price_by_sequence = {}
  for _ = 1, 2000 do
    secret = advance(secret)
    local price = secret % 10
    c1, c2, c3, c4 = c2, c3, c4, price - prev_price
    if c1 then
      local key = c1 .. ',' .. c2 .. ',' .. c3 .. ',' .. c4
      if not price_by_sequence[key] then
        price_by_sequence[key] = price
      end
    end
    prev_price = price
  end
  return price_by_sequence
end

local prices_by_sequence = {}
i.read_numbers('input/day22.txt', function(secret)
  prices_by_sequence[#prices_by_sequence + 1] = simulate_monkey(secret + 0)
end)

local function bananas_for_sequence(sequence)
  local bananas = 0
  for _, pbs in ipairs(prices_by_sequence) do
    if pbs[sequence] then
      bananas = bananas + pbs[sequence]
    end
  end
  return bananas
end

local sequences = c.empty_set()
for _, pbs in ipairs(prices_by_sequence) do
  for k, _ in pairs(pbs) do
    sequences:add(k)
  end
end

local most_bananas = 0
for sequence in sequences:elements() do
  most_bananas = math.max(most_bananas, bananas_for_sequence(sequence))
end
print(most_bananas)
