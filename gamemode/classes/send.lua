local AddCSLuaFile = AddCSLuaFile

local includeTbl = {
	"class.lua",
	"Celestial.lua",
	"Environment.lua",
	"Resource.lua",
	"HudComponent.lua",
	"HudPanel.lua",
	"HudBarIndicator.lua",
	"TextElement.lua",
	"HudRadialIndicator.lua"
}

for _,v in pairs(includeTbl) do
	MsgN("File sent: "..v)
	AddCSLuaFile(v)
end