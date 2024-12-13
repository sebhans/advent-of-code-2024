local i = require('input_utils.lua')
local lpeg = require('lpeg')

local machine = lpeg.P {
  "machine";
  machine = lpeg.V"button" * lpeg.V"button" * lpeg.V"prize",
  button = lpeg.P"Button " * lpeg.P(1) * lpeg.P": X+" * lpeg.V"number" * lpeg.P", Y+" * lpeg.V"number" * lpeg.P"\n",
  prize = lpeg.P"Prize: X=" * lpeg.V"number" * lpeg.P", Y=" * lpeg.V"number",
  number = lpeg.C(lpeg.R'09'^1),
}

local function maximize_b(ax, ay, bx, by, x, y)
  for nb = math.min(x // bx, y // by, 100), 0, -1 do
    if (x - nb * bx) % ax == 0 and (y - nb * by) % ay == 0 then
      local na = (x - nb * bx) // ax
      if na <= 100 and na * ay + nb * by == y + 0 then
        return na, nb
      end
    end
  end
end

local function price(na, nb)
  return na * 3 + nb
end

local function solve(ax, ay, bx, by, x, y)
  local na1, nb1 = maximize_b(ax, ay, bx, by, x, y)
  local nb2, na2 = maximize_b(bx, by, ax, ay, x, y)
  if na1 then
    local p1 = price(na1, nb1)
    if na2 then
      local p2 = price(na2, nb2)
      return math.min(p1, p2)
    else
      return p1
    end
  elseif na2 then
    return price(na2, nb2)
  end
end

local total_price = 0
i.read_paragraphs('input/day13.txt', function(p)
  local price = solve(machine:match(p))
  if price then
    total_price = total_price + price
  end
end)

print(total_price)
