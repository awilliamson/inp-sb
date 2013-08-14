local include = include

local includeTbl = {
	"sv_main.lua",
	"sv_chat.lua"
}

local preCacheString = 
{
	"INPSpacebuild-Shop:StartTouch",
	"INPSpacebuild-Shop:StopTouch",
	"PlayerSay",
	"AddToChatBox"
}
for _,v in pairs(includeTbl) do
	MsgN("File included: "..v)
	include(v)
end

for _,v in pairs(preCacheString) do
	util.AddNetworkString(v)
end



