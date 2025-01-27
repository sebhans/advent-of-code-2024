local c = require('collection_utils.lua')
local lpeg = require('lpeg')

local values = {}
local gates = {}
local output_wires = c.empty_set()

local function gather_output_wire(wire)
  if string.match(wire, "^z") then
    output_wires:add(wire)
  end
end

local function read_initial_value(wire, bit)
  if bit == "1" then
    values[wire] = true
  else
    values[wire] = false
  end
  gather_output_wire(wire)
end

local function and_gate(value1, value2)
  return value1 and value2
end

local function or_gate(value1, value2)
  return value1 or value2
end

local function xor_gate(value1, value2)
  return value1 ~= value2
end

local function read_gate_definition(source1, operator, source2, destination)
  gather_output_wire(destination)
  local gate
  if operator == "AND" then
    gate = and_gate
  elseif operator == "OR" then
    gate = or_gate
  else
    gate = xor_gate
  end
  gates[destination] = {
    source1 = source1,
    source2 = source2,
    eval = gate,
  }
end

local p_input = lpeg.P {
  "input";
  input = lpeg.V"initial_values" * lpeg.P"\n" * lpeg.V"gate_definitions",
  initial_values = lpeg.V"initial_value" ^ 1,
  initial_value = (lpeg.V"wire" * lpeg.P": " * lpeg.V"bit" * lpeg.P"\n") / read_initial_value,
  wire = lpeg.C(lpeg.S("abcdefghijklmnopqrstuvwxyz0123456789") ^ 2),
  bit = lpeg.C(lpeg.S("01")),
  gate_definitions = lpeg.V"gate_definition" ^ 1,
  gate_definition = (lpeg.V"wire" * lpeg.P(" ") * lpeg.V"operator" * lpeg.P" " * lpeg.V"wire" * lpeg.P(" -> ") * lpeg.V"wire" * lpeg.P"\n") / read_gate_definition,
  operator = lpeg.C(lpeg.P"AND" + lpeg.P"OR" + lpeg.P"XOR"),
}

p_input:match(io.open('input/day24.txt'):read("a"))

local function energize(wire)
  local value = values[wire]
  if value ~= nil then
    return value
  end

  local gate = gates[wire]
  local input1 = energize(gate.source1)
  local input2 = energize(gate.source2)
  local result = gate.eval(input1, input2)
  values[wire] = result
  return result
end

for wire in output_wires:elements() do
  energize(wire)
end

output_wires = output_wires:to_array()
table.sort(output_wires, function(a, b) return b < a end)
local result = 0
for _, wire in ipairs(output_wires) do
  result = result << 1
  if values[wire] then
    result = result + 1
  end
end
print(result)
