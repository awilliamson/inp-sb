local string = string
local file = file

require("luaunit")

local gamemodeDir = string.Explode("/",debug.getinfo(1).source, false)[2]
local path = "gamemodes/"..gamemodeDir.."/gamemode/_unit/*"

local f,_ = file.Find(path,"GAME")

for k,v in pairs(f) do
	include("../_unit/"..v)
end

--luaunit.run()