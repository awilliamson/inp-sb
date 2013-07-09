AddCSLuaFile()
DEFINE_BASECLASS( "player_default" )

local GM = GM

local PLAYER = {}

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--
PLAYER.WalkSpeed 			= 200
PLAYER.RunSpeed				= 400

-- Set a Race specific colour, this will be used as an identifier
PLAYER.RaceColor			= Color(100,150,0,200)
PLAYER.PlayerColor          = Vector( 100/255, 150/255, 0/255 )
PLAYER.WeaponColor          = Vector( "0.30 1.80 2.10" )

-- Specify variable to store Race name
PLAYER.RaceName				= "Terran"

--GM:registerPlayerClass("player_terran", PLAYER)
player_manager.RegisterClass( "player_terran", PLAYER, "player_sb_base" )
