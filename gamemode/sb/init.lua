local include = include

local includeTbl = {
	"sv_main.lua"
}

for _,v in pairs(includeTbl) do
	MsgN("File included: "..v)
	include(v)
end




