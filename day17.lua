local coll = require('collection_utils.lua')
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

local function parse_program(_, _, _, ...)
  local program = {}
  for i = 1, select('#', ...) do
    program[#program + 1] = select(i, ...) + 0
  end
  return program
end

local program = parse_program(debugger:match(io.open("input/day17.txt"):read("a")))

local function does_match(a, program, expected_output)
  local ip, b, c = 0, 0, 0
  local out = nil
  while ip < #program do
    ip, a, b, c, out = step(program, ip, a, b, c)
    if out then
      if out ~= expected_output[1] then
        return false
      end
      table.remove(expected_output, 1)
    end
  end
  return #expected_output == 0
end

local function shallow_copy_tail(a, n)
  local copy = {}
  for i = #a - n + 1, #a do
    copy[#copy+1] = a[i]
  end
  return copy
end

local function find_next_bits(a, program, num_outputs)
  for i = 0, 7 do
    local eo = shallow_copy_tail(program, num_outputs)
    if does_match(a * 8 + i, program, eo) then
      if num_outputs == #program then
        return a * 8 + i
      end
      local complete_a = find_next_bits(a * 8 + i, program, num_outputs + 1)
      if complete_a then
        return complete_a
      end
    end
  end
  return nil
end

print(find_next_bits(0, program, 1))
