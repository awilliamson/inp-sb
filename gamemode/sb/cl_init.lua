local include = include

local includeTbl = {
	"cl_convar.lua",
	"cl_fonts.lua",
	"cl_scoreboard.lua",
	"cl_chat.lua",
	"cl_main.lua",
	"cl_hud.lua"
}

for _,v in pairs(includeTbl) do
	include(v)
end