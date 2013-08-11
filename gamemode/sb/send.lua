local AddCSLuaFile = AddCSLuaFile

local includeTbl = {
	"shared.lua",
	"sh_const.lua",
	"sh_util.lua",
	"sh_wrappers.lua",
	"cl_init.lua",
	"cl_fonts.lua",
	"cl_scoreboard.lua",
	"cl_chat.lua",
	"cl_main.lua",
	"cl_hud.lua"
}

for _,v in pairs(includeTbl) do
	MsgN("File sent: "..v)
	AddCSLuaFile(v)
end
