
NetString = 
{
	"INPSpacebuild-Shop:StartTouch",
	"INPSpacebuild-Shop:StopTouch"
}

--[[
local tbl = string.Explode("/", debug.getinfo(1).source:sub(2) )
local currfile = table.remove(tbl)
tbl = table.concat(tbl,"/")

local f,_ = file.Find(tbl.."/*","GAME")

for k,v in pairs(f) do
	if v:sub(0,3) == "sh_" then
			MsgN(v)
			include(v)
	elseif v:sub(0,3) == "sv_" then
			MsgN(v)
			include(v)
	end
end           ]]

local include = include

local includeTbl = {
	"sv_main.lua"
}

for _,v in pairs(includeTbl) do
	MsgN("File included: "..v)
	include(v)
end

for _, v in pairs(NetString) do
	util.AddNetworkString(v)
end


