----------------------------------------------------------
--				Client Init Lua File					--
----------------------------------------------------------
include("shared.lua")


function IncludeClientFiles()
	local gamemodeDir = string.Explode("/",debug.getinfo(1).source, false)[2]
	
	local _, dirs = file.Find("gamemodes/"..gamemodeDir.."/gamemode/*","GAME")
	
	for _,v in pairs(dirs) do
		local files = file.Find("gamemodes/"..gamemodeDir.."/gamemode/"..v.."/*","GAME")
		for _,j in pairs(files) do
			if j:sub(0,3) == "sh_" then
				include("inpSB/gamemode/"..v.."/"..j)
			elseif j:sub(0,3) == "cl_" then 
				include("inpSB/gamemode/"..v.."/"..j)
			elseif j:sub(0,3) == "sv_" then
				--ServerSide file; Client shouldn't really have this. 
			else
				print("File: "..v.."/"..j.." is unrecognized")
			end			
		end	
	end

end


hook.Add("Initialize", "SB4: Include and Initialize (Client)", IncludeClientFiles)
