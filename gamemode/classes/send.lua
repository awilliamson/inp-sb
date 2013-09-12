local AddCSLuaFile = AddCSLuaFile

local includeTbl = {
	"class.lua",
	"Celestial.lua",
	"Environment.lua",
	"Space.lua",
	"Resource.lua",
	"Network",
	"HudComponent.lua",
	"HudPanel.lua",
	"HudBarIndicator.lua",
	"TextElement.lua",
	"HudRadialIndicator.lua",
	"PlayerSuit.lua",
}

for _,v in pairs(includeTbl) do
	MsgN("File sent: "..v)
	AddCSLuaFile(v)
end