-- this function converts a string to base64
function to_base64(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

local handle, error_message = fs.open("disk/player.txt", "r") -- "r" means "read"

if not handle then
  -- Catch failing to open the file
  error(error_message)
end

local player = handle.readAll() -- read all data in the file
handle.close() -- very important to close filehandles!

local handle, error_message = fs.open("disk/amount.txt", "r") -- "r" means "read"

if not handle then
  -- Catch failing to open the file
  error(error_message)
end

local balance = handle.readAll() -- read all data in the file
handle.close() -- very important to close filehandles!

print("Input payment amount")
local amount = read()
local newBalance = balance - amount
local newAuth = to_base64(player .. string.len(player) * newBalance)

local handle, error_message = fs.open("disk/amount.txt", "w")

if not handle then
  -- Catch failing to open the file
  error(error_message)
end

handle.write(newBalance)
handle.close()

local handle, error_message = fs.open("disk/auth.txt", "w")

if not handle then
  -- Catch failing to open the file
  error(error_message)
end

handle.write(newAuth)
handle.close()