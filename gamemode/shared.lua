----------------------------------------------------------
--				Shared Init Lua File					--
----------------------------------------------------------

-- All the Shared Lua files should be included here;

-- For Example
--inclde(sh_

DEFINE_BASECLASS( "gamemode_base" )

require "lcs"

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
GM.LCS = LCS
GM.class = {} -- Used to create objects of classes defined in /classes
GM.wrappers = {} -- Populated by sh_wrappers at a later date.
GM.constants = {} -- Populated by sh_const
GM.util = {} -- Populated by sh_util

function GM:getBaseClass()
	return BaseClass
end

include("obj_player_extend.lua")

--[[include("sb/sh_wrappers.lua")
include("sb/sh_const.lua")
include("sb/sh_util.lua")  ]]

include("sb/shared.lua")
include("classes/class.lua")

include( "player_class/player_sb_base.lua" )
include( "player_class/player_terran.lua" )
include( "player_class/player_radijn.lua" )
include( "player_class/player_pendrouge.lua" )