#!/usr/bin/env lua
--[[ 
--SuperGenPass implementation in Lua
--Version 0.2 by mnl@vandal.nu 2018
--]]
local bs = {[0] = 'A','B','C','D','E','F','G','H','I','J','K','L','M',
  'N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d',
  'e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u',
  'v','w','x','y','z','0','1','2','3','4','5','6','7','8','9','9','8'}
-- Base64 encoding 
local function base64(s)
   local pad = 2 - ((#s-1) % 3)
   s = (s..string.rep('\0', pad)):gsub("...", function(cs)
      local a, b, c = string.byte(cs, 1, 3)
      return bs[a>>2]..bs[(a&3)<<4|b>>4]..bs[(b&15)<<2|c>>6] .. bs[c&63]
   end)
   return s:sub(1, #s-pad) .. string.rep('A', pad)
end

local function valid(h)
	if (i > 10 and string.find(h, "^%l.-%d") and string.find(h, "^%l.-%u"))
		then return true
		end	return false
end

if #arg < 1 
	then
	io.stderr:write(string.format("Usage %s [domainname] [length (optional)]", arg[0]))
	os.exit(1)
end
local domain, len, dig = arg[1], arg[2], arg[3]

if (dig == nil or dig == "md5")
	then dig = require("hashings.md5") -- md5 is default
	elseif(dig == "sha512")
	then dig = require("hashings.sha512")
	else 
		print(string.format("Unknown digest: %s", dig))
		os.exit(1)
end

if (len ~= nil)
	then len = tonumber(len)
	else len = 15 -- Set default length
end

io.write("Password: ")
local master = io.read() -- Local echo still enabled!
hash = master..":"..domain

i = 0
repeat
	--[ do hashing --]
	hash = base64(dig:new(hash):digest())
	i = i + 1
until(valid(hash))

-- Cut to length and print
print(string.sub(hash,1,len))
