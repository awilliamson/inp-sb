local AddCSLuaFile = AddCSLuaFile

local includeTbl = {
	"shared.lua",
	"sh_main.lua",
	"cl_convar.lua",
	"cl_init.lua",
	"cl_fonts.lua",
	"cl_scoreboard.lua",
	--"cl_chat.lua",
	"cl_main.lua",
	"cl_hud.lua",
	"cl_worldtips.lua"
}

for _,v in pairs(includeTbl) do
	MsgN("File sent: "..v)
	AddCSLuaFile(v)
end

