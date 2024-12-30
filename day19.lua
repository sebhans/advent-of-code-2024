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
