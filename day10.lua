local function read_map()
  local map, width, y =  {}, 0, 0
  for line in io.lines('input/day10.txt') do
    y = y + 1
    map[y] = {}
    local x = 0
    for h in line:gmatch("([0-9])") do
      x = x + 1
      map[y][x] = h + 0
    end
    width = x
  end
  return map, width, y
end

local map, width, height = read_map()

local function trailheads(map, width, height)
  local x, y = width, 0
  return function()
    while y <= height do
      if x >= width then
        x = 1
        y = y + 1
        if y > height then
          return nil
        end
      else
        x = x + 1
      end
      if map[y][x] == 0 then
        return x, y
      end
    end
  end
end

local function union(t1, t2)
  local t = {}
  for k, v in pairs(t1) do
    t[k] = v
  end
  for k, v in pairs(t2) do
    t[k] = v
  end
  return t
end

local function peaks_from(map, width, height, x, y, h)
  local function at(x, y)
    if x <= 0 or x > width or y <= 0 or y > height then
      return -1
    end
    return map[y][x]
  end

  if h == 9 then
    return {[x .. "," .. y] = true}
  end

  local peaks = {}
  if at(x - 1, y) == h + 1 then peaks = union(peaks, peaks_from(map, width, height, x - 1, y, h + 1)) end
  if at(x + 1, y) == h + 1 then peaks = union(peaks, peaks_from(map, width, height, x + 1, y, h + 1)) end
  if at(x, y - 1) == h + 1 then peaks = union(peaks, peaks_from(map, width, height, x, y - 1, h + 1)) end
  if at(x, y + 1) == h + 1 then peaks = union(peaks, peaks_from(map, width, height, x, y + 1, h + 1)) end
  return peaks
end

local function count_keys(t)
  local n = 0
  for _ in pairs(t) do
    n = n + 1
  end
  return n
end

local total_score = 0
for x, y in trailheads(map, width, height) do
  total_score = total_score + count_keys(peaks_from(map, width, height, x, y, 0))
end

print(total_score)

local function rating(map, width, height, x, y, h)
  local function at(x, y)
    if x <= 0 or x > width or y <= 0 or y > height then
      return -1
    end
    return map[y][x]
  end

  if h == 9 then
    return 1
  end

  local r = 0
  if at(x - 1, y) == h + 1 then r = r + rating(map, width, height, x - 1, y, h + 1) end
  if at(x + 1, y) == h + 1 then r = r + rating(map, width, height, x + 1, y, h + 1) end
  if at(x, y - 1) == h + 1 then r = r + rating(map, width, height, x, y - 1, h + 1) end
  if at(x, y + 1) == h + 1 then r = r + rating(map, width, height, x, y + 1, h + 1) end
  return r
end

local total_rating = 0
for x, y in trailheads(map, width, height) do
  total_rating = total_rating + rating(map, width, height, x, y, 0)
end

print(total_rating)
