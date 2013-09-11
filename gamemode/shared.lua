----------------------------------------------------------
--				Shared Init Lua File					--
----------------------------------------------------------

-- All the Shared Lua files should be included here;

-- For Example
--inclde(sh_

DeriveGamemode("sandbox")
--DEFINE_BASECLASS( "gamemode_base" )

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

require("lcs")
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

AddCSLuaFile("sb/sh_const.lua")
AddCSLuaFile("sb/sh_util.lua")
AddCSLuaFile("sb/sh_wrappers.lua")

AddCSLuaFile("classes/class.lua")

-- Include consts/utils/wrappers before ANYTHING!!!!
include("sb/sh_const.lua")
include("sb/sh_util.lua")
include("sb/sh_wrappers.lua")

include("obj_player_extend.lua")

include("classes/class.lua")
include("sb/shared.lua")

include( "player_class/player_base.lua" )
include( "player_class/player_terran.lua" )
include( "player_class/player_radijn.lua" )
include( "player_class/player_pendrouge.lua" )