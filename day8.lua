local function read_input()
  local antennas, width, y =  {}, 0, 0
  for line in io.lines('input/day8.txt') do
    y = y + 1
    local x = 0
    for c in line:gmatch("([A-Za-z0-9.])") do
      x = x + 1
      if c ~= "." then
        if antennas[c] then
          table.insert(antennas[c], {x, y})
        else
          antennas[c] = {{x, y}}
        end
      end
    end
    width = x
  end
  return antennas, width, y
end

local antennas, width, height = read_input()

local function add_antinode(antinodes, x, y)
  if x > 0 and x <= width and y > 0 and y <= height then
    antinodes[x .. "," .. y] = true
  end
end

local function count_keys(t)
  local n = 0
  for _ in pairs(t) do
    n = n + 1
  end
  return n
end

local antinodes = {}
for _, coordinates in pairs(antennas) do
  for i = 1, #coordinates - 1 do
    local a1x, a1y = table.unpack(coordinates[i])
    for j = i + 1, #coordinates do
      local a2x, a2y = table.unpack(coordinates[j])
      local dx = a1x - a2x
      local dy = a1y - a2y
      add_antinode(antinodes, a1x + dx, a1y + dy)
      add_antinode(antinodes, a2x - dx, a2y - dy)
    end
  end
end

print(count_keys(antinodes))
