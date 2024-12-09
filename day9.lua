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
