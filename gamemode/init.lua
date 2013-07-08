----------------------------------------------------------
--				Server Init Lua File					--
----------------------------------------------------------

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function AddFiles()
	--Include and AddCSLuaFile all the files based on prefixes
	--Get Current Location
	local gamemodeDir = string.Explode("/",debug.getinfo(1).source, false)[2]
	
	local _, dirs = file.Find("gamemodes/"..gamemodeDir.."/gamemode/*","GAME")
	
	for _,v in pairs(dirs) do
		local files = file.Find("gamemodes/"..gamemodeDir.."/gamemode/"..v.."/*","GAME")
		for _,j in pairs(files) do
			if j:sub(0,3) == "sv_" then
				include("inpSB/gamemode/"..v.."/"..j) 
			elseif j:sub(0,3) == "sh_" then
				AddCSLuaFile("inpSB/gamemode/"..v.."/"..j)
				include("inpSB/gamemode/"..v.."/"..j)
			elseif j:sub(0,3) == "cl_" then 
				AddCSLuaFile("inpSB/gamemode/"..v.."/"..j)
			else
				print("File: "..v.."/"..j.." is unrecognized")
			end			
		end	
	end
end


hook.Add("Initialize", "SB4: Include and Initialize (Server)", AddFiles)

