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

-- Send things to the client
include("send.lua")

-- Include shared
include("shared.lua")
include("sb/init.lua")
