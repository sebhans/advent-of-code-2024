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
