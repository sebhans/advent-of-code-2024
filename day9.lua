local function read_input()
  local disk = {}
  local id = 0
  for line in io.lines('input/day9.txt') do
    for file, space in line:gmatch("([0-9])([0-9]?)") do
      for _ = 1, file do
        disk[#disk + 1] = id
      end
      if #space > 0 then
        for _ = 1, space do
          disk[#disk + 1] = '.'
        end
      end
      id = id + 1
    end
  end
  return disk
end

local disk = read_input()

local function defrag(disk)
  local space, cur = 0, #disk
  while space < cur do
    while disk[space] ~= '.' and space < cur do
      space = space + 1
    end
    if space < cur then
      disk[space] = disk[cur]
      disk[cur] = '.'
      cur = cur - 1
    end
  end
end

defrag(disk)

local function checksum_of(disk)
  local checksum = 0
  for i = 1, #disk do
    if disk[i] ~= '.' then
      checksum = checksum + (i - 1) * disk[i]
    end
  end
  return checksum
end

print(checksum_of(disk))

local function defrag_whole_files(disk)
  local function find_file(id)
    local start = 0
    for i = 0, #disk do
      if start == 0 and disk[i] == id then
        start = i
      elseif start ~= 0 and disk[i] ~= id then
        return start, i - start
      end
    end
    return start, #disk + 1 - start
  end

  local function find_space(min_length, max_i)
    local start, length = 0, 0
    for i = 1, max_i do
      if start == 0 and disk[i] == '.' then
        start = i
        length = 1
        if length >= min_length then
          return start
        end
      elseif start ~= 0 and disk[i] == '.' then
        length = length + 1
        if length >= min_length then
          return start
        end
      else
        start = 0
      end
    end
    return nil
  end

  local function move(id, start, length, space)
    for i = start, start + length - 1 do
      disk[i] = '.'
    end
    for i = space, space + length - 1 do
      disk[i] = id
    end
  end

  for id = disk[#disk], 0, -1 do
    local start, length = find_file(id)
    local space = find_space(length, start)
    if space then
      move(id, start, length, space)
    end
  end
end

local disk2 = read_input()
defrag_whole_files(disk2)
print(checksum_of(disk2))
