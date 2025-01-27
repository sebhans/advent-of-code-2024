local c = require('collection_utils.lua')
local i = require('input_utils.lua')
local t = require('table_utils.lua')

local function add(to_add)
  return function(set)
    set:add(to_add)
    return set
  end
end

local connections = {}
i.read_lines('input/day23.txt', '(%w+)-(%w+)', function(a, b)
  t.update_value(connections, a, c.set(b), add(b))
  t.update_value(connections, b, c.set(a), add(a))
end)

local parties = {}
for computer, connected in pairs(connections) do
  if connected:size() >= 2 then
    for a in connected:elements() do
      for b in connected:elements() do
        if a ~= b and connections[a]:contains(b) then
          local party = {computer, a, b}
          table.sort(party)
          local party_key = party[1]..'-'..party[2]..'-'..party[3]
          if party_key:match('t%w') then
            parties[party_key] = true
          end
        end
      end
    end
  end
end
print(t.size(parties))

local fully_connected = {}
for computer, _ in pairs(connections) do
  fully_connected[computer] = c.set(computer)
end
for computer, connected in pairs(connections) do
  local party = fully_connected[computer]
  for candidate in connected:elements() do
    if not party:contains(candidate) then
      if connections[candidate] and connections[candidate]:contains_all(party) then
        party:add(candidate)
        for participant in party:elements() do
          fully_connected[participant] = party
        end
      end
    end
  end
end

local largest_party = nil
local largest_size = 0
for _, party in pairs(fully_connected) do
  if party:size() > largest_size then
    largest_party = party
    largest_size = party:size()
  end
end
local largest_party_computers = largest_party:to_array()
table.sort(largest_party_computers)
local first = true
for _, computer in ipairs(largest_party_computers) do
  if not first then
    io.write(',')
  else
    first = false
  end
  io.write(computer)
end
print()
