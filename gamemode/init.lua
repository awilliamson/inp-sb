----------------------------------------------------------
--				Server Init Lua File					--
----------------------------------------------------------

local AddCSLuaFile = AddCSLuaFile
local include = include
local string = string
local table = table
local print = print
local GM = GM

-- Send things to the client
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

-- Initialise the shared code first
include("shared.lua")

include("sb/init.lua")

AddCSLuaFile("sb/shared.lua")
include("sb/shared.lua")

--[[
local gamemodeDir = string.Explode("/",debug.getinfo(1).source, false)[2]

local function parseFiles(files)
	for _, j in pairs( files ) do

		local str = "gamemodes/"..gamemodeDir.."/gamemode/"
		j = j:sub(#str)
		j_name = table.remove( string.Explode("/",j) )

		-- Server file check
		if j_name:sub(0,3) == "sv_" then
			--include(gamemodeDir.."/gamemode/"..v.."/"..j)
			include(j)

		-- Shared file check
		elseif j_name:sub(0,3) == "sh_" then
			--AddCSLuaFile(gamemodeDir.."/gamemode/"..v.."/"..j)
			--include(gamemodeDir.."/gamemode/"..v.."/"..j)
			--MsgN("[INCLUDED]",gamemodeDir.."/gamemode/"..v.."/"..j)
			AddCSLuaFile(j)

		-- Client file check
		elseif j_name:sub(0,3) == "cl_" then 
			--AddCSLuaFile(gamemodeDir.."/gamemode/"..v.."/"..j)
			--MsgN("[ADDED]",gamemodeDir.."/gamemode/"..v.."/"..j)
			AddCSLuaFile(j)

		else
			print("File: "..j.." is unrecognised") --"..v.."/"..j.." is unrecognized")

		end			
	end	

end

local function processRecursively(path)
	local dirs = {}
	local files = {}

	local path = path
	local f = {}
	local d = {}

	_,d = file.Find(path.."/*","GAME")
	
	repeat
		for _,v in pairs(f) do
			if string.Right(v,4) == ".lua" then
				table.insert(files,path.."/"..v)
			end
		end
		for _,v in pairs(d) do
			MsgN("Dir: "..path.."/"..v)
			table.insert(dirs,path.."/"..v)
		end
		if #dirs >= 1 then
			local v = table.remove(dirs)
			f,d = file.Find(v.."/*","GAME")
			path = v
		end
	until #dirs == 0

	return files
end

parseFiles( processRecursively("gamemodes/"..gamemodeDir.."/gamemode") )
 ]]
--[[
local function getFiles(dir)
	local rtn, _ = file.Find(dir,"GAME")
	return rtn
end

local function getDirs(dir)
	local _,rtn = file.Find(dir,"GAME")
	return rtn
end

local function parseFiles(fileArray)
	for _, j in pairs( fileArray ) do
		MsgN("J: ", j)

		-- Server file check
		if j:sub(0,3) == "sv_" then
			include(gamemodeDir.."/gamemode/"..v.."/"..j)

		-- Shared file check
		elseif j:sub(0,3) == "sh_" then
			AddCSLuaFile(gamemodeDir.."/gamemode/"..v.."/"..j)
			include(gamemodeDir.."/gamemode/"..v.."/"..j)
			MsgN("[INCLUDED]",gamemodeDir.."/gamemode/"..v.."/"..j)

		-- Client file check
		elseif j:sub(0,3) == "cl_" then 
			AddCSLuaFile(gamemodeDir.."/gamemode/"..v.."/"..j)
			MsgN("[ADDED]",gamemodeDir.."/gamemode/"..v.."/"..j)

		else
			print("File: "..v.."/"..j.." is unrecognized")

		end			
	end
end

local gamemodeDir = string.Explode("/",debug.getinfo(1).source, false)[2]
	
local loopDir = "gamemodes/"..gamemodeDir.."/gamemode/*"
local files = {}

repeat
	local dirs = getDirs(loopDir)



local _, dirs = file.Find(loopDir,"GAME")

for _,v in pairs(dirs) do
	MsgN("V: ",v)
	MsgN("Path: gamemodes/"..gamemodeDir.."/gamemode/"..v.."/*")

	local files, dirs2 = file.Find("gamemodes/"..gamemodeDir.."/gamemode/"..v.."/*","GAME")

	end	
end

]]
--[[
function AddFiles()
	--Include and AddCSLuaFile all the files based on prefixes
	--Get Current Location

	local gamemodeDir = string.Explode("/",debug.getinfo(1).source, false)[2]
	
	local _, dirs = file.Find("gamemodes/"..gamemodeDir.."/gamemode/*","GAME")
	
	for _,v in pairs(dirs) do

		local files = file.Find("gamemodes/"..gamemodeDir.."/gamemode/"..v.."/*","GAME")

		for _,j in pairs(files) do

			MsgN("J: ", j)
			-- Server file check
			if j:sub(0,3) == "sv_" then
				include(gamemodeDir.."/gamemode/"..v.."/"..j)

			-- Shared file check
			elseif j:sub(0,3) == "sh_" then
				AddCSLuaFile(gamemodeDir.."/gamemode/"..v.."/"..j)
				include(gamemodeDir.."/gamemode/"..v.."/"..j)
				MsgN("[INCLUDED]",gamemodeDir.."/gamemode/"..v.."/"..j)

			-- Client file check
			elseif j:sub(0,3) == "cl_" then 
				AddCSLuaFile(gamemodeDir.."/gamemode/"..v.."/"..j)
				MsgN("[ADDED]",gamemodeDir.."/gamemode/"..v.."/"..j)

			else
				print("File: "..v.."/"..j.." is unrecognized")

			end			
		end	
	end

end


hook.Add("Initialize", "SB4: Include and Initialize (Server)", AddFiles)]]

