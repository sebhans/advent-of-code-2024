local f = require('function_utils.lua')
local i = require('input_utils.lua')
local regex = require('regex')
local s = require('string_utils.lua')

local available_patterns
local designs = {}
i.read_lines('input/day19.txt', function(line)
  if not available_patterns then
    available_patterns = s.extract(line, '[wubrg]+')
  elseif line == '' then
    -- ignore
  else
    designs[#designs + 1] = line
  end
end)

local any_pattern
for _, pattern in ipairs(available_patterns) do
  if any_pattern then
    any_pattern = any_pattern .. '|' .. pattern
  else
    any_pattern = pattern
  end
end
local valid_design = regex.new('^(' .. any_pattern .. ')+$')

local num_possible = 0
for _, design in ipairs(designs) do
  if valid_design:match(design) then
    num_possible = num_possible + 1
  end
end
print(num_possible)

local count_combinations
local function cc(design)
  if design == '' then
    return 1
  end
  local n = 0
  for _, pattern in ipairs(available_patterns) do
    if s.starts_with(design, pattern) then
      n = n + count_combinations(string.sub(design, #pattern + 1))
    end
  end
  return n
end

count_combinations = f.memoize(cc)

local n = 0
for _, design in ipairs(designs) do
  if valid_design:match(design) then
    n = n + count_combinations(design)
  end
end
print(n)
