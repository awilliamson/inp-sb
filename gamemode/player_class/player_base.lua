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
PLAYER.PlayerColor          = Vector( "0.24 0.34 0.41" )
PLAYER.WeaponColor          = Vector( "0.30 1.80 2.10" )

PLAYER.suit = nil

function PLAYER:getRaceColor()
    return self.RaceColor
end

-- Specify variable to store Race name
PLAYER.RaceName				= "base"

function PLAYER:getRace()
    return self.RaceName
end

function PLAYER:getSuit()
	return self.suit
end

function PLAYER:Init()
	-- Setup player suit here to bind to a player :D
	self.suit = GM.class.getClass("PlayerSuit"):new( self.Player, GM:newResource("Oxygen"), GM:newResource("CO2") ) -- ply, breathable, respired ?
end

function PLAYER:Loadout()

    self.Player:RemoveAllAmmo()


    self.Player:GiveAmmo( 256,	"Pistol", 		true )
    self.Player:GiveAmmo( 256,	"SMG1", 		true )
    self.Player:GiveAmmo( 5,	"grenade", 		true )
    self.Player:GiveAmmo( 64,	"Buckshot", 	true )
    self.Player:GiveAmmo( 32,	"357", 			true )
    self.Player:GiveAmmo( 32,	"XBowBolt", 	true )
    self.Player:GiveAmmo( 6,	"AR2AltFire", 	true )
    self.Player:GiveAmmo( 100,	"AR2", 			true )

    self.Player:Give( "weapon_crowbar" )
    self.Player:Give( "weapon_pistol" )
    self.Player:Give( "weapon_smg1" )
    self.Player:Give( "weapon_frag" )
    self.Player:Give( "weapon_physcannon" )
    self.Player:Give( "weapon_crossbow" )
    self.Player:Give( "weapon_shotgun" )
    self.Player:Give( "weapon_357" )
    self.Player:Give( "weapon_rpg" )
    self.Player:Give( "weapon_ar2" )

    self.Player:Give( "weapon_stunstick" )


    self.Player:Give( "gmod_tool" )
    self.Player:Give( "weapon_physgun" )

    self.Player:SwitchToDefaultWeapon()

end

--
-- Called when the player spawns
--
function PLAYER:Spawn()
    BaseClass.Spawn(self)

    self.Player:SetPlayerColor( self.PlayerColor  )
    self.Player:SetWeaponColor( PLAYER.WeaponColor   )
end

--
-- Return true to draw local (thirdperson) camera - false to prevent - nothing to use default behaviour
--
function PLAYER:ShouldDrawLocal()

end

function PLAYER:GetHandsModel()
	return { model = "models/weapons/c_arms_citizen.mdl", skin = 1, body = "0000000" }
end

--
-- Allow player class to create move
--
function PLAYER:CreateMove( cmd )


end

--
-- Allow changing the player's view
--
function PLAYER:CalcView( view )


    -- Your stuff here

end

player_manager.RegisterClass( "player_sb_base", PLAYER, "player_default" ) -- This will be the baseclass


