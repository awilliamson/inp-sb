local tbl = string.Explode("/", debug.getinfo(1).source:sub(2) )
local currfile = table.remove(tbl)
tbl = table.concat(tbl,"/")

local f,_ = file.Find(tbl.."/*","GAME")

for k,v in pairs(f) do
	if v:sub(0,3) == "sh_" then
		include(v)
	end
end