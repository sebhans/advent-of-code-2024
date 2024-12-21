local lpeg = require('lpeg')

local debugger = lpeg.P {
  "debugger";
  debugger = lpeg.V"register" ^ 3 * lpeg.P"\n" * lpeg.V"program",
  register = lpeg.P"Register " * lpeg.P(1) * lpeg.P": " * lpeg.V"number" * lpeg.P"\n",
  program = lpeg.P"Program: " * lpeg.V"number_list",
  number_list = lpeg.V"number" * (lpeg.P"," * lpeg.V"number") ^ 0,
  number = lpeg.C(lpeg.R'09' ^ 1),
}

local function combo(operand, a, b, c)
  if operand < 4 then return operand
  elseif operand == 4 then return a
  elseif operand == 5 then return b
  elseif operand == 6 then return c
  else return nil
  end
end

local optable = {
  [0] = function(ip, a, b, c, operand)
    return ip + 2, a // math.tointeger(2 ^ combo(operand, a, b, c)), b, c
  end,
  [1] = function(ip, a, b, c, operand)
    return ip + 2, a, b ~ operand, c
  end,
  [2] = function(ip, a, b, c, operand)
    return ip + 2, a, combo(operand, a, b, c) % 8, c
  end,
  [3] = function(ip, a, b, c, operand)
    if a == 0 then
      return ip + 2, a, b, c
    else
      return operand, a, b, c
    end
  end,
  [4] = function(ip, a, b, c, operand)
    return ip + 2, a, b ~ c, c
  end,
  [5] = function(ip, a, b, c, operand)
    return ip + 2, a, b, c, combo(operand, a, b, c) % 8
  end,
  [6] = function(ip, a, b, c, operand)
    return ip + 2, a, a // math.tointeger(2 ^ combo(operand, a, b, c)), b
  end,
  [7] = function(ip, a, b, c, operand)
    return ip + 2, a, b, a // math.tointeger(2 ^ combo(operand, a, b, c))
  end,
}

local function step(program, ip, a, b, c)
  return optable[program[ip + 1]](ip, a, b, c, program[ip + 2])
end

local function run(a, b, c, ...)
  local program = {}
  for i = 1, select('#', ...) do
    program[#program + 1] = select(i, ...) + 0
  end

  local ip = 0
  local output, out = nil, nil
  while ip < #program do
    ip, a, b, c, out = step(program, ip, a, b, c)
    if out then
      if output then
        output = output .. "," .. out
      else
        output = out
      end
    end
  end
  return output
end

print(run(debugger:match(io.open("input/day17.txt"):read("a"))))
