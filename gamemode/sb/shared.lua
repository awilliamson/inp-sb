local include = include

local includeTbl = {
	"sh_const.lua",
	"sh_util.lua",
	"sh_wrappers.lua"
	-- Put tests here afterwards
}

for _,v in pairs(includeTbl) do
	MsgN("File included: "..v)
	include(v)
end