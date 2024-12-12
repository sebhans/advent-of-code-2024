local i = require('input_utils.lua')
local o = require('output_utils.lua')
local t = require('table_utils.lua')
local m = require('map_utils.lua')
local c = require('collection_utils.lua')

local map = m.matrix_map(i.read_matrix('input/day12.txt'))

local regions = c.empty_set()
local regions_by_coordinate = {}
for coord in map:coordinates() do
  local plant = map:at(coord)
  local region_nucleus = c.set(coord:key())
  local region = t.update_value(regions_by_coordinate, coord:key(), region_nucleus, function(old) return old:union(region_nucleus) end)
  if region == region_nucleus then
    regions:add(region)
  end

  local right = coord:right()
  local plant_right = map:at(right)
  if plant_right == plant then
    local rr = t.update_value(regions_by_coordinate, right:key(), region, function(old) return old:union(region) end)
    if rr ~= region then
      for k in region:elements() do
        regions_by_coordinate[k] = rr
      end
      regions:remove(region)
      region = rr
    else
      region:add(right:key())
    end
  end

  local down = coord:down()
  local plant_down = map:at(down)
  if plant_down == plant then
    local rd = t.update_value(regions_by_coordinate, down:key(), region, function(old) return old:union(region) end)
    if rd ~= region then
      for k in region:elements() do
        regions_by_coordinate[k] = rd
      end
      regions:remove(region)
      region = rd
    else
      region:add(down:key())
    end
  end
end

local function perimeter(region)
  local p = 0
  for key in region:elements() do
    local coord = m.coord(key)
    local plant = map:at(coord)
    if not region:contains(coord:up():key()) then p = p + 1 end
    if not region:contains(coord:down():key()) then p = p + 1 end
    if not region:contains(coord:left():key()) then p = p + 1 end
    if not region:contains(coord:right():key()) then p = p + 1 end
  end
  return p
end

local function total_fence_price_by_perimeter(regions)
  local total_fence_price = 0
  for region in regions:elements() do
    local size = region:size()
    local perimeter = perimeter(region)
    total_fence_price = total_fence_price + size * perimeter
  end
  return total_fence_price
end

print(total_fence_price_by_perimeter(regions))

local function bounds(region)
  local top, left, bottom, right = 1000000, 1000000, 0, 0
  for key in region:elements() do
    local coord = m.coord(key)
    if coord.y < top then top = coord.y end
    if coord.x < left then left = coord.x end
    if coord.y > bottom then bottom = coord.y end
    if coord.x > right then right = coord.x end
  end
  return top, left, bottom, right
end

local function sides(region)
  local top, left, bottom, right = bounds(region)
  local sides = 0

  for y = top, bottom do
    local s = 0
    local left_above_open, left_below_open = false, false
    for x = left, right do
      if region:contains(m.coord(x, y):key()) then
        local above_open = not region:contains(m.coord(x, y):up():key())
        if not left_above_open and above_open then s = s + 1 end
        left_above_open = above_open

        local below_open = not region:contains(m.coord(x, y):down():key())
        if not left_below_open and below_open then s = s + 1 end
        left_below_open = below_open
      else
        left_above_open, left_below_open = false, false
      end
    end
    sides = sides + s
  end

  for x = left, right do
    local s = 0
    local above_left_open, above_right_open = false, false
    for y = top, bottom do
      if region:contains(m.coord(x, y):key()) then
        local left_open = not region:contains(m.coord(x, y):left():key())
        if not above_left_open and left_open then s = s + 1 end
        above_left_open = left_open

        local right_open = not region:contains(m.coord(x, y):right():key())
        if not above_right_open and right_open then s = s + 1 end
        above_right_open = right_open
      else
        above_left_open, above_right_open = false, false
      end
    end
    sides = sides + s
  end

  return sides
end

local function total_fence_price_by_sides(regions)
  local total_fence_price = 0
  for region in regions:elements() do
    local size = region:size()
    local sides = sides(region)
    total_fence_price = total_fence_price + size * sides
  end
  return total_fence_price
end

print(total_fence_price_by_sides(regions))
