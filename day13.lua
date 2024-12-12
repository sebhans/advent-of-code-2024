local i = require('input_utils.lua')
local lpeg = require('lpeg')

local machine = lpeg.P {
  "machine";
  machine = lpeg.V"button" * lpeg.V"button" * lpeg.V"prize",
  button = lpeg.P"Button " * lpeg.P(1) * lpeg.P": X+" * lpeg.V"number" * lpeg.P", Y+" * lpeg.V"number" * lpeg.P"\n",
  prize = lpeg.P"Prize: X=" * lpeg.V"number" * lpeg.P", Y=" * lpeg.V"number",
  number = lpeg.C(lpeg.R'09'^1),
}

local function price(na, nb)
  return na * 3 + nb
end

local function is_solved(na, ax, ay, nb, bx, by, x, y)
  return na >= 0 and nb >= 0 and na * ax + nb * bx == x and na * ay + nb * by == y
end

local function solve(ax, ay, bx, by, x, y)
  local na1 = (x - bx * y / by) / (ax - bx * ay / by)
  local nb1 = (y - ay * na1) / by
  local nb2 = (y - ay * x / ax) / (by - ay * bx / ax)
  local na2 = (x - bx * nb2) / ax
  na1 = math.floor(na1)
  nb1 = math.floor(nb1)
  na2 = math.floor(na2)
  nb2 = math.floor(nb2)
  if is_solved(na1, ax, ay, nb1, bx, by, x, y) then
    return na1, nb1
  elseif is_solved(na1+1, ax, ay, nb1, bx, by, x, y) then
    return na1+1, nb1
  elseif is_solved(na1, ax, ay, nb1+1, bx, by, x, y) then
    return na1, nb1+1
  elseif is_solved(na1+1, ax, ay, nb1+1, bx, by, x, y) then
    return na1+1, nb1+1
  elseif is_solved(na2, ax, ay, nb2, bx, by, x, y) then
    return na2, nb2
  elseif is_solved(na2+1, ax, ay, nb2, bx, by, x, y) then
    return na2+1, nb2
  elseif is_solved(na2, ax, ay, nb2+1, bx, by, x, y) then
    return na2, nb2+1
  elseif is_solved(na2+1, ax, ay, nb2+1, bx, by, x, y) then
    return na2+1, nb2+1
  end
end

local total_price = 0
i.read_paragraphs('input/day13.txt', function(p)
  local ax, ay, bx, by, x, y = machine:match(p)
  local na, nb = solve(ax + 0, ay + 0, bx + 0, by + 0, x + 0, y + 0)
  if na then
    total_price = total_price + price(na, nb)
  end
end)
print(total_price)

local corrected_total_price = 0
i.read_paragraphs('input/day13.txt', function(p)
  local ax, ay, bx, by, x, y = machine:match(p)
  x = x + 10000000000000
  y = y + 10000000000000
  local na, nb = solve(ax + 0, ay + 0, bx + 0, by + 0, x, y)
  if na then
    corrected_total_price = corrected_total_price + price(na, nb)
  end
end)
print(corrected_total_price)
