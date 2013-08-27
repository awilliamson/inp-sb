----------------------------------------------------------
--				Shared Init Lua File					--
----------------------------------------------------------

-- All the Shared Lua files should be included here;

-- For Example
--inclde(sh_

DEFINE_BASECLASS( "gamemode_base" )

local GM = GM
local include = include
local debug = debug
local file = file
local include = include
local string = string

local BaseClass = BaseClass

GM.Name 	= "Inp Spacebuild"
GM.Author 	= "Inp (Radon and Sam)"
GM.Email 	= "sb@inp.io"
GM.Website	= "http://inp.io/"

require "lcs"
GM.LCS = LCS
LCS = nil

GM.class = {} -- Used to create objects of classes defined in /classes
GM.convars = {} -- Used to store convars which will be used to configure spacebuild
GM.wrappers = {} -- Populated by sh_wrappers at a later date.
GM.constants = {} -- Populated by sh_const
GM.util = {} -- Populated by sh_util
GM.internal = {} -- Used for internal things like HUDs

function GM:getBaseClass()
	return BaseClass
end

function GM:loadClasses()
	local files, folders = file.Find( "gamemode/classes/*", "GAME" )
	for i=1,#files do
		include("gamemode/classes/" .. files[i])
		AddCSLuaFile( "gamemode/classes/" .. files[i] )
	end
end
GM:loadClasses()


include("obj_player_extend.lua")

include( "player_class/player_base.lua" )
include( "player_class/player_terran.lua" )
include( "player_class/player_radijn.lua" )
include( "player_class/player_pendrouge.lua" )
