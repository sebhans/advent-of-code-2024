local i = require('input_utils.lua')

local locks = {}
local function read_lock(lock)
  local pins = {0, 0, 0, 0, 0}
  for p1, p2, p3, p4, p5 in lock:gmatch('([.#])([.#])([.#])([.#])([.#])') do
    if p1 == '#' then pins[1] = pins[1] + 1 end
    if p2 == '#' then pins[2] = pins[2] + 1 end
    if p3 == '#' then pins[3] = pins[3] + 1 end
    if p4 == '#' then pins[4] = pins[4] + 1 end
    if p5 == '#' then pins[5] = pins[5] + 1 end
  end
  locks[#locks + 1] = pins
end

local keys = {}
local function read_key(key)
  local pins = {5, 5, 5, 5, 5}
  for p1, p2, p3, p4, p5 in key:gmatch('([.#])([.#])([.#])([.#])([.#])') do
    if p1 == '.' then pins[1] = pins[1] - 1 end
    if p2 == '.' then pins[2] = pins[2] - 1 end
    if p3 == '.' then pins[3] = pins[3] - 1 end
    if p4 == '.' then pins[4] = pins[4] - 1 end
    if p5 == '.' then pins[5] = pins[5] - 1 end
  end
  keys[#keys + 1] = pins
end

i.read_paragraphs('input/day25.txt', function(paragraph)
  local is_lock = paragraph:match('^#####\n')
  if is_lock then
    read_lock(paragraph:match('^#####\n(.*)\n[.][.][.][.][.]'))
  else
    read_key(paragraph:match('^[.][.][.][.][.]\n(.*)\n#####'))
  end
end)

local function fits(key, lock)
  for t = 1, 5 do
    if key[t] + lock[t] > 5 then
      return false
    end
  end
  return true
end

local num_pairs_without_overlap = 0
for _, lock in ipairs(locks) do
  for _, key in ipairs(keys) do
    if fits(key, lock) then
      num_pairs_without_overlap = num_pairs_without_overlap + 1
    end
  end
end
print(num_pairs_without_overlap)
