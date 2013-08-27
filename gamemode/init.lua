----------------------------------------------------------
--				Server Init Lua File					--
----------------------------------------------------------

-- Send things to the client
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

-- Include shared
include("shared.lua")
