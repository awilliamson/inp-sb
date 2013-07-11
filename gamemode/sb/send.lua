--[[
local tbl = string.Explode("/", debug.getinfo(1).source:sub(2) )
local currfile = table.remove(tbl)
tbl = table.concat(tbl,"/")

local exclude = {
	"cl_init.lua"
}

local f,_ = file.Find(tbl.."/*","GAME")

for k,v in pairs(f) do
	if v:sub(0,3) == "cl_" then
		if not exclude[v]  then
			MsgN(v)
			AddCSLuaFile(v)
		end
	elseif v:sub(0,3) == "sh_" then
		MsgN(v)
		AddCSLuaFile(v)
	end
end                       ]]

local AddCSLuaFile = AddCSLuaFile

local includeTbl = {
	"cl_fonts.lua",
	"cl_scoreboard.lua",
	"cl_chat.lua",
	"cl_main.lua"
}

for _,v in pairs(includeTbl) do
	MsgN("File sent: "..v)
	AddCSLuaFile(v)
end

