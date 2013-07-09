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
PLAYER.RaceColor			= Color(150,50,200,200)
PLAYER.PlayerColor          = Vector( 150/255, 50/255, 200/255 )
PLAYER.WeaponColor          = Vector( "0.30 1.80 2.10" )

-- Specify variable to store Race name
PLAYER.RaceName				= "Radijn"

--GM:registerPlayerClass("player_radijn", PLAYER)
player_manager.RegisterClass( "player_radijn", PLAYER, "player_sb_base" )

