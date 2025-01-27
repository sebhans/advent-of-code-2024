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
