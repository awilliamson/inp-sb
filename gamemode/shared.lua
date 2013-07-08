----------------------------------------------------------
--				Shared Init Lua File					--
----------------------------------------------------------

-- All the Shared Lua files should be included here;

-- For Example
--inclde(sh_


GM.Name 	= "INPGame's Spacebuild"
GM.Author 	= "Radon and Sam"
GM.Email 	= ""
GM.Website	= "http://inp.io/"

local debug = debug
local file = file
local include = include
local string = string
--[[
--include("classes/cl_test.lua")
AddCSLuaFile("classes/cl_test.lua")
AddCSLuaFile("classes/sh_test.lua")


if CLIENT then include("classes/cl_test.lua") end
if SERVER then include("classes/sv_test.lua") end
include("classes/sh_test.lua")]]--

--[[
function GM:Initialize()
	if CLIENT then 
		print("Client")
	else
	--Include and AddCSLuaFile all the files based on prefixes
	
	--Get Current Location
	local gamemodeDir = string.Explode("/",debug.getinfo(1).source, false)[2]
	
	local _, dirs = file.Find("gamemodes/"..gamemodeDir.."/gamemode/*","GAME")
	
	for _,v in pairs(dirs) do
		local files = file.Find("gamemodes/"..gamemodeDir.."/gamemode/"..v.."/*","GAME")
		for _,j in pairs(files) do
			if j:sub(0,3) == "sv_" then
				if SERVER then include("inpSB/gamemode/"..v.."/"..j) end
			elseif j:sub(0,3) == "cl_" then
				if SERVER then 
					AddCSLuaFile("inpSB/gamemode/gamemode/"..v.."/"..j)
				elseif CLIENT then
					include("inpSB/gamemode/"..v.."/"..j)
				end
			elseif j:sub(0,3) == "sh_" then
				if SERVER then AddCSLuaFile("inpSB/gamemode/"..v.."/"..j) end
				include("inpSB/gamemode/"..v.."/"..j)
			end
		end	
	end
	end
end
]]--

