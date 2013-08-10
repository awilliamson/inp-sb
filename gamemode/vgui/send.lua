local AddCSLuaFile = AddCSLuaFile

local includeTbl = {
	"cl_init.lua",
	"DChatPanel.lua"
}

for _,v in pairs(includeTbl) do
	MsgN("File sent: "..v)
	AddCSLuaFile(v)
end
