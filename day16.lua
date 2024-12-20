local i = require('input_utils.lua')
local m = require('map_utils.lua')

local map = i.read_matrix('input/day16.txt')
m.matrix_map(map)
map.is_free = function(self, c) return self[c] ~= '#' end
map.is_goal = function(self, c) return self[c] == 'E' end

local start
map:scan { S = function(c) start = c end }

local function reindeer(pos, heading, score)
  if not score then score = 0 end
  return {
    pos = pos,
    heading = heading,
    score = score,
    turn_left = function(self)
      if self.heading == 'e' then return reindeer(self.pos, 'n', self.score + 1000)
      elseif self.heading == 'n' then return reindeer(self.pos, 'w', self.score + 1000)
      elseif self.heading == 'w' then return reindeer(self.pos, 's', self.score + 1000)
      else return reindeer(self.pos, 'e', self.score + 1000)
      end
    end,
    turn_right = function(self)
      if self.heading == 'e' then return reindeer(self.pos, 's', self.score + 1000)
      elseif self.heading == 'n' then return reindeer(self.pos, 'e', self.score + 1000)
      elseif self.heading == 'w' then return reindeer(self.pos, 'n', self.score + 1000)
      else return reindeer(self.pos, 'w', self.score + 1000)
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
      return reindeer(self:in_front(), self.heading, self.score + 1)
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
