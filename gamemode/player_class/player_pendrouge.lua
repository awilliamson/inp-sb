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
PLAYER.RaceColor			= Color(20,120,225,200)
PLAYER.PlayerColor          = Vector( 20/255, 120/255, 225/255 )
PLAYER.WeaponColor          = Vector( "0.30 1.80 2.10" )

-- Specify variable to store Race name
PLAYER.RaceName				= "Pendrouge"

--GM:registerPlayerClass("player_pendrouge", PLAYER)
player_manager.RegisterClass( "player_pendrouge", PLAYER, "player_sb_base" )

