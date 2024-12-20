local c = require('collection_utils.lua')
local i = require('input_utils.lua')
local m = require('map_utils.lua')

local map = i.read_matrix('input/day16.txt')
m.matrix_map(map)
map.is_free = function(self, e) return self[e] ~= '#' end
map.is_goal = function(self, e) return self[e] == 'E' end

local start
map:scan { S = function(coord) start = coord end }

local function reindeer(pos, heading, score, path)
  if not score then score = 0 end
  if not path then path = { pos } end
  return {
    pos = pos,
    heading = heading,
    score = score,
    path = path,
    turn_left = function(self)
      if self.heading == 'e' then return reindeer(self.pos, 'n', self.score + 1000, path)
      elseif self.heading == 'n' then return reindeer(self.pos, 'w', self.score + 1000, path)
      elseif self.heading == 'w' then return reindeer(self.pos, 's', self.score + 1000, path)
      else return reindeer(self.pos, 'e', self.score + 1000, path)
      end
    end,
    turn_right = function(self)
      if self.heading == 'e' then return reindeer(self.pos, 's', self.score + 1000, path)
      elseif self.heading == 'n' then return reindeer(self.pos, 'e', self.score + 1000, path)
      elseif self.heading == 'w' then return reindeer(self.pos, 'n', self.score + 1000, path)
      else return reindeer(self.pos, 'w', self.score + 1000, path)
      end
    end,
    in_front = function(self)
      if self.heading == 'n' then return self.pos:up()
      elseif self.heading == 's' then return self.pos:down()
      elseif self.heading == 'w' then return self.pos:left()
      else return self.pos:right()
      end
    end,
    to_the_left = function(self)
      if self.heading == 'n' then return self.pos:left()
      elseif self.heading == 's' then return self.pos:right()
      elseif self.heading == 'w' then return self.pos:down()
      else return self.pos:up()
      end
    end,
    to_the_right = function(self)
      if self.heading == 'n' then return self.pos:right()
      elseif self.heading == 's' then return self.pos:left()
      elseif self.heading == 'w' then return self.pos:up()
      else return self.pos:down()
      end
    end,
    go = function(self)
      local in_front = self:in_front()
      local p = c.shallow_copy_array(self.path)
      p[#p + 1] = in_front
      return reindeer(in_front, self.heading, self.score + 1, p)
    end,
  }
end

local visited = {}
visited[start:key()] = true

local function by_score(a, b) return a.score < b.score end

local function run(reindeers)
  table.sort(reindeers, by_score)
  local r = table.remove(reindeers, 1)
  if map:is_goal(r.pos) then
    return r
  end
  local in_front = r:in_front()
  local to_the_left = r:to_the_left()
  local to_the_right = r:to_the_right()
  if not visited[in_front:key()] and map:is_free(in_front) then reindeers[#reindeers + 1] = r:go() end
  if not visited[to_the_left:key()] and map:is_free(to_the_left) then reindeers[#reindeers + 1] = r:turn_left():go() end
  if not visited[to_the_right:key()] and map:is_free(to_the_right) then reindeers[#reindeers + 1] = r:turn_right():go() end
  visited[in_front:key()] = true
  visited[to_the_left:key()] = true
  visited[to_the_right:key()] = true
  return run(reindeers)
end

local winner = run { reindeer(start, 'e') }
print(winner.score)

local min_scores = {}
local function search(reindeers, arrivals)
  if #reindeers == 0 then
    return arrivals
  end
  table.sort(reindeers, by_score)
  local r = reindeers[1]
  table.remove(reindeers, 1)
  if r.score > winner.score then
    -- drop it
  elseif map:is_goal(r.pos) then
    arrivals[#arrivals + 1] = r
  else
    local function try(pos, score_delta, move)
      if map:is_free(pos) then
        local key = pos:key()
        local next = move()
        local min_score = min_scores[key]
        if not min_score or min_score >= next.score - score_delta then
          reindeers[#reindeers + 1] = next
          min_scores[key] = next.score
        end
      end
    end
    try(r:in_front(), 1000, function() return r:go() end)
    try(r:to_the_left(), 0, function() return r:turn_left():go() end)
    try(r:to_the_right(), 0, function() return r:turn_right():go() end)
  end
  return search(reindeers, arrivals)
end

local best_paths = search({ reindeer(start, 'e') }, {})
local tiles = c.empty_set()
for _, r in ipairs(best_paths) do
  for _, pos in ipairs(r.path) do
    tiles:add(pos:key())
  end
end
print(tiles:size())
