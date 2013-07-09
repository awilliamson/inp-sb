----------------------------------------------------------
--				Shared Init Lua File					--
----------------------------------------------------------

-- All the Shared Lua files should be included here;

-- For Example
--inclde(sh_

DEFINE_BASECLASS( "gamemode_base" )

local include = include
local debug = debug
local file = file
local include = include
local string = string

local BaseClass = BaseClass
local GM = GM

GM.Name 	= "Inp Spacebuild"
GM.Author 	= "Inp (Radon and Sam)"
GM.Email 	= "sb@inp.io"
GM.Website	= "http://inp.io/"

GM.wrappers = {} -- Populated by sh_wrappers at a later date.

function GM:getBaseClass()
	return BaseClass
end

include("obj_player_extend.lua")

include( "player_class/player_sb_base.lua" )
include( "player_class/player_terran.lua" )
include( "player_class/player_radijn.lua" )
include( "player_class/player_pendrouge.lua" )