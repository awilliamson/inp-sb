local include = include

local includeTbl = {
	"sv_convar.lua",
	"sv_main.lua"
}

local preCacheString = 
{
	"INPSpacebuild-Shop:StartTouch",
	"INPSpacebuild-Shop:StopTouch"
}

for _,v in pairs(includeTbl) do
	MsgN("File included: "..v)
	include(v)
end

for _,v in pairs(preCacheString) do
	util.AddNetworkString(v)
end



